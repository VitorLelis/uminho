# Queries 

## Quantidade de Filmes

```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix : <http://rpcw.di.uminho.pt/2024/cinema/>

select (count(?s) as ?total) where {
    ?s rdf:type :Film .
}
```

## Filmes por ano

```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix : <http://rpcw.di.uminho.pt/2024/cinema/>

select (count(?s) as ?numero) ?year where {
    ?s rdf:type :Film ;
       :date ?year
    
} group by ?year
```

## Filmes por genero

```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix : <http://rpcw.di.uminho.pt/2024/cinema/>

select (count(?s) as ?numero) ?genre where {
    ?s rdf:type :Film ;
       :hasGenre ?genre
    
} group by ?genre
```

## Filmes do Burt Reynolds
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix : <http://rpcw.di.uminho.pt/2024/cinema/>

select ?movie where {
    ?movie rdf:type :Film ;
       :hasActor :BurtReynolds
}
```

## Quantidade de filmes por diretor
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix : <http://rpcw.di.uminho.pt/2024/cinema/>

select ?director (COUNT(?s) as ?movies) where {
	?s rdf:type :Film ;
    	:hasDirector ?director .
} group by ?director
```