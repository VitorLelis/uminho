from flask import Flask, render_template, url_for
from datetime import datetime
import requests

app = Flask(__name__)

# Data do sistema no formato ISO
data_hora_atual = datetime.now()
data_formatada = data_hora_atual.strftime('%Y-%m-%dT%H: %M: %S')

# GraphDB endpoint
graphdb_endpoint = "http://epl.di.uminho.pt:7200/repositories/cinema2024"

# Index
@app.route('/')
def index():
    sparql_query = """
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix : <http://rpcw.di.uminho.pt/2024/cinema/>

select * where {
	?movie rdf:type :Film .
}
"""
    resposta = requests.get(graphdb_endpoint,
                            params={"query": sparql_query}, 
                            headers={'Accept': 'application/sparql-results+json'})
    
    if resposta.status_code == 200:
        dados = resposta.json()['results']['bindings']
        movies = list()
        for d in dados:
            movies.append(d['movie']['value'].split('/')[-1].replace('_',' '))
        return render_template('index.html', data = {"data": movies})
    else:
        return render_template('empty.html', data = {"data": data_formatada})

if __name__ =='__main__':
    app.run(debug=True)