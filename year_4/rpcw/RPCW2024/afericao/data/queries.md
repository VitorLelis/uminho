# Queries

## Quantos alunos estão registados? (inteiro)
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select (count(?s) as ?number) where{
    ?s rdf:type :Aluno .
}
```

## Quantos alunos frequentam o curso "LCC"? (inteiro)

```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select (count(?s) as ?number) where{
    ?s rdf:type :Aluno ;
       :curso "LCC" .
}
```

## Que alunos tiveram nota positiva no exame de época normal? (lista ordenada alfabeticamente por nome com: idAluno, nome, curso, nota do exame);

```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select ?idAluno ?nome ?curso ?nota where{
    ?s rdf:type :Aluno ;
		:idAluno ?idAluno;
		:nome ?nome;
		:curso ?curso;
     	:realiza ?exame .
	?exame rdf:type :Normal ;
			:notaExame ?nota .
filter(?nota >= 10.0 )
} order by ?nome
```

## Qual a distribuição dos alunos pelas notas do projeto? (lista com: nota e número de alunos que obtiveram essa nota)
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select ?nota (count(?s) as ?alunos) where{
    ?s rdf:type :Aluno ;
		:projeto ?nota .
} group by ?nota
order by desc(?nota)
```

## Quais os alunos mais trabalhadores durante o semestre? (lista ordenada por ordem decrescente do total: idAluno, nome, curso, total = somatório dos resultados dos TPC)
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select ?idAluno ?nome ?curso (sum(?nota) as ?total) where{
    ?s rdf:type :Aluno ;
		:idAluno ?idAluno;
  		:nome ?nome;
    	:curso ?curso;
     	:entrega ?tpc .
    ?tpc :notaTPC ?nota .
} group by ?idAluno ?nome ?curso
order by desc (?total)
```
## Qual a distribuição dos alunos pelos vários cursos? (lista de cursos, ordenada alfabeticamente por curso, com: curso, número de alunos nesse curso)
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select ?curso (count(?s) as ?alunos) where{
    ?s rdf:type :Aluno ;
       :curso ?curso
} group by ?curso
order by ?curso
```