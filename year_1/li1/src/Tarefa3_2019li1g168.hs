{- |

=Relatório

A tarefa 3 teve como objetivo desconstruir um mapa de modo a covertê-lo numa sequência de instruções. Esta será
recebida por um grupo de bulldozers que irá construir o mapa em questão, mais à frente.
     
De forma a desconstruir o mapa de uma forma mais compacta, é possível identificar três tipos principais de padrões: 
__padrões verticais__, __padrões verticais desfasados__ e __padrões horizontais__. No entanto, só conseguimos possibilitar
a identificação de padrões horizontais, através da função /repete/.
     
A primeira função criada foi __/constroiInstrucao/__ com o objetivo de construir uma instrução, quer a peça em questão
seja uma rampa ou uma reta. Assim, torna-se possível utilizar essa função para criar a __/constroiInstrucoes/__, que constrói
uma lista de instruções. No fundo, /constroiInstrucao/ é função auxiliar da anteriormente referida.
     
De seguida, foram criadas a função __/repete/__ e as suas auxiliares. Começamos por construir a função __/quantasRepete'/__,
que funciona como contador do número de vezes que uma instrução se repete.
     
Posteriormente, criamos a função __/quantasRepete/__, garantindo que /quantasRepete'/ começa a contar do zero. Deste modo,
concluimos as funções auxiliares da /repete/. Esta função percorre uma dada lista de instruções e encontra padrões horizontais,
ou seja, instruções repetidas, para uma desconstrução mais compacta do mapa.
     
Posto isto, faltava apenas uma função que permitisse criar uma lista de pares cuja primeira componente fosse o índice da
pista e a segunda a lista de instruções. Daí termos criado a função __/desconstroiAux/__.
     
Depois de geradas as funções auxiliares à função principal desta tarefa, _/desconstroi/_, bastava construí-la. E, para isso,
utilizámos a função pré-definida __/transpose/__, para se retirar, a cada pista, a sua primeira peça, /Reta Terra 0/.
     
Em suma, devemos referir que cumprimos a maior parte dos objetivos requeridos, uma vez que apenas não conseguimos tornar
possível a deteção de padrões verticais e verticais desfasados.

-}

module Tarefa3_2019li1g168 where
import Tarefa1_2019li1g168
import Tarefa0_2019li1g168
import LI11920
import Data.List

-- * Testes

-- | Testes unitários da Tarefa 3.
--
-- Cada teste é um 'Mapa'.
testesT3 :: [Mapa]
testesT3 = [(gera 2 5 1), (gera 1 2 3), (gera 5 4 3), (gera 3 2 4), (gera 4 4 11)]

-- * Funções principais da Tarefa 3.

{- | Função que, dados o número da pista e uma peça, constrói uma __instrução__.

  * Se a peça for uma __reta__, então será uma instrução para andar;

  * Se a peça for uma __rampa__, então será uma intrução para descer ou para subir.-}
constroiInstrucao :: Int -> Peca -> Instrucao
constroiInstrucao pista (Recta p _) = (Anda [pista] p)
constroiInstrucao pista (Rampa p h1 h2) | h1>h2 = (Desce [pista] p (h1-h2))
                                        | h1<h2 = (Sobe [pista] p (h2-h1))

{- | Função que constrói uma lista de /Instrucao/ (__/Instrucoes/__), dados:

* Um par, cuja primeira componente corresponde ao indíce da pista indicada na segunda componente.-}
constroiInstrucoes :: (Int,Pista) -> Instrucoes
constroiInstrucoes (i,[]) = []
constroiInstrucoes a = constroiInstrucao (fst a) (head (snd a)) : constroiInstrucoes ((fst a), tail (snd a))

-- | Função que garante que o contador __/quantasRepete'/__ começa do zero.
quantasRepete :: Eq a => [a] -> Int
quantasRepete = quantasRepete' 0

-- | Função que funciona como contador para se determinar o número de vezes que uma instrução se repete.
quantasRepete' :: Eq a => Int -> [a] -> Int 
quantasRepete' i [x] = i+1
quantasRepete' i (x:y:t) | x == y = quantasRepete' (i+1) (y:t)
                         | otherwise = i+1

{- | Função que, dada uma lista de /Instrucao/ (/Instrucoes/), retorna uma lista de instruções de forma mais compacta.

A função só pode retornar a lista de instruções na forma __Repete__ se se repetir alguma instrução na lista dada.-}
repete :: Instrucoes -> Instrucoes
repete [] = []
repete l@(x:t) | n > 1 = (Repete n [x]) : repete (drop n l)
               | otherwise = x : repete t
    where n = quantasRepete l

{- | Função auxilar da /desconstroi/ que, dado um mapa, cria uma lista de pares cuja:

  * Primeira componente corresponde ao índice da pista;

  * Segunda componente corresponde à lista de instruções.-}
desconstroiAux :: Mapa -> [Instrucoes]
desconstroiAux  m = map (constroiInstrucoes) (zip [0..] m)

-- | Desconstrói um 'Mapa' numa sequência de 'Instrucoes'.
--
-- __NB:__ Uma solução correcta deve retornar uma sequência de 'Instrucoes' tal que, para qualquer mapa válido 'm', executar as instruções '(desconstroi m)' produza o mesmo mapa 'm'.
--
-- __NB:__ Uma boa solução deve representar o 'Mapa' dado no mínimo número de 'Instrucoes', de acordo com a função 'tamanhoInstrucoes'.

-- | Função que desconstrói um dado mapa em instruções.
desconstroi :: Mapa -> Instrucoes
desconstroi m@(h:t) = repete (concat (transpose (tail (transpose (desconstroiAux m)))))
