# Manifesto TPC2

Para o segundo TPC, utilizei a ferramenta _Protégé_ de forma semelhante ao que foi feito no TPC1 mas tendo em conta os dados fornecidos e como poderia relacionar os objetos da melhor forma possível.

Ao gerar o o ficheiro TTL resultante, testei sua veracidade no próprio _Protégé_ e depois o importei em uma versão local do _GraphDB_ que corria em um container Docker da minha máquina.

## Ficheiros

+ ```db.json``` -> Fonte de dados
+ ```populate.py``` -> Script gerador do TTL
+ ```template.ttl``` -> Ficheiro TTL de base
+ ```result.ttl``` -> Ficheiro TTL final

## Comandos

### Gerar TTL
    python3 populate.py > result.ttl

### Restart Docker
    docker restart graphdb