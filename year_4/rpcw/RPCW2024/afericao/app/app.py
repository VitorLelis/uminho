from flask import Flask, jsonify
from datetime import datetime
import requests

app = Flask(__name__)

# Data do sistema no formato ISO
data_hora_atual = datetime.now()
data_formatada = data_hora_atual.strftime('%Y-%m-%dT%H: %M: %S')

# GraphDB endpoint
graphdb_endpoint = "http://localhost:7200/repositories/alunos"

def tratar_alunos(aluno : dict) -> dict:
    aluno['curso'] = aluno['curso']['value']
    aluno['idAluno'] = aluno['idAluno']['value']
    aluno['nome'] = aluno['nome']['value']

    return aluno

@app.route('/api/alunos', methods = ['GET'])
def alunos():
    sparql_query = """
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select ?idAluno ?nome ?curso where{
    ?s rdf:type :Aluno ;
       :idAluno ?idAluno;
       :nome ?nome;
       :curso ?curso .
} order by(?nome)
"""

    resposta = requests.get(graphdb_endpoint,
                            params={"query": sparql_query}, 
                            headers={'Accept': 'application/sparql-results+json'})
    
    if resposta.status_code == 200:
        dados = resposta.json()['results']['bindings']
        dados_novos = list(map(tratar_alunos,dados))
        return jsonify(dados_novos)
    

@app.route('/api/alunos/:<id>', methods = ['GET'])
def aluno(id):
    sparql_query = f"""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select ?nome ?curso ?projeto where{{
    ?s rdf:type :Aluno ;
       :idAluno "{id}" ;
       :nome ?nome;
       :curso ?curso;
       :projeto ?projeto.
}}
"""

    resposta = requests.get(graphdb_endpoint,
                            params={"query": sparql_query}, 
                            headers={'Accept': 'application/sparql-results+json'})
    
    if resposta.status_code == 200:
        dados = resposta.json()['results']['bindings']
        aluno = dados[0] 

        aluno['curso'] = aluno['curso']['value']
        aluno['projeto'] = aluno['projeto']['value']
        aluno['nome'] = aluno['nome']['value']

        return jsonify(aluno)    

def tratar_tpcs(aluno : dict) -> dict:
    aluno['curso'] = aluno['curso']['value']
    aluno['idAluno'] = aluno['idAluno']['value']
    aluno['nome'] = aluno['nome']['value']
    aluno['tpc'] = aluno['tpc']['value']

    return aluno

@app.route('/api/alunos/tpc', methods = ['GET'])
def tpc():
    sparql_query = """
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.semanticweb.org/lelis_vitor/ontologies/2024/a/>
   
select ?idAluno ?nome ?curso (count (?t) as ?tpc) where{
    ?s rdf:type :Aluno ;
       :idAluno ?idAluno;
       :nome ?nome;
       :curso ?curso;
       :entrega ?t .
} group by ?idAluno ?nome ?curso 
order by(?nome)
"""

    resposta = requests.get(graphdb_endpoint,
                            params={"query": sparql_query}, 
                            headers={'Accept': 'application/sparql-results+json'})
    
    if resposta.status_code == 200:
        dados = resposta.json()['results']['bindings']
        dados_novos = list(map(tratar_tpcs,dados))
        return jsonify(dados_novos)

if __name__ =='__main__':
    app.run(debug=True)