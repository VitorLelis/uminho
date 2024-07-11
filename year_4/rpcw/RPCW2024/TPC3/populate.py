import json

f = open("mapa-virtual.json")
data = json.load(f)
f.close()

print("""
@prefix : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xml: <http://www.w3.org/XML/1998/namespace> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@base <http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11/> .

<http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11> rdf:type owl:Ontology .

#################################################################
#    Object Properties
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#ligaSePor
:ligaSePor rdf:type owl:ObjectProperty ;
           owl:inverseOf :seLigaCom .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#seLigaCom
:seLigaCom rdf:type owl:ObjectProperty ;
           rdfs:domain :Cidade ;
           rdfs:range :Ligacao .


#################################################################
#    Data properties
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#CidadeDescricao
:CidadeDescricao rdf:type owl:DatatypeProperty ;
                 rdfs:subPropertyOf owl:topDataProperty ;
                 rdfs:domain :Cidade ;
                 rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#CidadeDistrito
:CidadeDistrito rdf:type owl:DatatypeProperty ;
                rdfs:subPropertyOf owl:topDataProperty ;
                rdfs:domain :Cidade ;
                rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#CidadeId
:CidadeId rdf:type owl:DatatypeProperty ;
          rdfs:subPropertyOf owl:topDataProperty ;
          rdfs:domain :Cidade ;
          rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#CidadeNome
:CidadeNome rdf:type owl:DatatypeProperty ;
            rdfs:subPropertyOf owl:topDataProperty ;
            rdfs:domain :Cidade ;
            rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#CidadePopulacao
:CidadePopulacao rdf:type owl:DatatypeProperty ;
                 rdfs:subPropertyOf owl:topDataProperty ;
                 rdfs:domain :Cidade ;
                 rdfs:range xsd:int .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#LigacaoDestino
:LigacaoDestino rdf:type owl:DatatypeProperty ;
                rdfs:subPropertyOf owl:topDataProperty ;
                rdfs:domain :Ligacao ;
                rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#LigacaoDistancia
:LigacaoDistancia rdf:type owl:DatatypeProperty ;
                  rdfs:subPropertyOf owl:topDataProperty ;
                  rdfs:domain :Ligacao ;
                  rdfs:range xsd:int .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#LigacaoId
:LigacaoId rdf:type owl:DatatypeProperty ;
           rdfs:subPropertyOf owl:topDataProperty ;
           rdfs:domain :Ligacao ;
           rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#LigacaoOrigem
:LigacaoOrigem rdf:type owl:DatatypeProperty ;
               rdfs:subPropertyOf owl:topDataProperty ;
               rdfs:domain :Ligacao ;
               rdfs:range xsd:string .


#################################################################
#    Classes
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#Cidade
:Cidade rdf:type owl:Class ;
        owl:disjointWith :Ligacao .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#Ligacao
:Ligacao rdf:type owl:Class .


#################################################################
#    Individuals
#################################################################
""")

for cidade in data['cidades']:
    print(f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#{cidade['id']}
:{cidade['id']} rdf:type owl:NamedIndividual ,
      :Cidade ;
      :CidadeDescricao "{cidade['descrição']}" ;
      :CidadeDistrito "{cidade['distrito']}" ;
      :CidadeId "{cidade['id']}" ;
      :CidadeNome "{cidade['nome']}" ;
      :CidadePopulacao "{cidade['população']}"^^xsd:int .
""")
    
for lig in data['ligacoes']:
    print(f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/untitled-ontology-11#{lig['id']}
:{lig['id']} rdf:type owl:NamedIndividual ,
     :Ligacao ;
     :LigacaoDestino "{lig['destino']}" ;
     :LigacaoDistancia "{lig['distância']}"^^xsd:int ;
     :LigacaoId "{lig['id']}" ;
     :LigacaoOrigem "{lig['origem']}" .
""")
    
print("""###  Generated by the OWL API (version 4.5.26.2023-07-17T20:34:13Z) https://github.com/owlcs/owlapi""")