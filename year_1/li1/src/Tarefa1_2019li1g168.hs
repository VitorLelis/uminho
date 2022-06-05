{- | 

=Relatório

A tarefa 1 teve como objetivo implementar o modo de geração de mapas, começando com uma função já nos providenciada:
/geraAleatorios/, que gera uma lista de números inteiros aleatórios.
     
Uma vez que a função principal desta tarefa é _/gera/_, todas as funções criadas nesta tarefa para além dessa podem
ser consideradas suas auxiliares.
     
Começámos por criar uma função que gera uma lista de pares de números aleatórios (/agruparPares/), fornecidos pela 
função disponibilizada pelos professores desta UC. Lista essa que é dividida em várias listas de pares pela função
/geraComp/, com o intuito de agrupar comprimentos de pista.
     
A nossa estratégia consistia em gerar o mapa por partes, começando por gera o piso, de pois gerar a pista e, posteriormente,
gerar o mapa. Dessa forma, uma outra função indispensável para esta tarefa é /geraPiso/, que dependendo do valor da primeira 
componente do par pode gerar quatro tipos diferentes de piso de uma peça: do tipo /Terra/, /Lama/, /Relva/ ou /Boost/.
     
De seguida, foi criada a função /geraPeça/, responsável por gerar peças, sejam elas rampas ou retas, com a sua altura 
dependente do valor da segunda componente de um par. Par esse derivado da lista gerada pela função /geraComp/.
     
A última função auxiliar necessária para a construção de /gera/ é a função /geraPista/, encarregue de gerar uma pista nova
ao receber uma lista e transformando-a peça a peça.
     
Assim, conseguimos conceber /gera/. Esta, através da função pré-definida /map/, percorre toda a lista aplicando a cada seu 
elemento a função /f/, quando o comprimento é diferente de um. Quando o comprimento da lista é igual a um, replicamos n vezes
a lista de /Reta Terra 0/, sendo n igual ao númerod e pistas.
     
Concluímos a tarefa 1 e acreditamos ter estado à altura do desafio dos docentes.

-}

module Tarefa1_2019li1g168 where

import LI11920
import System.Random
import Tarefa0_2019li1g168

-- * Testes

-- | Testes unitários da Tarefa 1.
--
-- Cada teste é um triplo (/número de 'Pista's/,/comprimento de cada 'Pista' do 'Mapa'/,/semente de aleatoriedades/).
-- 1 pistas
-- 2 comprimento
-- 3 numero aleatorios
testesT1 :: [(Int,Int,Int)]
testesT1 = [(1,5,35),(2,5,100),(4,3,36),(2,4,1),(100,2,5),(3,12,4),(2,3,1),(3,4,5),(3,10,3),(4,20,1),(5,17,2),(6,26,7),(1,1,5)]

-- * Funções pré-definidas da Tarefa 1.
-- | Função que gera uma lista de números inteiros aleatórios, dados um número e uma /seed/.

geraAleatorios :: Int -> Int -> [Int]
geraAleatorios n seed = take n (randomRs (0,9) (mkStdGen seed))

-- * Funções principais da Tarefa 1.
-- | Função que gera uma lista de pares, dada uma lista de aleatórios fornecida pela função /geraAleatorios/.
agruparPares :: [a] -> [(a,a)]
agruparPares [] = []
agruparPares (x:y:z) = (x,y) : agruparPares z

{- | Função que gera uma lista de lista de pares, dada uma lista de pares fornecida pela função /agruparPares/.

Utilizada para dividir a lista de pares em listas diferentes, ou seja, para agrupar comprimentos de pista.-}
agruparComp :: [(a,a)] -> Int -> [[(a,a)]]
agruparComp [] _ = []
agruparComp l c = (take c l) : agruparComp (drop c l) c

{- | Função que gera o tipo de uma peça ao receber uma lista de pares e o tipo de piso da peça anterior.

Dependendo do valor da primeira componente de cada par, esta função pode gerar quatro tipos diferentes de pisos:

  1.Terra;

  2.Relva;
  
  3.Lama;
  
  4.Boost.-}
geraPiso :: [(Int, Int)] -> Piso -> Piso
geraPiso ((a,i):t) pisoAnt | a>=0 && a<=1 = Terra
                           | a>=2 && a<=3 = Relva
                           | a==4 = Lama
                           | a==5 = Boost
                           | a>=6 && a<=9 = pisoAnt

{- | Função que gera uma peça ao receber uma lista de pares aleatórios e a peça anterior.

O(s) valor(es) da(s) altura(s) de cada peça dependem da gama, ou seja, da segunda componente de cada par.

Há dois casos possíveis para esta função:

  1.Quando a peça é uma rampa;

  2.Quando a peça é uma reta.-}
geraPeca :: [(Int,Int)] -> Peca -> Peca
geraPeca l@((a,i):t) (Rampa p h1 h2) | i>=0 && i<=1 = Rampa (geraPiso l p) h2 (h2+i+1) 
                                     | i>=2 && i<=5 && (h2-(i-1)) <= 0 && h2 ==0  = Recta (geraPiso l p) 0
                                     | i>=2 && i<=5 = Rampa (geraPiso l p) h2 (max (h2-(i-1)) 0)
                                     | i>=6 && i<=9 = Recta (geraPiso l p) h2

geraPeca l@((a,i):t) (Recta p h)     | i>=0 && i<=1 = Rampa (geraPiso l p) h (h+i+1) 
                                     | i>=2 && i<=5 && (h-(i-1)) <= 0 && h == 0 = Recta (geraPiso l p) 0 
                                     | i>=2 && i<=5 = Rampa (geraPiso l p) h (max (h-(i-1)) 0)
                                     | i>=6 && i<=9 = Recta (geraPiso l p) h

{- | Função que, ao receber uma lista de pares e uma pista, gera a própria lista.

Gera uma pista nova transformando a pista recebida, peça por peça.-}
geraPista :: [(Int,Int)] -> Pista -> Pista
geraPista [] l = l
geraPista (h:t) [] = geraPista t ((Recta Terra 0):[geraPeca [h] (Recta Terra 0)])
geraPista (h:t) lp = geraPista t (lp ++ [geraPeca [h] (last lp)])

{- | Função que gera o mapa, dados o número de pistas, o comprimento de cada pista e uma semente.

A função pré-definida /mapa/ percorre toda a lista, aplicando a cada elemento a função f.

A lista percorrida resulta de dividir em listas a lista de pares gerada através de valores aleatórios.

A função f corresponde à função /geraPista/ dadas uma lista e uma lista vazia.-}
gera :: Int -> Int -> Int -> Mapa
gera npistas 1 semente = replicate npistas ([Recta Terra 0])
gera npistas comprimento semente =
   map f (agruparComp (agruparPares (geraAleatorios (npistas*(comprimento-1)*2) semente)) (comprimento-1))
     where
       f x = geraPista x []
