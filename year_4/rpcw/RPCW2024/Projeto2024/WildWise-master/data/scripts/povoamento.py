import json
from aux import *
from rdflib import Graph, Namespace, Literal, RDF, URIRef
from rdflib.namespace import RDFS, OWL, XSD

ont = Namespace("http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/")
ex = Namespace("http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34#")
  
g = Graph()
g.bind("ont", ont)
g.bind("ex", ex)

f = open("../animals.json")
data = json.load(f)
f.close()

# adicionar classes da ontologia
classes = {
    "Animal": ["idAnimal", "nomeAnimal", "comprimento", "altura", "peso", "gestacao", "incubacao","tempoVida", "dieta", "presas", "predadores", "nrEspecies", "tipoPele"],
    "Taxonomia": ["idTaxonomia", "nomeCientifico", "reino", "familia", "ordem", "classe", "genero", "filo"],
    "Cor": ["idCor", "nomeCor"],
    "Habitat": ["idHabitat", "nomeHabitat"],
    "Localizacao": ["idLocalizacao", "nomeLocalizacao"]
}

for cls, properties in classes.items():
    cls_uri = ont[cls]
    g.add((cls_uri, RDF.type, OWL.Class))
    for prop in properties:
        prop_uri = ont[prop]
        g.add((prop_uri, RDF.type, RDF.Property))
        g.add((prop_uri, RDFS.domain, cls_uri))
        g.add((prop_uri, RDFS.range, XSD.string))

# adicionar relações

relations = {
    "coloracao": ("Animal", "Cor"),
    "habitaEm": ("Animal", "Habitat"),
    "existeEm": ("Animal", "Localizacao"),
    "identificadoPor": ("Animal", "Taxonomia")
}

for rel, (dom, ran) in relations.items():
    rel_uri = ont[rel]
    g.add((rel_uri, RDF.type, RDF.Property))
    g.add((rel_uri, RDFS.domain, ont[dom]))
    g.add((rel_uri, RDFS.range, ont[ran]))

