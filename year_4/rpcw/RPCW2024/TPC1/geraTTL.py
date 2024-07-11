import json

f = open("plantas.json")
plants = json.load(f)
f.close()

def treat_comma(value: str) -> str:
    return value.replace('"','\\"')

print("""@prefix : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xml: <http://www.w3.org/XML/1998/namespace> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@base <http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3/> .

<http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3> rdf:type owl:Ontology .

#################################################################
#    Object Properties
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#possui
:possui rdf:type owl:ObjectProperty ;
        rdfs:domain :Rua ;
        rdfs:range :Planta .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#se_encontra
:se_encontra rdf:type owl:ObjectProperty ;
             rdfs:domain :Planta ;
             rdfs:range :Rua .


#################################################################
#    Data properties
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Caldeira
:Caldeira rdf:type owl:DatatypeProperty ;
          rdfs:domain :Planta ;
          rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Codigo_de_rua
:Codigo_de_rua rdf:type owl:DatatypeProperty ;
               rdfs:domain :Rua ;
               rdfs:range xsd:long .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Data_de_Plantacao
:Data_de_Plantacao rdf:type owl:DatatypeProperty ;
                   rdfs:domain :Planta ;
                   rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Data_de_actualizacao
:Data_de_actualizacao rdf:type owl:DatatypeProperty ;
                      rdfs:domain :Planta ;
                      rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Especie
:Especie rdf:type owl:DatatypeProperty ;
         rdfs:domain :Planta ;
         rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Estado
:Estado rdf:type owl:DatatypeProperty ;
        rdfs:domain :Planta ;
        rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Freguesia
:Freguesia rdf:type owl:DatatypeProperty ;
           rdfs:domain :Rua ;
           rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Gestor
:Gestor rdf:type owl:DatatypeProperty ;
        rdfs:domain :Planta ;
        rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Id
:Id rdf:type owl:DatatypeProperty ;
    rdfs:domain :Planta ;
    rdfs:range xsd:long .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Implantacao
:Implantacao rdf:type owl:DatatypeProperty ;
             rdfs:domain :Planta ;
             rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Local
:Local rdf:type owl:DatatypeProperty ;
       rdfs:domain :Rua ;
       rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Nome_Cientifico
:Nome_Cientifico rdf:type owl:DatatypeProperty ;
                 rdfs:domain :Planta ;
                 rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Numero_de_Registo
:Numero_de_Registo rdf:type owl:DatatypeProperty ;
                   rdfs:domain :Planta ;
                   rdfs:range xsd:int .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Numero_de_intervencoes
:Numero_de_intervencoes rdf:type owl:DatatypeProperty ;
                        rdfs:domain :Planta ;
                        rdfs:range xsd:int .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Origem
:Origem rdf:type owl:DatatypeProperty ;
        rdfs:domain :Planta ;
        rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Rua
:Rua rdf:type owl:DatatypeProperty ;
     rdfs:domain :Planta ,
                 :Rua ;
     rdfs:range xsd:string .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Tutor
:Tutor rdf:type owl:DatatypeProperty ;
       rdfs:domain :Planta ;
       rdfs:range xsd:string .


#################################################################
#    Classes
#################################################################

###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Planta
:Planta rdf:type owl:Class .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/untitled-ontology-3#Rua
:Rua rdf:type owl:Class .


#################################################################
#    Individuals
#################################################################
""")

for p in plants:
    registro =f"""
###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/plantas#{p['Código de rua']}
<http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/plantas#{p['Código de rua']}> rdf:type owl:NamedIndividual ;
                                                                                       :possui <http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/plantas#{p['Id']}> ;
                                                                                       :Codigo_de_rua "{p['Código de rua']}"^^xsd:long ;
                                                                                       :Freguesia "{p['Freguesia']}" ;
                                                                                       :Local "{p['Local']}" ;
                                                                                       :Rua "{treat_comma(p['Rua'])}" .


###  http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/plantas#{p['Id']}
<http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/plantas#{p['Id']}> rdf:type owl:NamedIndividual ;
                                                                                        :se_encontra <http://www.semanticweb.org/lelis_vitor/ontologies/2024/1/plantas#{p['Código de rua']}> ;
                                                                                        :Caldeira "{p['Caldeira']}" ;
                                                                                        :Data_de_Plantacao "{p['Data de Plantação']}" ;
                                                                                        :Data_de_actualizacao "{p['Data de actualização']}" ;
                                                                                        :Especie "{p['Espécie']}" ;
                                                                                        :Estado "{p['Estado']}" ;
                                                                                        :Gestor "{p['Gestor']}" ;
                                                                                        :Id "{p['Id']}"^^xsd:long ;
                                                                                        :Implantacao "{p['Implantação']}" ;
                                                                                        :Nome_Cientifico "{p['Nome Científico']}" ;
                                                                                        :Numero_de_Registo "{p['Número de Registo']}"^^xsd:int ;
                                                                                        :Numero_de_intervencoes "{p['Número de intervenções']}"^^xsd:int ;
                                                                                        :Origem "{p['Origem']}" ;
                                                                                        :Rua "{treat_comma(p['Rua'])}" ;
                                                                                        :Tutor "{p['Tutor']}" .
"""
    print(registro)

print("""###  Generated by the OWL API (version 4.5.26.2023-07-17T20:34:13Z) https://github.com/owlcs/owlapi""")