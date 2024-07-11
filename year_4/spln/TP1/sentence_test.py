from tool import polarity

f = open('data/frases-exemplo.txt','r')

for line in f:
    sentence = line.strip()
    score = polarity(sentence)
    print(f"Frase: {sentence}; Polaridade: {score}")

f.close()