from statistics import mean
from re import compile

INTENSE = ["muito", "muita", "bastante", "extremamente", "excessivamente", 
            "imensamente", "tão", "infinita","infinitamente", 
            "intenso", "intensa", "intensamente", "eterno",
            "eterna", "eternamente", "incrivelmente", "profundamente"]

NEGATION = ["não", "nunca", "jamais", "nenhum", "nada", "sem"]

f = open('data/sentilex-reduzido.txt','r')

sentilex = dict()

for line in f:
    word, value = line.strip().split(',')
    sentilex[word] = float(value)

f.close()

regex = compile(r'\b\w+\b')

def has_polarity(text: str) -> list:
    words = regex.findall(text)
    return list(filter(lambda w: w in sentilex.keys(), words))

def intense(text:str) -> list: 
    return list(filter(lambda i: i in text, INTENSE))

def negate(text: str) -> list:
    return list(filter(lambda n: n in text, NEGATION))

def polarity(text: str) -> float:
    words = regex.findall(text)

    is_negat = False
    is_ints = False

    sentence_pol = list()

    last_word = None

    neg_altered = False

    for w in words:
        lw = w.lower()
        if lw in NEGATION: 
            is_negat = True
        elif lw in INTENSE: 
            is_ints = True
        else:
            pol = sentilex.get(lw,0.0)

            if pol != 0: 
                if is_negat:
                    pol *= -1
                    neg_altered = True
                if is_ints:
                    pol *= 1.5
                    
                sentence_pol.append(pol)
            
            else:
                if sentence_pol != [] and sentence_pol[-1] == last_word:
                    if is_negat and not neg_altered:
                        sentence_pol[-1] *= -1
                    if is_ints:
                        sentence_pol[-1] *= 1.5
                    
                    neg_altered = False

            is_negat = False
            is_ints = False

        last_word = lw
    
    result = mean(sentence_pol) if sentence_pol else 0.0

    return result