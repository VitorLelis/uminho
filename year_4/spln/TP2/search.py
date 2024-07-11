import json
from gensim.utils import tokenize
import nltk
from gensim.models import TfidfModel
from gensim.corpora import Dictionary
from gensim.similarities import SparseMatrixSimilarity

# nltk.download('stopwords')
stopwords = set(nltk.corpus.stopwords.words('portuguese'))

# Carregar o JSON
with open('dre.json', 'r') as j:
    documents = json.load(j)

# Pre processamento das palavras para garantir coesao nas frases fornecidas
def preprocess(line):
    line = line.lower()
    tokens = list(tokenize(line))
    tokens = [token for token in tokens if token not in stopwords]
    return tokens

# Pre processamento das notas
sentences = [preprocess(doc["notes"]) for doc in documents]

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

# Função de procura para os textos com mais semelhança a query e com limitador de documentos
def search_query(query,number):
    query_tokenized = preprocess(query)

    query_bow = dictionary.doc2bow(query_tokenized)
    tfidf_query = tfidf_model[query_bow]

    sims = index[tfidf_query]

    sims_ordered = sorted(enumerate(sims), key= lambda item: item[1], reverse = True)

    result = [documents[id] for id,_ in sims_ordered[:number]]

    return result
