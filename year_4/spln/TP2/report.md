# Trabalho Prático 2 (TP2)

O objetivo deste trabalho prático era criar diversos programas que, no contexto de uma base de dados de documentos do Diário da República, nos permitissem extrair informação, utilizando ferramentas aprendidas nas aulas.


Foi nos fornecida uma base de conhecimento do diário da república composta por 2 tabelas: uma contendo os metadados dos textos, e outra contendo os textos propriamente ditos.

Além disto, temos também um json que devemos utilizar como pequena amostra da BD como um todo, pois possui os ids correspondentes aos documentos e os textos que os resumem.

## Conexão e Consultas à Base de Dados
O primeiro passo que tomamos foi importar a base de dados e criar um script de python `bd_connection.py`.

Este script corre uma função que faz a conexão à base de dados, e que recebe um dicionário.

Este dicionário é composto por entradas correspondentes a ids do json, dos ficheiros sobre os quais é necessário realizar consulta. 

A forma como obtemos este dicionário será explicada posteriormente.

Estes ids são mapeados cada um para um novo dicionário, onde as chaves são os nomes das colunas de ambas as tabelas, e os valores são bools. No caso de o bool ser True, indica que a query deve recolher o valor dessa coluna na linha do ficheiro de id fornecido. Isto deve ser feito para todas as entradas (ids de ficheiros) contidos no dicionário, de modo a consultar informação de todos os ficheiros relevantes.

Exemplo:
```py
dict = {
    1: {
        "document_id" : True, 
        "type" : False, 
        "reference" : True,
        "issuer" : False,
        "source" : True,
        "details" : False,
        "published" : False,
        "reserved" : False,        
        "publication_date " : False,
        "content" : False,       
        "pdf_url" : False,         
        "htm_url" : False,         
        "is_deleted" : False,     
        "created_at" : True,      
        "is_canceled" : False,    
        "doc_number"  : False,     
        "doc_version" : False,    
        "priority" : False,
        "reference_t" : False,
        "created_at_t" : True,
        "url_t" : False,
        "document_text_t" : True 
    },
}
```
Colocamos `_t` no fim do nome de certas colunas para diferenciar as colunas de ambas as tabelas.

O script recolhe todas as colunas com o value `True`, que serão as colunas pedidas na query SQL à base de dados.

Depois, para cada id, é criada a query com o mesmo e com as colunas pedidas.

```py
# construcao da query à tabela public.dreapp_document
if document_flags:
    query_document = "SELECT "
    query_document += ', '.join(str(num) for num in document_flags)
    query_document += f" FROM public.dreapp_document WHERE id = {id}"

# construcao da query à tabela public.dreapp_documenttext
if text_flags:
    query_text = "SELECT "
    query_text += ', '.join(str(num) for num in text_flags)
    query_text += f" FROM public.dreapp_documenttext WHERE id = {id}"
```

Estas queries são depois executadas, e o seu resultado é guardado em variáveis que serão adicionadas à resposta que deve ser retornada.

Esta resposta é escrita num ficheiro `answer.txt` no final de toda a execução.

Por fim, o script encerra a conexão à BD.

## Recolha de Informação a partir dos documentos

Como mencionamos anteriormente, a função que realiza a conexão à base de dados recebe um dicionário para realizar as queries. Este dicionário guarda os ficheiros que devem ser consultados.

Para recolher os ficheiros mais semelhantes à pesquisa, utilizamos o TF-IDF da biblioteca gensim, pois ela gera modelos que lidam bem com fontes de dados extensas, como é o nosso caso. A abordagem consiste na criação do modelo com base no dicionário de palavras presentes, gerando uma SparseMatrix com as pontuações de cada documento que possuímos.

Após isso, a consulta é convertida para letras minúsculas, tokenizada e as _stopwords_ são removidas. Em seguida, a consulta processada é inserida no modelo para calcular sua similaridade com os textos dos documentos, retornando os N documentos mais semelhantes.

```py
def search_query(query,number):
    query_tokenized = preprocess(query)

    query_bow = dictionary.doc2bow(query_tokenized)
    tfidf_query = tfidf_model[query_bow]

    sims = index[tfidf_query]

    sims_ordered = sorted(enumerate(sims), key= lambda item: item[1], reverse = True)

    result = [documents[id] for id,_ in sims_ordered[:number]]

    return result
```

Outro cuidado necessário foi a demora para preparar cada pergunta. Como não há necessidade de construir o dicionário, o modelo e a matriz do zero para cada consulta, optou-se por tentar primeiro procurar alguns desses já existentes. Caso não fossem encontrados, aí sim procederíamos com a criação dos mesmos, seguido do salvamento dos atuais.

```py
# Tenta carregar um dicionario pré-salvo, se não, o cria e deixa salvo para próximas iterações
try:
    dictionary = Dictionary.load('dictionary.gensim')
except:
    dictionary = Dictionary(sentences)
    dictionary.save('dictionary.gensim') 

# Converte as frases processadas em um formato "Bag of Words" usando o dicionario
corpus_bow = [dictionary.doc2bow(sent) for sent in sentences]

# O mesmo que o dicionario, porém para o modelo TF-IDF
try:
    tfidf_model = TfidfModel.load('tfidf_model.gensim')
except:
    tfidf_model = TfidfModel(corpus_bow, normalize=True)
    tfidf_model.save('tfidf_model.gensim')  

# Tambem semelhante ao dicionario, mas para o index
try:
    index = SparseMatrixSimilarity.load('similarity_index.gensim')
except:
    index = SparseMatrixSimilarity(tfidf_model[corpus_bow], num_features=len(dictionary))
    index.save('similarity_index.gensim')
```

## Menu de Interação

Por fim, criou-se no `main.py` um menu de interação responsável por conectar os dois módulos que realizam as funções descritas. Este menu recebe a consulta do utilizador, procura os documentos mais semelhantes e, em seguida, busca na base de dados as informações desses documentos.