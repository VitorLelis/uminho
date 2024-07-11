from time import time
from search import search_query
from bd_connection import connect

# Flag de controle do ciclo
control = True

# Dicionario base com os campos de informação
base = {"document_id" : False, 
            "type" : False, 
            "reference" : False,
            "issuer" : False,
            "source" : False,
            "details" : False,
            "published" : False,
            "reserved" : False,        
            "publication_date " : False,
            "content" : False,       
            "pdf_url" : False,         
            "htm_url" : False,         
            "is_deleted" : False,     
            "created_at" : False,      
            "is_canceled" : False,    
            "doc_number"  : False,     
            "doc_version" : False,    
            "priority" : False,
            "reference_t" : False,
            "created_at_t" : False,
            "url_t" : False,
            "document_text_t" : True }

# Dicionario com as opções relacionadas as suas colunas
options_dic = {
"did" : "document_id" ,
"typ" : "type" ,
"ref" : "reference",
"iss" : "issuer" ,
"sou" : "source" ,
"det" : "details" ,
"pub" : "published", 
"res" : "reserved",       
"pub" : "publication_date ",
"con" : "content",        
"pdf" : "pdf_url",          
"htm" : "htm_url",         
"isd" : "is_deleted",      
"cre" : "created_at",      
"isc" : "is_canceled",   
"dnu" : "doc_number",   
"dve" :"doc_version",     
"pri" : "priority", 
"rft" : "reference_t", 
"cra" :"created_at_t", 
"url" : "url_t", 
}

# Função auxiliar para processar a escolha de opções
def options():
    result = base
    print("\nQuais opções deseja? (Separe por espaços)")
    for k,v in options_dic.items():
        print(f"{k} -> {v}")
    opt = input(">>")
    for o in opt.split():
        result[options_dic[o]] = True
    return result

# Função auxiliar para processar o resultado da procura
def menu(query):
    result = dict()
    number = int(input("Quantos documentos deseja?\n>>"))
    inicio = time()
    docs = (search_query(query,number))
    fim = time()
    print(f"Tempo de procura: {fim - inicio:.3f}s")
    opt = options()
    for d in docs:
        opt['notes'] = d["notes"]
        result[d['id']] = opt
    return result

while(control):
    query = input("O que deseja procurar? (Escreva '?quit' para sair)\n>>")
    if query == '?quit':
        control = False
    else:
        config = menu(query)
        connect(config)
        
    print('-'*30)