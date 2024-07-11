import json

f = open("db.json")
data = json.load(f)
f.close()

print("""
@prefix : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xml: <http://www.w3.org/XML/1998/namespace> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@base <http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7/> .

<http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7> rdf:type owl:Ontology .

#################################################################
#    Object Properties
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#ensinadoNoCurso
:ensinadoNoCurso rdf:type owl:ObjectProperty ;
                 owl:inverseOf :instrumentoEnsinado .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#estuda
:estuda rdf:type owl:ObjectProperty ;
        owl:inverseOf :estudadoPor ;
        rdfs:domain :Aluno ;
        rdfs:range :Curso .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#estudadoPor
:estudadoPor rdf:type owl:ObjectProperty .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#instrumentoEnsinado
:instrumentoEnsinado rdf:type owl:ObjectProperty ;
                     rdfs:domain :Curso ;
                     rdfs:range :Instrumento .


#################################################################
#    Data properties
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#AlunoAno
:AlunoAno rdf:type owl:DatatypeProperty ;
          rdfs:subPropertyOf owl:topDataProperty ;
          rdfs:domain :Aluno ;
          rdfs:range xsd:int .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#AlunoCurso
:AlunoCurso rdf:type owl:DatatypeProperty ;
            rdfs:subPropertyOf owl:topDataProperty ;
            rdfs:domain :Aluno ;
            rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#AlunoId
:AlunoId rdf:type owl:DatatypeProperty ;
         rdfs:subPropertyOf owl:topDataProperty ;
         rdfs:domain :Aluno ;
         rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#AlunoInstrumento
:AlunoInstrumento rdf:type owl:DatatypeProperty ;
                  rdfs:subPropertyOf owl:topDataProperty ;
                  rdfs:domain :Aluno ;
                  rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#AlunoNasc
:AlunoNasc rdf:type owl:DatatypeProperty ;
           rdfs:subPropertyOf owl:topDataProperty ;
           rdfs:domain :Aluno ;
           rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#AlunoNome
:AlunoNome rdf:type owl:DatatypeProperty ;
           rdfs:subPropertyOf owl:topDataProperty ;
           rdfs:domain :Aluno ;
           rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#CursoDesignacao
:CursoDesignacao rdf:type owl:DatatypeProperty ;
                 rdfs:subPropertyOf owl:topDataProperty ;
                 rdfs:domain :Curso ;
                 rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#CursoDuracao
:CursoDuracao rdf:type owl:DatatypeProperty ;
              rdfs:subPropertyOf owl:topDataProperty ;
              rdfs:domain :Curso ;
              rdfs:range xsd:int .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#CursoId
:CursoId rdf:type owl:DatatypeProperty ;
         rdfs:subPropertyOf owl:topDataProperty ;
         rdfs:domain :Curso ;
         rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#InstrumentoId
:InstrumentoId rdf:type owl:DatatypeProperty ;
               rdfs:subPropertyOf owl:topDataProperty ;
               rdfs:domain :Instrumento ;
               rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#InstrumentoText
:InstrumentoText rdf:type owl:DatatypeProperty ;
                 rdfs:subPropertyOf owl:topDataProperty ;
                 rdfs:domain :Instrumento ;
                 rdfs:range xsd:string .


#################################################################
#    Classes
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#Aluno
:Aluno rdf:type owl:Class .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#Curso
:Curso rdf:type owl:Class .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#Instrumento
:Instrumento rdf:type owl:Class .


#################################################################
#    Individuals
#################################################################
""")

for aluno in data['alunos']:
    print(f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#A1510
:{aluno['id']} rdf:type owl:NamedIndividual ,
                :Aluno ;
       :estuda :{aluno['curso']} ;
       :AlunoAno "{aluno['anoCurso']}"^^xsd:int ;
       :AlunoCurso "{aluno['curso']}" ;
       :AlunoId "{aluno['id']}" ;
       :AlunoInstrumento "{aluno['instrumento']}" ;
       :AlunoNasc "{aluno['dataNasc']}" ;
       :AlunoNome "{aluno['nome']}" .
""")
    
for curso in data['cursos']:
    print(f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#CB8
:{curso['id']} rdf:type owl:NamedIndividual ,
              :Curso ;
     :instrumentoEnsinado :{curso['instrumento']['id']} ;
     :CursoDesignacao "{curso['designacao']}" ;
     :CursoDuracao "{curso['duracao']}"^^xsd:int ;
     :CursoId "{curso['id']}" .
""")
    
for instrumento in data['instrumentos']:
    print(f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-7#I8
:{instrumento['id']} rdf:type owl:NamedIndividual ,
             :Instrumento ;
    :InstrumentoId "{instrumento['id']}" ;
    :InstrumentoText "{instrumento['#text']}" .
""")
    
print("###  Generated by the OWL API (version 4.5.26.2023-07-17T20:34:13Z) https://github.com/owlcs/owlapi")