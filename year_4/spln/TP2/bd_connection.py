from mysql.connector import Error
import mysql.connector
from dotenv import load_dotenv
import os
from bs4 import BeautifulSoup

def connect(dict):
    """ Connect to MariaDB database and perform a query """
    with open("answer.txt", 'w') as file:
        pass 
    try:
        # conectar ao servidor
        load_dotenv()
        connection = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            database=os.getenv('DB_DATABASE'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD')
        )
        
        # se estiver conectado
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SELECT DATABASE();") # usa a BD selecionada previamente 
            record = cursor.fetchone()
            print("You're connected to database: ", record)

            ans = 0 # inicializar contador de respostas

            # para cada valor (documento) do dicionario
            for key, value in dict.items():

                # recolhe as flags todas de um documento
                flags = []
                notes = value['notes']

                for flag, bool in value.items():
                    if flag != "notes" and bool: 
                        flags.append(flag)                
                id = key # guarda o id do documento
                
                document_flags = [flag for flag in flags if not flag.endswith("_t")] # recolhe as flags para a primeira tabela
                print("You asked for the following document flags: ", document_flags) # debug controlo para saber se as flags foram recebidas corretamente
                
                # uso o [:-2] para retirar o _t, para enviar o nome do campo certo senão a BD não encontra
                text_flags = [flag[:-2] for flag in flags if flag.endswith("_t")] # recolhe as flags para a segunda tabela
                print("You asked for the following text flags: ", text_flags) # debug controlo para saber se as flags foram recebidas corretamente

                # construcao da query à tabela public.dreapp_document
                if document_flags:
                    query_document = "SELECT "
                    query_document += ', '.join(str(num) for num in document_flags)
                    query_document += f" FROM public.dreapp_document WHERE id = {id}"

                # construcao da query à tabela public.dreapp_documenttext
                if text_flags:
                    query_text = "SELECT "
                    query_text += ', '.join(str(num) for num in text_flags)
                    query_text += f" FROM public.dreapp_documenttext WHERE reference = {id}"
                
                # executar ambas e guardar os resultados
                cursor.execute(query_document)
                result_document = cursor.fetchone()
                print(result_document)
                cursor.execute(query_text)
                result_text = cursor.fetchone()
                print(result_text)

                if not result_text:
                    continue

                ans += 1 # já testamos que existe e vamos registar a resposta, logo, aumentar contador para criar um novo texto
                answer = f"""DOCUMENT ID = {id} 
---------------------

DOCUMENT DATA
---------------------
"""             
                # construir a parte da resposta da query à public.dreapp_document
                if document_flags:
                    if result_document:
                        for i in range(len(result_document)):
                            answer += f"{document_flags[i]} : {result_document[i]}\n"
                    else:
                        answer += (f"\nEntry with id {id} not found.\n")

                answer += "---------------------\n\nTEXT DATA\n---------------------\n"

                # construir a parte da resposta da query à public.dreapp_documenttext
                if text_flags:
                    if result_text:
                        for i in range(len(result_text)):
                            if text_flags[i] == "document_text":
                                if result_text[i]:
                                    print(result_text)
                                    soup = BeautifulSoup(result_text[i], 'html.parser')
                                    text = soup.get_text()
                                    answer += f"{text_flags[i]} :\n{text}\n"
                                else:
                                    answer += f"document_text : \n{notes}\n"
                            else:
                                answer += f"{text_flags[i]} : {result_text[i]}\n"
                                       
                answer += "\n\n=============================\n\n"

                # escrever resposta no ficheiro destinado à resposta
                with open(f"answers/answer{ans}.txt", 'w') as file:
                    file.write(answer)

    # se a conexao à BD falahar
    except Error as e:
        print("Error while connecting to MariaDB", e)
    
    # fechar a conexao
    finally:
        if connection.is_connected(): 
            cursor.close()
            connection.close()
            print("MariaDB connection is closed")

if __name__ == "__main__":
    # dicionario de ids e flags para passar às queries
    # apagar quando isto for só um módulo para ser usado pelo programa principal
    dict = {
        1 : {
            "notes" : "ola",
            "document_id" : True, 
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
            "reference_t" : True,
            "created_at_t" : True,
            "url_t" : True,
            "document_text_t" : True
        },
        13131313 : {
            "notes" : "ola2",
            "document_id" : True, 
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
            "reference_t" : True,
            "created_at_t" : True,
            "url_t" : True,
            "document_text_t" : True
        },
        2 : {
            "notes" : "ola3",
            "document_id" : True, 
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
            "reference_t" : True,
            "created_at_t" : True,
            "url_t" : True,
            "document_text_t" : True
        },
        3 : {
            "notes" : "ola4",
            "document_id" : True, 
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
            "reference_t" : True,
            "created_at_t" : True,
            "url_t" : True,
            "document_text_t" : True
        },
    }                     

    connect(dict)


 



