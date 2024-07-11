# Manifesto TPC3

Para o terceiro TPC, utilizei a ferramenta _Protégé_ de forma semelhante ao que foi feito no TPC1 e TPC2 mas tendo em conta os dados fornecidos e como poderia relacionar os objetos da melhor forma possível.

Ao gerar o o ficheiro TTL resultante, testei sua veracidade no próprio _Protégé_ e depois o importei em uma versão local do _GraphDB_ que corria em um container Docker da minha máquina.

Por fim realizei as queries propostas para garantir uma boa execução da Ontologia feita. Todas correram bem exceto a 3 que não consegui obter o resultado devido.

## Ficheiros

+ ```mapa-virtual.json``` -> Fonte de dados
+ ```populate.py``` -> Script gerador do TTL
+ ```queries.md``` -> Ficheiro MD com as queries feitas
+ ```tpc3-result.ttl``` -> Ficheiro TTL final