# Trabalho Prático 1 (TP1)

Para o desenvolvimento do TP1, criamos uma ferramenta de análise sentimental de textos e a utilizamos para comparar com outras ferramentas já existentes, nomeadamente a LeIA e o Vader.

A ferramenta utiliza o conjunto de palavras descritas no `sentilex-reduzido.txt` que classifica a polaridade das palavras com:

+ 1 para palavras positivas;
+ 0 para palavras neutras;
+ -1 para palavras negativas.

Além disso, a ferramenta é capaz de registrar palavras com intenção de negação e com intensidade.

## Cáclulo da polaridade

O cálculo da polaridade é feito com a identificação das palavras presentes no input e dado a sua polaridade calcula-se a média aritimética.

## Diretórios e ficheiros

+ `data` -> Diretório com os textos de input e o `sentilex-reduzido.txt`
+ `LeIA` -> Repositório com o código fonte do LeIA
+ `tool.py` -> Script com a nossa ferramenta
+ `corpus.py` -> Sript para calcular a polaridade de um texto aleatório com a nossa ferramenta
+ `sentence_test.py` -> Sript para calcular a polaridade de 10 frases com a nossa ferramenta
+ `book.py` -> Script com a análise da polaridade dos livros de Harry Potter utilizando todas as ferramentas mencionadas 
+ `plot.png` -> Imagem com uma representação gráfica da polaridade das ferramentas de análise