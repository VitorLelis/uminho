from json import load

f = open('aval-alunos.json')
js = load(f)
f.close()

print("""
@prefix : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xml: <http://www.w3.org/XML/1998/namespace> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@base <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/> .

<http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo> rdf:type owl:Ontology .

#################################################################
#    Object Properties
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#entrega
:entrega rdf:type owl:ObjectProperty ;
         owl:inverseOf :entreguePor ;
         rdfs:domain :Aluno ;
         rdfs:range :TPC .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#entreguePor
:entreguePor rdf:type owl:ObjectProperty .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#realiza
:realiza rdf:type owl:ObjectProperty ;
         owl:inverseOf :realizadoPor ;
         rdfs:domain :Aluno ;
         rdfs:range :Exame .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#realizadoPor
:realizadoPor rdf:type owl:ObjectProperty .


#################################################################
#    Data properties
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#curso
:curso rdf:type owl:DatatypeProperty ;
       rdfs:domain :Aluno ;
       rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#idAluno
:idAluno rdf:type owl:DatatypeProperty ;
         rdfs:domain :Aluno ;
         rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#idExame
:idExame rdf:type owl:DatatypeProperty ;
         rdfs:domain :Exame ;
         rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#idTPC
:idTPC rdf:type owl:DatatypeProperty ;
       rdfs:domain :TPC ;
       rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#nome
:nome rdf:type owl:DatatypeProperty ;
      rdfs:domain :Aluno ;
      rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#notaExame
:notaExame rdf:type owl:DatatypeProperty ;
           rdfs:domain :Exame ;
           rdfs:range xsd:decimal .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#notaTPC
:notaTPC rdf:type owl:DatatypeProperty ;
         rdfs:domain :TPC ;
         rdfs:range xsd:decimal .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#numeroTPC
:numeroTPC rdf:type owl:DatatypeProperty ;
           rdfs:domain :TPC ;
           rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#projeto
:projeto rdf:type owl:DatatypeProperty ;
         rdfs:domain :Aluno ;
         rdfs:range xsd:decimal .


#################################################################
#    Classes
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#Aluno
:Aluno rdf:type owl:Class .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#Especial
:Especial rdf:type owl:Class ;
          rdfs:subClassOf :Exame .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#Exame
:Exame rdf:type owl:Class .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#Normal
:Normal rdf:type owl:Class ;
        rdfs:subClassOf :Exame .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#Recurso
:Recurso rdf:type owl:Class ;
         rdfs:subClassOf :Exame .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#TPC
:TPC rdf:type owl:Class .


#################################################################
#    Individuals
#################################################################
""")

for entry in js['alunos']:
    print(f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#{entry["idAluno"]}
:{entry["idAluno"]} rdf:type owl:NamedIndividual ,
                 :Aluno ;
                 :curso "{entry["curso"]}" ;
                 :idAluno "{entry["idAluno"]}" ;
                 :nome "{entry["nome"]}" ;
                 :projeto {float(entry["projeto"])} ;""")
    
    for tp in entry['tpc']:
        print(f"""                 :entrega :{tp['tp']}-{entry["idAluno"]} ;""")

    
    print(f"""                 :realiza :especial-{entry["idAluno"]} ,
                 :normal-{entry["idAluno"]} ,
                 :recurso-{entry["idAluno"]} .""")
    print(f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#especial-{entry["idAluno"]}
    :especial-{entry["idAluno"]} rdf:type owl:NamedIndividual ,
                              :Especial ;
                     :idExame "especial-{entry["idAluno"]}" ;
                     :notaExame {entry['exames'].get('especial',0.0)} .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#normal-{entry["idAluno"]}
    :normal-{entry["idAluno"]} rdf:type owl:NamedIndividual ,
                            :Normal ;
                   :idExame "normal-{entry["idAluno"]}" ;
                   :notaExame {entry['exames'].get('normal',0.0)} .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#recurso-{entry["idAluno"]}
    :recurso-{entry["idAluno"]} rdf:type owl:NamedIndividual ,
                             :Recurso ;
                    :idExame "recurso-{entry["idAluno"]}" ;
                    :notaExame {entry['exames'].get('recurso',0.0)} .
    """)

    for tp in entry['tpc']:
        print(f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/teste_modelo#tpc2-{entry["idAluno"]}
:tpc2-{entry["idAluno"]} rdf:type owl:NamedIndividual ,
                      :TPC ;
             :idTPC "{tp['tp']}-{entry["idAluno"]}" ;
             :notaTPC {tp['nota']} ;
             :numeroTPC "{tp['tp']}" .
""")

print("###  Generated by the OWL API (version 4.5.26.2023-07-17T20:34:13Z) https://github.com/owlcs/owlapi")