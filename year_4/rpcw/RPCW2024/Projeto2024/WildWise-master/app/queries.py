#############################
########## ANIMAIS ##########
#############################

# Todos os animais
def all_animals(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT ?idAnimal ?nome
WHERE {{
  ?a a ont:Animal.
  ?a ont:idAnimal ?idAnimal .
  ?a ont:nomeAnimal ?nome.
}}
'''

# Características base e taxonómicas de um animal de id especificado
def animal_characteristics(id): return f'''PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>
SELECT ?idAnimal ?nome ?comprimento ?altura ?peso ?gestacao ?incubacao ?tempoVida ?dieta ?presas ?predadores ?nrEspecies ?tipoPele ?nomeCientifico ?reino ?familia ?ordem ?phylum ?classe ?genus
WHERE {{
  ?animal ont:idAnimal '{id}'.
    OPTIONAL {{ ?animal ont:idAnimal ?idAnimal. }}
    OPTIONAL {{ ?animal ont:nomeAnimal ?nome. }}
    OPTIONAL {{ ?animal ont:comprimento ?comprimento. }}
    OPTIONAL {{ ?animal ont:altura ?altura. }}
    OPTIONAL {{ ?animal ont:peso ?peso. }}
    OPTIONAL {{ ?animal ont:incubacao ?incubacao. }}
    OPTIONAL {{ ?animal ont:tempoVida ?tempoVida. }}
    OPTIONAL {{ ?animal ont:dieta ?dieta. }}
    OPTIONAL {{ ?animal ont:presas ?presas. }}
    OPTIONAL {{ ?animal ont:predadores ?predadores. }}
    OPTIONAL {{ ?animal ont:nrEspecies ?nrEspecies. }}
    OPTIONAL {{ ?animal ont:tipoPele ?tipoPele. }}
    
    ?animal ont:identificadoPor ?taxonomia.
    OPTIONAL {{ ?taxonomia ont:nomeCientifico ?nomeCientifico. }}
    OPTIONAL {{ ?taxonomia ont:reino ?reino. }}
    OPTIONAL {{ ?taxonomia ont:familia ?familia. }}
    OPTIONAL {{ ?taxonomia ont:ordem ?ordem. }}
    OPTIONAL {{ ?taxonomia ont:classe ?classe. }}
    OPTIONAL {{ ?taxonomia ont:genus ?genus. }}
    OPTIONAL {{ ?taxonomia ont:phylum ?phylum. }}    
}} '''

# Todas localizacoes
def all_locals(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?localizacoes
WHERE {{
  ?l a ont:Localizacao.
  ?l ont:nomeLocalizacao ?localizacoes .
}}
'''

# Animais por localizaçao
def animal_locations(local): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT ?idAnimal ?nome
WHERE {{
  ?a a ont:Animal.
  ?a ont:existeEm/ont:nomeLocalizacao '{local}'.
  ?a ont:idAnimal ?idAnimal .
  ?a ont:nomeAnimal ?nome.
}}
'''

# Todos os habitats
def all_habitat(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?habitats
WHERE {{
  ?h a ont:Habitat.
  ?h ont:nomeHabitat ?habitats .
}}
'''

# Animais que habitam
def animal_habitats(habitat): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT ?idAnimal ?nome
WHERE {{
  ?a a ont:Animal.
  ?a ont:habitaEm/ont:nomeHabitat '{habitat}'.
  ?a ont:idAnimal ?idAnimal .
  ?a ont:nomeAnimal ?nome.
}}
'''

# Todas as cores
def all_colors(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?cores
WHERE {{
  ?c a ont:Cor.
  ?c ont:nomeCor ?cores .
}}
'''

# Animais com certa cor
def animal_colors(color): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT ?idAnimal ?nome
WHERE {{
  ?a a ont:Animal.
  ?a ont:coloracao/ont:nomeCor '{color}'.
  ?a ont:idAnimal ?idAnimal .
  ?a ont:nomeAnimal ?nome.
}}
'''

# Todas as dietas
def all_diets(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?diets
WHERE {{
  ?a a ont:Animal.
  ?a ont:dieta ?diets .
}}
'''

# Animais com certa dieta
def animal_diets(diet): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT ?idAnimal ?nome
WHERE {{
  ?a a ont:Animal.
  ?a ont:dieta '{diet}'.
  ?a ont:idAnimal ?idAnimal .
  ?a ont:nomeAnimal ?nome.
}}
'''

#############################
######### TAXONOMIA #########
#############################

# All kingdoms
def all_kingdoms(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?reinos
WHERE {{
  ?taxonomias a ont:Taxonomy.
  ?taxonomias ont:reino ?reinos.
}}
'''

# All phylums
def all_phylums(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?phylums
WHERE {{
  ?taxonomias a ont:Taxonomy.
  ?taxonomias ont:filo ?phylums.
}}
'''

# All classes
def all_classes(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?classes
WHERE {{
  ?taxonomias a ont:Taxonomy.
  ?taxonomias ont:classe ?classes.
}}
'''

# All orders
def all_orders(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?ordens
WHERE {{
  ?taxonomias a ont:Taxonomy.
  ?taxonomias ont:ordem ?ordens.
}}
'''

# All families
def all_families(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?families
WHERE {{
  ?taxonomias a ont:Taxonomy.
  ?taxonomias ont:familia ?families.
}}
'''

# All genus 
def all_genus(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?genus
WHERE {{
  ?taxonomias a ont:Taxonomy.
  ?taxonomias ont:genero ?genus.
}}
'''


######################################
######### ANIMAIS-TAXONOMIAS #########
######################################

# All animals that belong to a specified kingdom
def animal_by_kingdom(kingdom): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?idAnimal ?nome
WHERE {{
  ?animals ont:identificadoPor/ont:reino '{kingdom}';
  ont:idAnimal ?idAnimal;
  ont:nomeAnimal ?nome.
}}
'''

# All animals that belong to a specified phylum
def animal_by_phylums(phylum): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?idAnimal ?nome
WHERE {{
  ?animals ont:identificadoPor/ont:filo '{phylum}';
  ont:idAnimal ?idAnimal;
  ont:nomeAnimal ?nome.
}}
'''

# All animals that belong to a specified class
def animal_by_classes(classe): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?idAnimal ?nome
WHERE {{
  ?animals ont:identificadoPor/ont:classe '{classe}';
  ont:idAnimal ?idAnimal;
  ont:nomeAnimal ?nome.
}}
'''

# All animals that belong to a specified order
def animal_by_orders(order): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?idAnimal ?nome
WHERE {{
  ?animals ont:identificadoPor/ont:ordem '{order}';
  ont:idAnimal ?idAnimal;
  ont:nomeAnimal ?nome.
}}
'''

# All animals that belong to a specified family
def animal_by_families(family): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?idAnimal ?nome
WHERE {{
  ?animals ont:identificadoPor/ont:familia '{family}';
  ont:idAnimal ?idAnimal;
  ont:nomeAnimal ?nome.
}}
'''

# All animals that belong to a specified genus
def animal_by_genus(genus): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?idAnimal ?nome
WHERE {{
  ?animals ont:identificadoPor/ont:genero '{genus}';
  ont:idAnimal ?idAnimal;
  ont:nomeAnimal ?nome.
}}
'''

def animal_count(): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT (COUNT (?a) as ?animals)
WHERE {{
  ?a a ont:Animal.
}}
'''

def taxo_match(forms): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

SELECT DISTINCT ?t
WHERE {{
  ?t a ont:Taxonomy;
  ont:reino '{forms['kingdom']}';
  ont:nomeCientifico '{forms['sciname']}';
  ont:familia '{forms['family']}';
  ont:filo '{forms['phylum']}';
  ont:classe '{forms['classe']}';
  ont:genero '{forms['genus']}'.
}}
'''

def animal_insert(id,name, taxo): return f'''
PREFIX ont:<http://rpcw.di.uminho.pt/2024/4/untitled-ontology-34/>

INSERT DATA{{
  ont:{id} a ont:Animal ;
  ont:IdAnimal "{id}" ;
  ont:nomeAnimal "{name}" ;
  ont:identificadoPor ont:{taxo} .
}}
'''