def populate_ontology(graph, data):
    numero_animal = 1
    numero_taxonomia = 1
    numero_cor = 1
    numero_habitat = 1
    numero_localizacao = 1

    locations_from_characteristics = []
    existing_colors = set()
    existing_locations = set()
    existing_habitats = set()
    existing_taxonomias = set()

    
    for animal in data:
        id_animal = "a" + str(numero_animal)
        numero_animal +=1
        animal_uri = URIRef(f"http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34#{id_animal}")
        graph.add((animal_uri, RDF.type, ont.Animal))
        graph.add((animal_uri, ont.idAnimal, Literal(id_animal, datatype=XSD.string)))

        
        # tratar do nome
        if animal['name']:
            animal_name = animal['name'].replace(' ','-')
            graph.add((animal_uri, ont.nomeAnimal, Literal(animal_name, datatype=XSD.string)))
        
        # tratar da taxonomia do animal
        if animal['taxonomy']:
            id_taxonomia = "t" + str(numero_taxonomia)

            if id_taxonomia not in existing_taxonomias:
                numero_taxonomia += 1
                taxonomy_uri = URIRef(f"http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34#{id_taxonomia}")
                graph.add((taxonomy_uri, RDF.type, ont.Taxonomy)) # adicionar a taxonomia à ontologia
                graph.add((taxonomy_uri, ont.idTaxonomia, Literal(id_taxonomia, datatype=XSD.string))) # adicionar id

                if 'scientific_name' in animal['taxonomy']:
                    graph.add((taxonomy_uri, ont.nomeCientifico, Literal(animal['taxonomy']['scientific_name'], datatype=XSD.string)))
                else:
                    graph.add((taxonomy_uri, ont.nomeCientifico, Literal("Unknown", datatype=XSD.string)))
                
                if 'kingdom' in animal['taxonomy']:
                    graph.add((taxonomy_uri, ont.reino, Literal(animal['taxonomy']['kingdom'], datatype=XSD.string)))
                else:
                    graph.add((taxonomy_uri, ont.nomeCientifico, Literal("Unknown", datatype=XSD.string)))
                
                if 'family' in animal['taxonomy']:
                    graph.add((taxonomy_uri, ont.familia, Literal(animal['taxonomy']['family'], datatype=XSD.string)))
                else:
                    graph.add((taxonomy_uri, ont.nomeCientifico, Literal("Unknown", datatype=XSD.string)))
                
                if 'order' in animal['taxonomy']:
                    graph.add((taxonomy_uri, ont.ordem, Literal(animal['taxonomy']['order'], datatype=XSD.string)))
                else:
                    graph.add((taxonomy_uri, ont.nomeCientifico, Literal("Unknown", datatype=XSD.string)))
                
                if 'class' in animal['taxonomy']:
                    graph.add((taxonomy_uri, ont.classe, Literal(animal['taxonomy']['class'], datatype=XSD.string)))
                else:
                    graph.add((taxonomy_uri, ont.nomeCientifico, Literal("Unknown", datatype=XSD.string)))
                
                if 'genus' in animal['taxonomy']:
                    graph.add((taxonomy_uri, ont.genero, Literal(animal['taxonomy']['genus'], datatype=XSD.string)))
                else:
                    graph.add((taxonomy_uri, ont.nomeCientifico, Literal("Unknown", datatype=XSD.string)))
                
                if 'phylum' in animal['taxonomy']:
                    graph.add((taxonomy_uri, ont.filo, Literal(animal['taxonomy']['phylum'], datatype=XSD.string)))            
                else:
                    graph.add((taxonomy_uri, ont.nomeCientifico, Literal("Unknown", datatype=XSD.string)))

                existing_taxonomias.add(id_taxonomia) # adicionar nas taxonomias existentes

            graph.add((animal_uri, ont.identificadoPor, taxonomy_uri)) # adicionar a relacao da taxonomia com o animal à ontologia

        # tratar das caracteristicas do animal
        if animal['characteristics']: # verificar se o animal tem as caracteristicas presentes
            # tratar caracteristicas simples que serao atributos do animal
            if 'lenght' in animal['characteristics']:
                graph.add((animal_uri, ont.comprimento, Literal(animal['characteristics']['length'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.comprimento, Literal("Unknown", datatype=XSD.string)))

            if 'height' in animal['characteristics']:
                graph.add((animal_uri, ont.altura, Literal(animal['characteristics']['height'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.altura, Literal("Unknown", datatype=XSD.string)))

            if 'weight' in animal['characteristics']:    
                graph.add((animal_uri, ont.peso, Literal(animal['characteristics']['weight'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.peso, Literal("Unknown", datatype=XSD.string)))

            if 'gestation_period' in animal['characteristics']:
                graph.add((animal_uri, ont.gestacao, Literal(animal['characteristics']['gestation_period'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.gestacao, Literal("Unknown", datatype=XSD.string)))

            if 'incubation_period' in animal['characteristics']:
                graph.add((animal_uri, ont.incubacao, Literal(animal['characteristics']['incubation_period'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.incubacao, Literal("Unknown", datatype=XSD.string)))

            if 'lifespan' in animal['characteristics']:
                graph.add((animal_uri, ont.tempoVida, Literal(animal['characteristics']['lifespan'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.tempoVida, Literal("Unknown", datatype=XSD.string)))
            
            if 'diet' in animal['characteristics']:
                graph.add((animal_uri, ont.dieta, Literal(animal['characteristics']['diet'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.tempoVida, Literal("Unknown", datatype=XSD.string)))

            if 'predators' in animal['characteristics']:    
                graph.add((animal_uri, ont.predadores, Literal(animal['characteristics']['predators'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.predadores, Literal("Unknown", datatype=XSD.string)))

            if 'prey' in animal['characteristics']:
                graph.add((animal_uri, ont.presas, Literal(animal['characteristics']['prey'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.predadores, Literal("Unknown", datatype=XSD.string)))

            if 'number_of_species' in animal['characteristics']:
                graph.add((animal_uri, ont.nrEspecies, Literal(animal['characteristics']['number_of_species'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.predadores, Literal("Unknown", datatype=XSD.string)))
            
            if 'skin_type' in animal['characteristics']:
                graph.add((animal_uri, ont.tipoPele, Literal(animal['characteristics']['skin_type'], datatype=XSD.string)))
            else:
                graph.add((animal_uri, ont.predadores, Literal("Unknown", datatype=XSD.string)))
            
            # tratar caracteristicas que serao classes

            # tratar cores
            if 'color' in animal['characteristics']:
                colors = split_colors(animal['characteristics']['color']) # pegar
                for color_name in colors:
                    id_cor = "c" + str(numero_cor)
                    color_uri = URIRef(f"http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34#{id_cor}")
                    if color_name not in existing_colors:
                        numero_cor +=1
                        graph.add((color_uri, RDF.type, ont.Cor))
                        graph.add((color_uri, ont.nomeCor, Literal(color_name, datatype=XSD.string)))
                        graph.add((color_uri, ont.idCor, Literal(id_cor, datatype=XSD.string))) # adicionar id
                        existing_colors.add(color_name)
                    graph.add((animal_uri, ont.coloracao, color_uri))

            # tratar habitats
            if 'habitat' in animal['characteristics']:
                habitat_str = animal['characteristics']['habitat']
                habitats = split_locations_habitats(habitat_str)
                for habitat_name in habitats:
                    id_habitat = "h" + str(numero_habitat)
                    habitat_uri = URIRef(f"http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34#{id_habitat}")
                    if habitat_name not in existing_habitats:
                        numero_habitat +=1
                        graph.add((habitat_uri, RDF.type, ont.Habitat))
                        graph.add((habitat_uri, ont.nomeHabitat, Literal(habitat_name, datatype=XSD.string)))
                        graph.add((habitat_uri, ont.idHabitat, Literal(id_habitat, datatype=XSD.string))) # adicionar id
                        existing_habitats.add(habitat_name)
                    graph.add((animal_uri, ont.habitaEm, habitat_uri))
            
            # pegar nas localizacoes das caracteristicas (location)
            locations_from_characteristics = animal.get('characteristics', {}).get('location', '')
            locations_from_characteristics = split_locations_habitats(locations_from_characteristics)

        # tratar localizacoes 
        locations = animal.get('locations', []) # buscar localizacoes do locations
        combined_locations = locations + locations_from_characteristics # juntar ambas sem repetidos
        combined_locations = set([x.replace(' ', '-') for x in combined_locations])

        for location_name in combined_locations:
            id_localizacao = "l" + str(numero_localizacao)
            location_uri = URIRef(f"http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34#{id_localizacao}")
            if location_name not in existing_locations:
                numero_localizacao += 1
                graph.add((location_uri, RDF.type, ont.Localizacao))
                graph.add((location_uri, ont.nomeLocalizacao, Literal(location_name, datatype=XSD.string)))
                graph.add((location_uri, ont.idLocalizacao, Literal(id_localizacao, datatype=XSD.string))) # adicionar id
                existing_locations.add(location_name)
            graph.add((animal_uri, ont.existeEm, location_uri))


populate_ontology(g,data)

g.serialize(destination='../animals.ttl', format='ttl')