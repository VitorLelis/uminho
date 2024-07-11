# Manifesto TPC6

Para o sexto e último TPC, foi necessário utilizar o dataset criado no TPC anterior e gerar um serviço web com as informações devidamente representadas.

O processo conteve os seguintes passos:

1. Criação de uma Ontologia com os dados recolhidos no Dataset (feito na aula do dia 19/03/2024);
1. Carregar de forma correta no endpoint fornecido;
1. Realizar um conjunto de queries para garantir a extração correta dos dados;
1. Criação de uma página web utilizando ```Flask``` para representar os dados através de uma API.

## Ficheiros e diretórios

+ ```dataset``` -> Diretório com o código para a geração da Ontologia
    + ```movies.ttl``` -> Template feito no _Protegé_
    + ```movies.json``` -> Dataset feito no TPC5
    + ```movies.py``` -> Script para popular a Ontologia
    + ```movies-54273.ttl``` -> Resultado da Ontologia com a população
+ ```app``` -> Diretório com o código para a página web
    + ```static``` -> Diretório com favicon e as definições de CSS
    + ```template``` -> Diretório com os ficheiros HTML
    + ```app.py``` -> Ficheiro Python que corre a aplicação Web
+ ```queries.md``` -> Ficheiro com as queries teste 
