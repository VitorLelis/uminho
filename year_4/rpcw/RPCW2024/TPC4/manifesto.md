# Manifesto TPC4

Para o quarto TPC, foi fornecido um ficheiro .ttl com dados sobre os elementos da Tabela Periódica. A partir das informações contidas, foi proposto criar uma página web com as informações dos elementos e dos grupos respetivos grupos.

Primeiramente, definiu-se queries de SPARQL que retornavam os valores desejados e criou-se um script que realiza requests para o GraphDB para retornar os dados.

Com os dados em mão, criou-se templates de HTML que utilizavam essas informações obtidas em queries e gerava a página web desejada.

## Ficheiros e diretórios

+ ```static``` -> Diretório com favicon e as definições de CSS
+ ```template``` -> Diretório com os ficheiros HTML
+ ```app.py``` -> Ficheiro Python que corre a aplicação Web
+ ```tabela-periodica.ttl``` -> Ficheiro TTL de dados