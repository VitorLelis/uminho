import pandas as pd

data = pd.read_json('movies.json')

# Short-films
q1 = data.query('length < 3600')

# Action movies
q2 = data.query("'Action' in genre")

# Cast of a movie
q3 = data.query("title == 'Caged Heat'")['cast']

# Movies with an Actor
q4 = data.query("'Tom Cruise' in cast")['title']
