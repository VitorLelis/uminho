from flask import Flask, render_template, url_for
from datetime import datetime
import requests

app = Flask(__name__)

# Data do sistema no formato ISO
data_hora_atual = datetime.now()
data_formatada = data_hora_atual.strftime('%Y-%m-%dT%H: %M: %S')

# GraphDB endpoint
graphdb_endpoint = "http://localhost:7200/repositories/tabela-periodica"

#Index
@app.route('/')
def index():
    return render_template('index.html', data = {"data": data_formatada})

#Elementos
def element_group(elem : dict) -> dict:
    elem['grupo']['value'] = elem['grupo']['value'].split('#')[1] 
    
    return elem

@app.route('/elementos')
def elementos():
    sparql_query="""
prefix tp: <http://www.daml.org/2003/01/periodictable/PeriodicTable#>
select * where{
    ?s a tp:Element ;
       tp:name ?nome;
       tp:symbol ?simb;
       tp:atomicNumber ?n;
       tp:group ?grupo.
    ?grupo tp:name ?grupo_nome.
}
order by ?n
"""
    resposta = requests.get(graphdb_endpoint,
                            params={"query": sparql_query}, 
                            headers={'Accept': 'application/sparql-results+json'})
    
    if resposta.status_code == 200:
        dados = resposta.json()['results']['bindings']
        print(dados)
        dados_novos = map(element_group,dados)
        print(dados_novos)
        return render_template('elementos.html', data = dados_novos)
    else:
        return render_template('empty.html', data = {"data": data_formatada})

#Grupos
    
def group_clean(grupo: dict) -> dict:
    grupo['group']['value'] = grupo['group']['value'].split('#')[1] 
    grupo['nome'] = grupo.get('nome',{'type': 'literal', 'value': 'None'})
    grupo['numero'] = grupo.get('numero',{'type': 'literal', 'value': 'None'})

    return grupo

@app.route('/grupos')
def grupos():
    sparql_query="""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.daml.org/2003/01/periodictable/PeriodicTable#>

select ?group ?numero ?nome where{
    ?group rdf:type :Group .
    optional {?group :number ?numero .}
    optional {?group :name ?nome .}
}

order by ?numero
"""
    resposta = requests.get(graphdb_endpoint,
                            params={"query": sparql_query}, 
                            headers={'Accept': 'application/sparql-results+json'})
    
    if resposta.status_code == 200:
        dados = resposta.json()['results']['bindings']
        dados_novos = map(group_clean,dados)
        return render_template('grupos.html', data = dados_novos)
    else:
        return render_template('empty.html', data = {"data":data_formatada})

#Grupo Individual
def elements_clean(element: dict)-> dict:
    element['bloco']['value'] = (element['bloco']['value'].split("#")[-1]).split("-")[0]
    element['periodo']['value'] = element['periodo']['value'].split("_")[-1]
    element['class']['value'] = element['class']['value'].split("#")[-1]
    element['estado']['value'] = element['estado']['value'].split("#")[-1]
    
    return element    

@app.route('/grupos/<string:id>')
def grupo(id):
    sparql_query = f"""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.daml.org/2003/01/periodictable/PeriodicTable#>

SELECT ?elemento ?nome ?na ?peso ?periodo ?class ?bloco ?cor ?estado
    WHERE {{
        ?grupo_id rdf:type :Group .
        ?e :group ?grupo_id ;
           		:symbol ?elemento ;
                :name ?nome ;
                :atomicNumber ?na ;
                :atomicWeight ?peso ;
                :period ?periodo ;
                :classification ?class ;
                :block ?bloco ;
                :color ?cor ;
                :standardState ?estado .

        FILTER (?grupo_id = :{id})
    }}
    ORDER BY ?elemento
"""
    resposta = requests.get(graphdb_endpoint,
                            params={"query": sparql_query}, 
                            headers={'Accept': 'application/sparql-results+json'})
    
    if resposta.status_code == 200:
        dados = resposta.json()['results']['bindings']
        dados_novos = map(elements_clean,dados)
        return render_template('grupo.html', data = {"grupo": dados_novos,"id":id})
    else:
        return render_template('empty.html', data = {"data": data_formatada})
    
#Elemento individual
@app.route('/elementos/<string:id>')
def elemento(id):
    sparql_query=f"""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX : <http://www.daml.org/2003/01/periodictable/PeriodicTable#>

SELECT ?elemento ?nome ?na ?peso ?periodo ?class ?bloco ?cor ?estado
    WHERE {{
        ?e rdf:type :Element ;
           		:symbol ?elemento ;
                :name ?nome ;
                :atomicNumber ?na ;
                :atomicWeight ?peso ;
                :period ?periodo ;
                :classification ?class ;
                :block ?bloco ;
                :color ?cor ;
                :standardState ?estado .

        FILTER (?na = {id})
    }}
"""
    resposta = requests.get(graphdb_endpoint,
                            params={"query": sparql_query}, 
                            headers={'Accept': 'application/sparql-results+json'})

    if resposta.status_code == 200:
        dados = resposta.json()['results']['bindings']
        dados_novos = map(elements_clean,dados)
        print(dados_novos)
        return render_template('elemento.html', data = {"elemento": dados_novos,"id":id})
    else:
        return render_template('empty.html', data = {"data": data_formatada})

if __name__ =='__main__':
    app.run(debug=True)