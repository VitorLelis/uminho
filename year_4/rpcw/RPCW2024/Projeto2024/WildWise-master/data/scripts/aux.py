import re

# auxiliar para tratar de separar os habitats e localizacoes
def split_locations_habitats(habitat_str):
    parts = re.split(r'(,\sand\s|,\s|\sand\s)', habitat_str)
    parts = parts[::2]
    return(parts)
    
# auxiliar para tratar de separar e guardar as cores
def split_colors(color_str):
    return re.findall(r'[A-Z][a-z]*', color_str)