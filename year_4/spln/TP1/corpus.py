from tool import polarity, negate, intense, has_polarity
from re import compile
from statistics import mean
from collections import Counter

negs = list()
boost = list()
polar = list()
total_pol = list()

f = open('data/HP.txt','r')

regex = compile(r'[,\s!-:,.]+')

for line in f:

    negs += negate(line)
    boost += intense(line)
    polar += has_polarity(line)

    total_pol.append(polarity(line))

f.close()

cont = Counter(polar)

checked = set(negs + boost + polar)

output = f"""Total de palavras: {len(checked)};\n
Polaridade final: {mean(total_pol)};\n
Palavras que mais contribuiram para o cálculo:\n\n"""

for x,y in cont.most_common(30):
    output += f"{x} -> {y}\n"

print(output)