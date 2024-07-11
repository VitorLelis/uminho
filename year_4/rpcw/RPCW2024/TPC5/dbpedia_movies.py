import requests
from json import dump

# Define the DBpedia SPARQL endpoint
sparql_endpoint = "http://dbpedia.org/sparql"

# Define the headers
headers = {
    "Accept": "application/sparql-results+json"
}

# Define the SPARQL query
sparql_query ="""
prefix : <http://dbpedia.org/ontology/> 
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>

select distinct ?movie 
(group_concat(distinct ?director; separator=", ") AS ?director)
(group_concat(distinct ?cast; separator=", ") AS ?cast)
(group_concat(distinct ?writer; separator=", ") AS ?writer)
(group_concat(distinct ?soundtrack; separator=", ") AS ?soundtrack)
(group_concat(distinct ?genre; separator=", ") AS ?genre)
?length 
{
            ?movie rdf:type :Film .

             optional{?movie dbo:director ?d .
                                ?d rdfs:label ?director . 
                                filter(lang(?director)='en') .}

             optional{?movie dbo:starring ?c.
                               ?c rdfs:label ?cast .
                                filter(lang(?cast)='en') . }

             optional{?movie :writer ?w .  
                                 ?w rdfs:label ?writer .
                                  filter(lang(?writer)='en') .}

             optional{?movie dbp:music ?m .
                                 ?m rdfs:label ?soundtrack .
                                 filter(lang(?soundtrack)='en') .}
    
            optional {?movie dbp:genre ?g.
                              ?g rdfs:label ?genre .
                              filter(lang(?genre) = 'en')}

            optional {?movie :runtime ?length .}

        }
    """
    
# Define the parameters
params = {
    "query": sparql_query,
    "format": "json"
}

# Send the SPARQL query using requests
response = requests.get(sparql_endpoint, params=params, headers=headers)

# Check if the request was successful
if response.status_code == 200:
    results = response.json()
    all_movies = list()

    for result in results["results"]["bindings"]:
        
        movie = dict()
        
        movie['title']      = result['movie']['value'].split('/')[-1].replace("_"," ")
        movie['director']   = result.get('director',{}).get('value','')
        movie['cast']       = result.get('cast',{}).get('value','')
        movie['writer']     = result.get('writer',{}).get('value','')
        movie['soundtrack'] = result.get('soundtrack',{}).get('value','')
        movie['genre']      = result.get('genre',{}).get('value','')
        movie['length']     = abs(float(result.get('length',{}).get('value',0)))

        all_movies.append(movie)

else:
    print("Error:", response.status_code)
    print(response.text)

f = open('movies.json', 'w')
dump(all_movies,f,indent=4)
f.close()
