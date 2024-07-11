# Queries

## Quais as cidades de um determinado distrito?
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11/>

select ?cidades where { 
    ?s rdf:type :Cidade .
    ?s :CidadeDistrito "Braga" .
    ?s :CidadeNome ?cidades .
}
```
## Distribuição de cidades por distrito?
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11/>

select ?distrito (COUNT(?s) as ?numeroCidades) where { 
    ?s rdf:type :Cidade .
    ?s :CidadeDistrito ?distrito .
}

group by ?distrito
```
## Quantas cidades se podem atingir a partir do Porto?
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

select (COUNT(?d) as ?quantidade) where { 
    ?c rdf:type :Cidade .
    ?c :CidadeDistrito "Porto" .
    ?l :rdf:type :Ligacao .
    ?l :LigacaoOrigem* (xsd:string(?c)) .
    ?l :LigacaoDestino ?d
}
```
## Quais as cidades com população acima de um determinado valor?
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11/>

select ?nomesCidades where { 
    ?c rdf:type :Cidade .
    ?c :CidadeNome ?nomesCidades .
    ?c :CidadePopulacao ?p .
    FILTER (?p > 10000)
}
```