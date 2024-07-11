# Manifesto TPC1

Para a realização do primeiro TPC, utilizei a ferramenta _Protégé_ para criar um exemplo de ficheiro TTL baseado na Ontologia alvo.

Com isso feito, iterei sobre as entradas do JSON fonte, redirecionei o output para um ficheiro de resultado e escrevi o texto resultante no ficheiro desejado.

Finalmente, para garantir que o ficheiro criado está correto, importei o mesmo no _Protégé_ para conferir que as entradas e relações foram criadas corretamente.

## Ficheiros

+ ```plantas.json``` -> Fonte de dados
+ ```geraTTL.py``` -> Script gerador do TTL
+ ```protege.ttl``` -> Ficheiro TTL de base
+ ```result.ttl``` -> Ficheiro TTL final