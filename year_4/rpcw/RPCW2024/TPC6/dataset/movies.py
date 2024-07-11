from rdflib import Graph, Namespace, URIRef, Literal
from rdflib.namespace import RDF, OWL, XSD
from json import load
from re import sub

g = Graph()
g.parse("movies.ttl")

movie = Namespace("http://rpcw.di.uminho.pt/2024/cinema")

g.add((URIRef(f"{movie}Twilight"), RDF.type, OWL.NamedIndividual))
g.add((URIRef(f"{movie}Twilight"), RDF.type, movie.Film))
g.add((URIRef(f"{movie}CatherineHardwicke"), RDF.type, OWL.NamedIndividual))
g.add((URIRef(f"{movie}CatherineHardwicke"), RDF.type, movie.Director))
g.add((URIRef(f"{movie}Twilight"), movie.hasDirector, movie.CatherineHardwicke))

f = open('movies.json')
movies = load(f)
f.close()

for m in movies:
    title      = m['title'].replace('.','')
    director   = m['director'].split(',')
    cast       = m['cast'].split(',')
    writer     = m['writer'].split(',')
    soundtrack = m['soundtrack'].split(',')
    genre      = m['genre'].split(',')
    length     = m['length']
    
    # Title
    t = sub(' |\"','',title)
    g.add((URIRef(f"{movie}{t}"), RDF.type, OWL.NamedIndividual))
    g.add((URIRef(f"{movie}{t}"), RDF.type, movie.Film))

    # Director
    for d in director:
        if not d == '':
            input = sub(' |\"','',d)
            g.add((URIRef(f"{movie}{input}"), RDF.type, OWL.NamedIndividual))
            g.add((URIRef(f"{movie}{input}"), RDF.type, movie.Director))
            g.add((URIRef(f"{movie}{t}"), movie.hasDirector, URIRef(f"{movie}{input}")))

    # Cast
    for c in cast:
        if not c == '':
            input = sub(' |\"','',c)
            g.add((URIRef(f"{movie}{input}"), RDF.type, OWL.NamedIndividual))
            g.add((URIRef(f"{movie}{input}"), RDF.type, movie.Actor))
            g.add((URIRef(f"{movie}{t}"), movie.hasActor, URIRef(f"{movie}{input}")))

    # Writer
    for w in writer:
        if not w == '':
            input = sub(' |\"','',w)
            g.add((URIRef(f"{movie}{input}"), RDF.type, OWL.NamedIndividual))
            g.add((URIRef(f"{movie}{input}"), RDF.type, movie.Writer))
            g.add((URIRef(f"{movie}{t}"), movie.hasWriter, URIRef(f"{movie}{input}")))

    # Soundtrack
    for s in soundtrack:
        if not s == '':
            input = sub(' |\"','',s)
            g.add((URIRef(f"{movie}{input}"), RDF.type, OWL.NamedIndividual))
            g.add((URIRef(f"{movie}{input}"), RDF.type, movie.Musician))
            g.add((URIRef(f"{movie}{t}"), movie.hasComposer, URIRef(f"{movie}{input}")))
    
    # Genre
    for ge in genre:
        if not ge == '':
            input = sub(' |\"','',ge)
            g.add((URIRef(f"{movie}{input}"), RDF.type, OWL.NamedIndividual))
            g.add((URIRef(f"{movie}{input}"), RDF.type, movie.Genre))
            g.add((URIRef(f"{movie}{t}"), movie.hasGenre, URIRef(f"{movie}{input}")))

    # Duration
    g.add((URIRef(f"{movie}{t}"), movie.duration, Literal(length, datatype=XSD.double)))


#print(len(g))
print(g.serialize())