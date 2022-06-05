{- | 

=Relatório

A tarefa 4 teve como objetivo obter o resultado do efeito da passagem do tempo no jogo. Para tal, precisamos de considerar
quando o jogador está no chão, quando está no ar e quando está /Morto/.
     
Primeiramente, tivemos que construir as funções que possibilitam a atualização da velocidade do jogador. Nomeadamente, a
função que determina a aceleração constante (__/accelMota/__) e a função que define o atrito de acordo com o tipo de piso de
uma peça (__/atrito/__). Também temos as funções que, juntas, calculam a nova velocidade do jogador no chão garantindo que seja
no mínimo igual a 0 (_/velocidadeNova'/_ e _/velocidadeNova/_). E o mesmo para o jogador no ar (__/velocidadeNovaAr'/__ e
__/velocidadeNovaAr/__). Por fim, construímos a função que calcula a gravidade nova (__/gravidadeNova/__).
     
Quando um jogador está morto, existem apenas duas situações durante a passagem do tempo: o jogador permanece morto ou com
velocidade igual a 0 com estado /Chao False/, o que é respeitado na função __/jogadorMorto/__.
     
Se o jogador se encontrar no chão, então será conferido se a reta que corresponde ao deslocamento do jogador no chão 
(__/retaDeslocmentoChao/__) se cruza com uma reta vertical que corresponde ao limite de uma peça (__/retaLimiteChao/__). Para tal,
utilizam-se as funções /pontoIncialChao/, /deslocamentoChao/, /pontoFinalChao/, /descolarJog/ e /alturaPecaAnterior/, que 
determinam o ponto inicial de um jogador, o seu ponto de deslocamento, o seu ponto final, que o atualiza dado um ponto e, por
fim, que calcula a altura da peça anterior, respetivamente.
     
Se o jogador se encontrar no ar, será conferido se o jogador chegará ao chão durante o seu caminho no ar, se chegará ao
limite da peça ou se realizará o seu caminho normal no ar, através da função __/jogadorAr/__. De forma a construí-la, são utilizdas
as funções criadas para determinar o vetor do trajeto feito pelo jogador, o ponto em que ele está na pista, a sua posição final
após terminar trajeto, a maior altura entre dois pontos e, por fim, atualizar o jogador dado um ponto, denominadas /caminhoJog/,
/posiInicial/, /posiFinal/, /alturaMax/, /atualizarJog/, respetivamente.
     
Também são utilizadas as funções /retaJOgador/, /retaLimiteAr/, /retaPeca/ e /jogadorArChao/, que determinam a reta onde o
jogador realiza o trajeto, a reta que limita o seu mesmo trajeto, a reta da peça em que o jogador está e que atualiza o seu estado
quando este chega ao chão, respetivamente.
     
Deste modo, conseguimos construir as funções principais desta tarefa, nomeadamente as funções __/passo/__, __/acelera/__ e __/move/__.
E, por isso, acreditamos ter cumprido os objetivos da mesma, como requerido pelo docentes.

-}

module Tarefa4_2019li1g168 where

import Tarefa0_2019li1g168
import Tarefa1_2019li1g168
import Tarefa2_2019li1g168
import LI11920

-- * Testes
-- | Testes unitários da Tarefa 4.
--
-- Cada teste é um par (/tempo/,/'Mapa'/,/'Jogador'/).
testesT4 :: [(Double,Mapa,Jogador)]
testesT4 = [
            (2.3,(gera 2 5 1), (Jogador 1 2.1 2.4 2 (Chao True))),
            (2.3,(gera 2 5 2),(Jogador 1 2.1 2.4 2 (Ar 1.5 45 1))),
            (2.3,(gera 2 5 1),(Jogador 1 2.1 0.0 2 (Morto 2.6))),
            (1.3,(gera 2 5 2),(Jogador 1 1.1 2.4 2 (Ar 1.5 45 1))),
            (2.3,(gera 2 5 1),(Jogador 1 2.1 0.0 2 (Morto 0.6))),
            (2.3,(gera 2 5 1), (Jogador 1 2.1 1.4 2 (Chao True))),
            (2.3,(gera 2 5 1), (Jogador 1 2.1 1.4 2 (Chao False))),
            (2.3,(gera 2 5 2), (Jogador 0 3.1 2.4 2 (Chao True))),
            (2.3,(gera 2 5 2), (Jogador 1 3.1 2.4 2 (Chao True))),
            (1.3,(gera 2 5 2), (Jogador 1 1.1 1.4 2 (Chao True))),
            (1.3,(gera 2 5 2),(Jogador 1 1.1 2.4 2 (Ar 1.5 (-50) 1))),
            (2.3,(gera 2 5 3), (Jogador 0 1.1 2.4 2 (Chao True))),
            (2.3,(gera 2 5 4), (Jogador 0 3.4 2.4 2 (Chao True))),
            (2.3,(gera 2 5 5), (Jogador 0 1.4 2.4 2 (Chao True))),
            (0.3,(gera 2 5 2),(Jogador 1 1.1 0.4 2 (Ar 1.5 0 1))),
            (2.3,[[Recta Terra 0,Recta Cola 0, Recta Terra 0]], (Jogador 0 1.1 2.4 2 (Chao True))),
            (1.3,(gera 2 5 2),(Jogador 1 1.1 2.4 2 (Ar 1.5 350 1)))
            ]

