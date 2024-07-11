# Manifesto TPC5

Para o quinto TPC, foi proposto a criação de um dataset de Filmes recorrendo  ao `DBPedia`. O objetivo seria especificar um query em `SPARQL` que levantava essa informação, tratava os dados e montasse o dataset capaz de realizar 4 queries propostas.

As queries propostas foram:
+ Filmes de curta metragem (menos de 1h)
+ Filmes de ação
+ Elenco de um de determinado filme
+ Filmes com um determinado ator

Para validar as queries, utilizou-se a biblioteca `Pandas` que permitia a criação e manipulação de `Dataframes`.

Entretanto, o que não foi possível realizar foi aumentar a quantidade de filmes no dataset, onde o `DBPedia` fornecia um máximo de 10000 entradas e ao recorrer a comandos como o `OFFSET` houve erros de resposta dos dados.

## Ficheiros e diretórios

+ `dbpedia_movies.py` -> Ficheiro com o script que requisitas as informações no `DBPedia`
+ `movies.json` -> Dataset criado
+ `queries.py` -> Ficheiro  om as queries utilizando `Pandas`