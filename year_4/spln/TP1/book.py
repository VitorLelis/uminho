from LeIA.leia import SentimentIntensityAnalyzer
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer as vaderSent
from tool import polarity
from re import compile
from statistics import mean
import pandas as pd
import matplotlib.pyplot as plt

###### Menu ######
def menu_choices() -> list:
    regex = compile('\d+')

    prompt = """Escolhe o que queres ver:
1-> Polaridade da Ferramenta
2-> Polaridade da Ferramenta Calibrada
3-> Polaridade da LeIA
4-> Polaridade Vader (Livro em Inglês)
5-> Todas
0-> Sair\n
"""
    options = ['Polaridade','Polaridade Calibrada', 'Polaridade (LeIA)', 'Polaridade (Vader)']
    
    inp = input(prompt)

    opt = regex.findall(inp)

    if '0' in opt:
        return []
    elif '5' in opt:
        return options
    else:
        new_options = list()

        for o in opt:
            id = int(o)

            if id > 0 and id < 5:
                new_options.append(options[id-1])
            else:
                print("Opção Inexisteste")

        return new_options

###### LeIA and Tool ######

f = open('data/HP.txt', 'r')

s = SentimentIntensityAnalyzer()

chapters_leia = list()
chapters_tool = dict()

chapter = 'Prefacio'

pol_lines_tool = []
pol_lines_leia = []

for line in f:
    if line.startswith('#'):
        chapters_leia.append(mean(pol_lines_leia))
        chapters_tool[chapter] = mean(pol_lines_tool)

        pol_lines_tool = []
        pol_lines_leia = []

        chapter = line.strip().split()[-1]
    
    pol_lines_tool.append(s.polarity_scores(line)['compound'])
    pol_lines_leia.append(polarity(line))
    
f.close()   

chapters_leia.append(mean(pol_lines_leia))
chapters_tool[chapter] = mean(pol_lines_tool)

###### Vader ######

g = open("data/J. K. Rowling - Harry Potter 1 - Sorcerer's Stone.txt", 'r')

vs = vaderSent()

chapters_vader = list()

chapter = 'Prefacio'

pol_lines_vader = []

for line in g:
    if line.startswith('CHAPTER'):
        chapters_vader.append(mean(pol_lines_vader)) 
        pol_lines_vader = []
        chapter = line.strip().split()[-1]

    pol_lines_vader.append(vs.polarity_scores(line)['compound'])


g.close()

chapters_vader.append(mean(pol_lines_vader))

###### Histograms ######

calibrate_cons = mean(chapters_tool.values()) * -1

calibrated = list(map(lambda c: c + calibrate_cons, chapters_tool.values()))

df = pd.DataFrame(data={'Capítulos': chapters_tool.keys(), 
                        'Polaridade': chapters_tool.values(),
                        'Polaridade Calibrada': calibrated,
                        'Polaridade (LeIA)': chapters_leia,
                        'Polaridade (Vader)': chapters_vader})

control = True
while(control):
    my_choice = menu_choices()
    if my_choice != []:
        ax = df.plot(x="Capítulos", 
                     y=my_choice, 
                     kind="bar", 
                     rot=0)

        ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.10),
                  fancybox=True, ncol=4)
        plt.show()
    else:
        control = False
    print('-------------------------------')