-- * Funções principais da Tarefa 4.

-- | Verifica se o jogador está no chão.
accelJogador :: EstadoJogador -> Bool
accelJogador (Chao True) = True
accelJogador _ = False

-- | Função que determina a sua constante aceleração para calcular a velocidade nova.
accelMota :: Jogador -> Int
accelMota (Jogador _ _ v _ e) | v < 2 && accelJogador e = 1 | otherwise = 0

-- | Função que determina o atrito de acordo com o Piso. 
atrito :: Piso -> Double
atrito p = case p of Terra ->  0.25
                     Relva ->  0.75
                     Lama  ->  1.50
                     Boost -> -0.50
                     Cola  ->  3.00

-- | Função auxiliar responsável por calcular a nova velocidade do /Jogador/.
velocidadeNova' :: Double -> Jogador -> Peca -> Double
velocidadeNova' t j@(Jogador _ _ v _ _) (Recta p _) = v + ((fromIntegral(accelMota j)) - (atrito p)*v)*t
velocidadeNova' t j@(Jogador _ _ v _ _) (Rampa p _ _) = v + ((fromIntegral(accelMota j)) - (atrito p)*v)*t

-- | Função que, com a auxiliar, calcula a velocidade nova e garante que ela seja, no mínimo, igual a 0.
velocidadeNova :: Double -> Jogador -> Peca -> Double
velocidadeNova t j peca = max (velocidadeNova' t j peca) 0

-- | Função auxiliar que calcula a nova velocidade do /Jogador/ quando o mesmo estiver no /Ar/.
velocidadeNovaAr' :: Double -> Jogador -> Double
velocidadeNovaAr' t j@(Jogador _ _ v _ _) = v - (0.125*v*t)

-- | Função principal que, com auxiliar, garante a velocidade do /Jogador/ no /Ar/ seja, no mínimo, igual a 0. 
velocidadeNovaAr :: Double -> Jogador -> Double
velocidadeNovaAr t j | estaNoAr j = max (velocidadeNovaAr' t j) 0

-- | Função que calcula o valor da Gravidade, adotando 1.0 como sua aceleração.
gravidadeNova :: Double -> Double -> Double
gravidadeNova g t = g + 1.0*t --aceleração oferecida pela gravidade = 1.0

--Morto
-- | Função que determina como um /Jogador/ no Estado /Morto/ reage à passagem de tempo.
jogadorMorto :: Double -> Jogador -> Jogador
jogadorMorto t (Jogador pista dist velo cola (Morto timeout))
    | timeout - t > 0   = (Jogador pista dist velo cola (Morto (timeout - t)))
    | timeout - t <= 0  = (Jogador pista dist 0 cola (Chao False))

--Chao
-- | Função que descobre o ponto inicial do /Jogador/ num plano caretsiano da /Pista/ em que se encontra.
pontoInicialChao :: Peca -> Jogador -> Ponto
pontoInicialChao p1 (Jogador pista dist velo cola (Chao e)) = (Cartesiano dist (calcularAltura p1 dist))

-- | Função que calcula o ponto do deslocamento feito pelo /Jogador/.
deslocamentoChao :: Peca -> Jogador -> Double -> Ponto
deslocamentoChao p1 (Jogador pista dist velo cola e) t = multiplicaVetor t (Polar velo (calcularInclinacao p1))

-- | Função que determina o ponto final do /Jogador/ após se deslocar.
pontoFinalChao :: Peca -> Jogador -> Double -> Ponto
pontoFinalChao p1 j t = somaVetores (pontoInicialChao p1 j) (deslocamentoChao p1 j t)

-- | Função que monta uma /Reta/ do /Jogador/ usando como coordenadas seu ponto inicial e final do movimento.
retaDeslocamentoChao :: Peca -> Jogador -> Double -> Reta
retaDeslocamentoChao p1 j t = ((pontoInicialChao p1 j),(pontoFinalChao p1 j t))

-- | Função que determina uma /Reta/ vertical que servirá como limite para o movimento do /Jogador/ no chão.
retaLimiteChao :: Jogador -> Reta
retaLimiteChao (Jogador pista dist velo cola (Chao e)) = ((Cartesiano x (-1000)), (Cartesiano x 1000))
                                                                         where x = fromIntegral (floor dist) + 1.0

-- | Função que atualiza o /Jogador/ dado um determinado ponto.
deslocarJog :: Ponto -> Jogador -> Jogador 
deslocarJog (Cartesiano x y) (Jogador p d v c e) = (Jogador p x v c e)

-- | Função que determina a altura de uma determinada /Peca/ no seu final.
alturaPecaAnterior :: Peca -> Double
alturaPecaAnterior (Recta p h) = fromIntegral h
alturaPecaAnterior (Rampa p h1 h2) = fromIntegral h2 

-- | Função auxiliar que determina o /EstadoJogador/ quando este troca de /Peca/.
jogadorChao' :: Peca -> Peca -> Jogador -> Jogador
jogadorChao' pAtual pNova j@(Jogador pista dist velo cola (Chao b))
  | calcularInclinacao pAtual <= calcularInclinacao pNova = j
  | calcularInclinacao pAtual > calcularInclinacao pNova  
       = (Jogador pista dist velo cola (Ar (alturaPecaAnterior pAtual) (calcularInclinacao pAtual) 0.0))
                                             
{- | Função principal que confere se a /retaDeslocamentoChao/ e a /retaLimiteChao/ se cruzam.
      Caso seja verdadeiro, significa que o /Jogador/ chegou ao limite e irá trocar de /Peca/.
      Caso contrário, significa que ele se manteve na mesma /Peca/ e se deslocou normalmente. -}
jogadorChao :: Peca -> Peca -> Jogador -> Double -> Jogador
jogadorChao pAtual pNova j t | intersetam r1 r2 = jogadorChao' pAtual pNova (deslocarJog (intersecao r1 r2) j)
                             | otherwise = deslocarJog (pontoFinalChao pAtual j t) j 
                                     where r1 = retaLimiteChao j
                                           r2 = retaDeslocamentoChao pAtual j t  

--Ar
-- | Função que determina o vetor do caminho feito pelo /Jogador/ no ar. 
caminhoJog :: Jogador -> Double -> Vetor
caminhoJog (Jogador pista dist velo cola (Ar h i g)) t = multiplicaVetor t (somaVetores (Polar velo i) (Polar g (-90)))

-- | Função que determina o ponto em que o /Jogador/ se encontra no plano cartesiano da pista. 
posiInicial :: Jogador -> Vetor
posiInicial (Jogador pista dist velo cola (Ar h i g)) = (Cartesiano dist h)

-- | Função que calcula a posição final do /Jogador/ após terminar o seu caminho no ar.
posiFinal :: Jogador -> Double -> Vetor
posiFinal j t = somaVetores (caminhoJog j t) (posiInicial j)

-- | Função que determina a /Reta/ na qual o /Jogador/ realizará todo seu caminho.
retaJogador :: Jogador -> Double -> Reta 
retaJogador j t = ((posiInicial j),(posiFinal j t))

-- | Função que determina a maior altura entre 2 pontos.
alturaMax :: Vetor -> Vetor -> Double
alturaMax (Cartesiano x1 y1) (Cartesiano x2 y2) = max y1 y2

-- | Função que calcula a /Reta/ de limite do caminho feito pelo /Jogador/ no ar.
retaLimiteAr :: Jogador -> Double -> Reta
retaLimiteAr j@(Jogador pista dist v c e) t = (Cartesiano x 0.0, Cartesiano x y)
                                                            where x  = fromIntegral (floor dist) + 1.0
                                                                  y  = alturaMax pi pf
                                                                  pi = posiInicial j 
                                                                  pf = posiFinal j t

-- | Função que calcula a /Reta/ da /Peca/ em que o /Jogador/ se encontra.
retaPeca :: Peca -> Jogador -> Reta
retaPeca (Recta p h) (Jogador pista dist velo cola e) = (Cartesiano x h', Cartesiano x' h')
                                                            where x  = fromIntegral (floor dist)
                                                                  x' = x + 1.0
                                                                  h' = fromIntegral h
retaPeca (Rampa p h1 h2) (Jogador pista dist velo cola e) = (Cartesiano x h1', Cartesiano x' h2')
                                                              where x  = fromIntegral (floor dist)
                                                                    x' = x + 1.0
                                                                    h1' = fromIntegral h1
                                                                    h2' = fromIntegral h2

-- | Função que atualiza um /Jogador/ no ar, dado um determinado ponto.
atualizarJog :: Ponto -> Jogador -> Jogador
atualizarJog (Cartesiano x y) (Jogador p d v c (Ar h i g)) = (Jogador p x v c (Ar y i g))

-- | Função que atualiza o /EstadoJogador/ quando o mesmo chega ao chão.
jogadorArChao :: Peca -> Jogador -> Jogador
jogadorArChao pAtual (Jogador pista dist velo cola (Ar h i g))
   | abs (i' - ip) >= 45 = (Jogador pista dist 0 cola (Morto 1.0))
   | abs (i' - ip) < 45  = (Jogador pista dist v cola (Chao False)) 
         where v  = velo*(cos (((i-ip)*pi)/180))
               ip = calcularInclinacao pAtual
               i' = corrigirAngulo (normalizaAngulo i) 

{- | Função que confere determinadas condições para determinar o /Jogador/. 
       
       1 -> se o /Jogador/ chegará ao chão em seu caminho no ar.
       
       2 -> se ele chegará no limite da /Peca/.
       
       3 -> se ele realizará seu caminho normal no ar. -}
jogadorAr :: Peca -> Jogador -> Double -> Jogador
jogadorAr pAtual j t | intersetam r1 r3 = jogadorArChao pAtual (atualizarJog (intersecao r1 r3) j)
                     | intersetam r2 r3 = atualizarJog (intersecao r2 r3) j 
                     | otherwise = atualizarJog (posiFinal j t) j 
                             where r1 = retaPeca pAtual j  
                                   r2 = retaLimiteAr j t 
                                   r3 = retaJogador j t 

-- | Avança o estado de um 'Jogador' um 'passo' em frente, durante um determinado período de tempo.
passo :: Double -- ^ O tempo decorrido.
     -> Mapa    -- ^ O mapa utilizado.
     -> Jogador -- ^ O estado anterior do 'Jogador'.
     -> Jogador -- ^ O estado do 'Jogador' após um 'passo'.
passo t m j = move t m (acelera t m j)

-- | Altera a velocidade de um 'Jogador', durante um determinado período de tempo.
acelera :: Double -- ^ O tempo decorrido.
     -> Mapa    -- ^ O mapa utilizado.
     -> Jogador -- ^ O estado anterior do 'Jogador'.
     -> Jogador -- ^ O estado do 'Jogador' após acelerar.
acelera t m j@(Jogador pista dist v c (Chao b)) = (Jogador pista dist (velocidadeNova t j p) c (Chao b))
     where p = encontraPosicaoMatriz (pista,(floor dist)) m
acelera t m j@(Jogador pista dist v c (Ar h i g)) = (Jogador pista dist (velocidadeNovaAr t j) c (Ar h i (gravidadeNova g t)))
acelera t m j@(Jogador pista dist v c (Morto to)) = j

-- | Altera a posição de 'Jogador', durante um determinado período de tempo.
move :: Double -- ^ O tempo decorrido.
     -> Mapa    -- ^ O mapa utilizado.
     -> Jogador -- ^ O estado anterior do 'Jogador'.
     -> Jogador -- ^ O estado do 'Jogador' após se movimentar.
move t m j@(Jogador p dist velo c (Morto to)) = jogadorMorto t j
move t m j@(Jogador p dist velo c (Chao b)) = jogadorChao p1 p2 j t 
    where p1 = encontraPosicaoMatriz (p,(floor dist)) m
          p2 = encontraPosicaoMatriz (p,(floor dist + 1)) m
move t m j@(Jogador p dist velo c (Ar h i g)) = jogadorAr p1 j t
    where p1 = encontraPosicaoMatriz (p,(floor dist)) m