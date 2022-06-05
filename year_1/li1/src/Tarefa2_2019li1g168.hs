{- | 

=Relatório

A tarefa 2 teve como objetivo determinar o efeito de uma jogada no estado do jogo, dadas uma jogada de um jogador e uma
descrição do estado do jogo. Por isso, definimos que para cada jogada corresponde uma função: quando no chão, se o jogador
acelerar então será utilizada /acelera'/, ao desacelerar a função /desacelera/, ao disparar a /dispara/. Ao movimentar-se
para cima, baixo, esquerda e direita utiliam-se as funções /movimentaCima/, /movimentaBaixo/, /movimentaEsquerda/ e
/movimentaDireita/, respetivamente.
     
As funções __/acelera'/__ e __/desacelera/__ utilizam as funções /estaNoChao/, /aceleraJog/ e as funções da tarefa 0,
/encontraIndiceLista/ e /atualizaIndiceLista/, de modo a que estas atualizem a lista de jogadores quando o jogador 
/Acelera/ e quando /Desacelera/, respetivamente.

A função __/dispara/__ necessita das funções /estaNoChao/, /pecaCorreta/, /temCola/, /tirarBala/, /geraCola/ e das funções
da tarefa0 /encontraIndiceLista/, /encontraPosicaoMatriz/ e /atualizaPosicaoMatriz/, para, com estas, atualizar o número
de munições do jogador quando /Dispara/. Só o poderá fazer se estiver no chão e se não estiver na primeira peça da pista.

A função /movimentaCima/ precisa das funções /estaNoChao/, /podeSubir/, /compararAltura/, /paraCimaChao/, /paraChaoMorto,
/paraCimaChaoAr/ e das funções da tarefa 0, /encontraIndiceLista/ e /atualizaIndiceLista/, para que consiga atualizar o
estado do jogador quando este se movimenta para cima (/Movimenta C/). Tal só é possível se o jogador sobe de pista, se
passar a estar no ar ou se passar a estar morto.

A função /movimentaBaixo/ necessita das funções /estaNoChao/, /podeDescer/, /compararAltura2/, /paraBaixoChao/, /paraChaoMorto/,
/paraBaixoChaoAr/ e das funções da tarefa 0, /encontraIndiceLista/ e /atualizaIndiceLista/, para que consiga atualizar o
estado do jogador quando este se movimenta para baixo (/Movimenta B/). Tal só é possível se o jogador desce de pista, se
passar para a pista de baixo (no ar) ou se passar a estar morto.

A função /movimentaDireita/ precisa das funções /estaNoAr/, /inclinaDireita/ e das funções da tarefa 0, /encontraIndiceLista/ e 
/atualizaIndiceLista/, para que consiga atualizar o estado do jogador quando este se movimenta para a direita (/Movimenta D/).
Tal só é possível se o jogador estiver no ar.

A função /movimentaEsquerda/ precisa das funções /estaNoAr/, /inclinaEsquerda/ e das funções da tarefa 0, /encontraIndiceLista/ e 
/atualizaIndiceLista/, para que consiga atualizar o estado do jogador quando este se movimenta para a esquerda (/Movimenta E/).
Tal só é possível se o jogador estiver no ar.
     
Deste modo, conseguimos construir a função principal desta tarefa, nomeadamente a função __/jogada/. E, por isso, acreditamos 
ter cumprido os objetivos da mesma, como requerido pelo docentes.

-}

module Tarefa2_2019li1g168 where

import LI11920
import Tarefa0_2019li1g168
import Tarefa1_2019li1g168

-- * Testes

-- | Testes unitários da Tarefa 2.
--
-- Cada teste é um triplo (/identificador do 'Jogador'/,/'Jogada' a efetuar/,/'Estado' anterior/).
testesT2 :: [(Int,Jogada,Estado)]
testesT2 = [
             (0,Acelera,Estado (gera 2 3 5) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Acelera,Estado (gera 2 3 5) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao False))]),
             (0,Acelera,Estado (gera 2 3 5) [(Jogador 1 1 1 1 (Morto 1.0)),(Jogador 1 1 1 1 (Chao False))]),
             (0,Desacelera,Estado (gera 2 3 5) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao False))]),
             (0,Desacelera,Estado (gera 2 3 5) [(Jogador 1 1 1 1 (Morto 1.0)),(Jogador 1 1 1 1 (Chao False))]),
             (1,Desacelera,Estado (gera 2 3 5) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (1,Dispara,Estado (gera 2 3 5) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 0 (Chao True))]),
             (0,Dispara,Estado (gera 2 3 5) [(Jogador 1 2 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Dispara,Estado (gera 2 3 5) [(Jogador 1 2 1 0 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Dispara,Estado (gera 2 3 5) [(Jogador 0 2 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Dispara,Estado (gera 2 3 5) [(Jogador 0 2 1 0 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (1,Dispara,Estado (gera 2 3 6) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (1,Dispara,Estado (gera 2 3 5) [(Jogador 1 0 1 1 (Chao False)),(Jogador 1 1.5 1 1 (Chao True))]),
             (1,Dispara,Estado (gera 2 3 5) [(Jogador 1 1 0 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta C,Estado (gera 2 3 6) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta B,Estado (gera 2 3 6) [(Jogador 0 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta E,Estado (gera 2 3 6) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta D,Estado (gera 2 3 6) [(Jogador 1 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta D,Estado (gera 2 3 5) [(Jogador 0 1.1 1 1 (Ar 2 0 10)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta B,Estado (gera 2 3 5) [(Jogador 0 1.1 1 1 (Ar 2 0 10)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta C,Estado (gera 2 3 5) [(Jogador 0 1.1 1 1 (Ar 2 0 10)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta D,Estado (gera 2 3 5) [(Jogador 0 1.1 1 1 (Ar 2 (-80) 10)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta E,Estado (gera 2 3 5) [(Jogador 0 1.1 1 1 (Ar 2 0 10)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta E,Estado (gera 2 3 5) [(Jogador 0 1.1 1 1 (Ar 2 80 10)),(Jogador 1 1 1 1 (Chao True))]),
             (1,Movimenta C,Estado (gera 2 3 6) [(Jogador 0 1 1 1 (Chao False)),(Jogador 0 1 1 1 (Chao True))]),
             (1,Movimenta B,Estado (gera 2 3 6) [(Jogador 0 1 1 1 (Chao False)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta B,Estado (gera 3 2 11) [(Jogador 0 (1.3) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta B,Estado (gera 3 2 11) [(Jogador 1 (1.3) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta C,Estado (gera 3 2 11) [(Jogador 2 (1.3) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta C,Estado (gera 3 2 11) [(Jogador 1 (1.3) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta B,Estado (gera 4 4 1) [(Jogador 0 (2.3) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta B,Estado (gera 4 4 1) [(Jogador 1 (2.3) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta C,Estado (gera 4 4 1) [(Jogador 2 (2.3) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta C,Estado (gera 4 4 1) [(Jogador 1 (2.3) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta B,Estado (gera 3 4 5) [(Jogador 0 (3.4) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))]),
             (0,Movimenta C,Estado (gera 4 3 567) [(Jogador 3 (2.4) 1 1 (Chao True)),(Jogador 1 1 1 1 (Chao True))])
           ] 


-- * Funções principais da Tarefa 2.
-- | Função que confere se um dado jogador está no chão.
estaNoChao :: Jogador -> Bool
estaNoChao (Jogador _ _ _ _ (Chao _)) = True
estaNoChao _ = False

{- | Função que confere se um dado jogador não se encontra na primeira peça da pista.

 Se a função devolver True, então o jogador poderá disparar cola.-}
pecaCorreta :: Jogador -> Bool
pecaCorreta j = distanciaJogador j >= 1

-- | Função que devolve uma dada peça com o piso do tipo __Cola__.
geraCola :: Peca -> Peca
geraCola (Recta _ h) = (Recta Cola h)
geraCola (Rampa _ x y) = (Rampa Cola x y)

-- | Função que confere se o jogador tem munições.
temCola :: Jogador -> Bool
temCola (Jogador pista dist velo cola estado) = cola > 0 

{- | Função que retira munições.

Por cada vez que o jogador disparar será retirada uma bala.-}
tirarCola :: Jogador -> Jogador
tirarCola j@(Jogador pista dist velo cola estado) = (Jogador pista dist velo (cola-1) estado)

-- | Função que atualiza a lista de jogadores, retirando uma munição ao jogador que dispara.
tirarBala :: Int -> [Jogador] -> [Jogador]
tirarBala i js = atualizaIndiceLista i (tirarCola (encontraIndiceLista i js)) js -- atualiza o jogador na lista

{- | Função que atualiza o número de munições de um dado jogador quando este __/Dispara/__.

Jogador só poderá disparar se:

 *Estiver no chão;

 *Não estiver na primeira peça;

 *Tiver munições.-}
dispara :: Int -> Estado -> Estado
dispara i (Estado m js) | estaNoChao j && pecaCorreta j && temCola j = Estado ma (tirarBala i js)
                        | otherwise = (Estado m js) 
  where j  = encontraIndiceLista i js
        ma = atualizaPosicaoMatriz cj (geraCola(encontraPosicaoMatriz cj m)) m
        cj = (pistaJogador j , (floor(distanciaJogador j) - 1))

-- | Função que altera o estado de um dado jogador para __/Chao True/__.
aceleraJog :: Jogador -> Jogador
aceleraJog (Jogador pista dist velo cola e) = (Jogador pista dist velo cola (Chao True))

{- | Função que atualiza a lista de jogadores quando o jogador __/Acelera/__.

O jogador só poderá acelerar se estiver no chão.-}
acelera' :: Int -> Estado -> Estado
acelera' i e@(Estado m js) | estaNoChao j = (Estado m jsa)
                           | otherwise = e
  where j   = encontraIndiceLista i js
        jsa = atualizaIndiceLista i (aceleraJog j) js

-- | Função que altera o estado de um dado jogador para /Chao False/.
desaceleraJog :: Jogador -> Jogador
desaceleraJog (Jogador pista dist velo cola e) = (Jogador pista dist velo cola (Chao False))

{- | Função que atualiza a lista de jogadores quando o jogador __/Desacelera/__.

O jogador só poderá desacelerar se estiver no chão.-}
desacelera :: Int -> Estado -> Estado
desacelera i e@(Estado m js) | estaNoChao j = (Estado m jsa)
                             | otherwise = e
  where j   = encontraIndiceLista i js
        jsa = atualizaIndiceLista i (desaceleraJog j) js
        
-- | Função que confere se o jogador está no ar. 
estaNoAr :: Jogador -> Bool
estaNoAr (Jogador _ _ _ _ (Ar _ _ _)) = True
estaNoAr _ = False

-- | Função que garante a inclinação do jogador esteja entre 90 e -90 graus.
corrigirAngulo :: Double -> Double
corrigirAngulo a = if a' >= 270 then (a' - 360) else a' 
                       where a' = normalizaAngulo a 

{- | Função que inclina o jogador para a direita, tendo em conta uma restrição:

*O valor da diferença entre a inclinção e 15 não pode ser menor que -90 graus;

*Se isso acontecer, então a inclinação corresponde a -90 graus.-}
inclinaDireita :: Jogador -> Jogador
inclinaDireita j@(Jogador pista dist velo cola (Ar h inc g)) 
       | (inclinacao - 15 <= 90) && (inclinacao - 15 >= -90) = (Jogador pista dist velo cola (Ar h (inclinacao - 15) g))
       | inclinacao - 15 < -90 = (Jogador pista dist velo cola (Ar h (-90) g))
       where inclinacao = corrigirAngulo inc 
inclinaDireita j = j

{- | Função que atualiza a lista de jogadores quando o jogador inclina para a direita (jogada __/Movimenta D/__).

O jogador só poderá efetuar esta jogada se estiver no __ar__.-}
movimentaDireita :: Int -> Estado -> Estado
movimentaDireita i e@(Estado m js) | estaNoAr j = (Estado m jsa)  
                                   | otherwise = e
  where j   = encontraIndiceLista i js
        jsa = atualizaIndiceLista i (inclinaDireita j) js

{- | Função que inclina o jogador para a esquerda, tendo em conta uma restrição:

*O valor da soma da inclinação e 15 não pode ser maior que 90 graus;

*Se isso acontecer, então a inclinação corresponde a 90 graus.-}
inclinaEsquerda :: Jogador -> Jogador
inclinaEsquerda j@(Jogador pista dist velo cola (Ar h inc g)) 
      | (inclinacao + 15 <= 90) && (inclinacao + 15 >= -90) = (Jogador pista dist velo cola (Ar h (inclinacao + 15) g))
      | (inclinacao + 15) > 90 = (Jogador pista dist velo cola (Ar h 90 g)) 
      where inclinacao = corrigirAngulo (normalizaAngulo inc)

{- | Função que atualiza a lista de jogadores quando o jogador inclina para a esquerda (jogada __/Movimenta E/__).

O jogador só poderá efetuar esta jogada se estiver no __Ar__.-}
movimentaEsquerda :: Int -> Estado -> Estado
movimentaEsquerda i e@(Estado m js) | estaNoAr j = (Estado m jsa)  
                                    | otherwise = e
    where j   = encontraIndiceLista i js
          jsa = atualizaIndiceLista i (inclinaEsquerda j) js

-- | Função que confere se o jogador pode subir.
podeSubir :: Jogador -> Bool
podeSubir (Jogador pista dist velo cola estado) = if pista > 0 then True else False

-- | Função que confere se o jogador pode descer.
podeDescer :: Jogador -> Mapa -> Bool
podeDescer (Jogador pista dist velo cola estado) m = if (pista + 1) < length m then True else False

-- | Função que muda o jogador para a pista de cima no __chão__.
paraCimaChao :: Jogador -> Jogador
paraCimaChao j@(Jogador pista dist velo cola (Chao a)) = (Jogador (pista-1) dist velo cola (Chao a))

-- | Função que transforma o estado do jogador para __Morto__ quando este está no __chão__.
paraChaoMorto :: Jogador -> Jogador
paraChaoMorto j@(Jogador pista dist velo cola (Chao _)) = (Jogador pista dist (0.0) cola (Morto 1.0))

{- | Função que calcula a altura do jogador, dadas uma peça e uma distância na pista.

Se a peça dada for uma rampa, então esta pode estar a:

  1. Subir;

  2. Descer.-}
calcularAltura :: Peca -> Double -> Double
calcularAltura (Recta _ h) x = fromIntegral h
calcularAltura (Rampa _ h1 h2) x | h2 > h1 = (fromIntegral (abs(h2-h1))) * x 
                                 | h1 > h2 = (fromIntegral (abs(h2-h1))) * (1.0-x)

-- | Função que calcula a inclinação de uma dada peça.
calcularInclinacao :: Peca -> Double
calcularInclinacao (Recta _ h) = 0.0
calcularInclinacao (Rampa _ h1 h2) = ((atan (fromIntegral (h2-h1)))*180)/pi 

{- | Função que calcula a diferença de altura entre uma peça e a peça de cima.

Desta forma, compara a altura das peças.-}
compararAltura :: Jogador -> Mapa -> Double
compararAltura j m = (calcularAltura peca1 x) - (calcularAltura peca2 x)
       where peca1 = encontraPosicaoMatriz (p,d) m
             peca2 = encontraPosicaoMatriz ((p-1),d) m
             p = pistaJogador j 
             d = floor(distanciaJogador j)
             x = distanciaJogador j - fromIntegral(floor(distanciaJogador j))

-- | Função que muda o jogador para a pista de cima no __Ar__.
paraCimaChaoAr :: Jogador -> Mapa -> Jogador
paraCimaChaoAr j@(Jogador pista dist velo cola (Chao _)) m = (Jogador (pista-1) dist velo cola e)
                                                                where e = Ar hAnt k 0
                                                                      hAnt = calcularAltura peca x
                                                                      peca = encontraPosicaoMatriz (pista,floor(dist)) m
                                                                      x = dist - fromIntegral(floor(dist))
                                                                      k = calcularInclinacao peca

{- | Função que atualiza o estado do jogador quando este se movimenta para cima (jogada __/Movimenta C/__).

O estado do jogador atualiza consoante as seguintes condições:

  1. Se o módulo da diferença de altura das peças for menor ou igual a 0.2, então o __jogador sobe de pista__;
  
  2. Se a diferença de altura das peças for maior que 0.2, então o __jogador passa a estar no ar__;

  3. Se a diferença de altura das peças for menor que -0.2, então o __jogador passa a estar morto__.-}
movimentaCima :: Int -> Estado -> Estado
movimentaCima i e@(Estado m js) | estaNoChao j && podeSubir j && abs (compararAltura j m) <= 0.2 = (Estado m jsa)
                                | estaNoChao j && podeSubir j && compararAltura j m > 0.2 = (Estado m jsb)
                                | estaNoChao j && podeSubir j && compararAltura j m < (-0.2) = (Estado m jsc)
                                | estaNoAr j = e
                                | podeSubir j == False = e
    where j   = encontraIndiceLista i js
          jsa = atualizaIndiceLista i (paraCimaChao j) js
          jsb = atualizaIndiceLista i (paraCimaChaoAr j m) js
          jsc = atualizaIndiceLista i (paraChaoMorto j) js

{- | Função que calcula a diferença de altura entre uma peça e a peça de baixo.

Desta forma, compara a altura das peças.-}
compararAltura2 :: Jogador -> Mapa -> Double
compararAltura2 j m = (calcularAltura peca1 x) - (calcularAltura peca2 x)
       where peca1 = encontraPosicaoMatriz (p,d) m
             peca2 = encontraPosicaoMatriz ((p+1),d) m
             p = pistaJogador j 
             d = floor(distanciaJogador j)
             x = distanciaJogador j - fromIntegral(floor(distanciaJogador j))

-- | Função que muda o jogador para a pista de baixo no __chão__.
paraBaixoChao :: Jogador -> Jogador
paraBaixoChao j@(Jogador pista dist velo cola (Chao a)) = (Jogador (pista+1) dist velo cola (Chao a))

-- | Função que muda o jogador para a pista de baixo no __ar__.
paraBaixoChaoAr :: Jogador -> Mapa -> Jogador
paraBaixoChaoAr j@(Jogador pista dist velo cola (Chao _)) m = Jogador (pista+1) dist velo cola e
                                                                     where e = Ar hAnt k 0
                                                                           hAnt = calcularAltura peca x
                                                                           peca = encontraPosicaoMatriz (pista,floor(dist)) m
                                                                           x = dist - fromIntegral(floor(dist))
                                                                           k = calcularInclinacao peca

-- | Função que atualiza o estado do jogador quando este realiza a jogada __/Movimenta B/__.
movimentaBaixo :: Int -> Estado -> Estado
movimentaBaixo i e@(Estado m js) | estaNoChao j && podeDescer j m && abs (compararAltura2 j m) <= 0.2 = (Estado m jsa)
                                 | estaNoChao j && podeDescer j m && compararAltura2 j m > 0.2 = (Estado m jsb)
                                 | estaNoChao j && podeDescer j m && compararAltura2 j m < (-0.2) = (Estado m jsc)
                                 | podeDescer j m == False = e
                                 | otherwise = e
    where j   = encontraIndiceLista i js
          jsa = atualizaIndiceLista i (paraBaixoChao j) js
          jsb = atualizaIndiceLista i (paraBaixoChaoAr j m) js
          jsc = atualizaIndiceLista i (paraChaoMorto j) js


-- | Efetua uma jogada.
jogada :: Int -- ^ O identificador do 'Jogador' que efetua a jogada.
       -> Jogada -- ^ A 'Jogada' a efetuar.
       -> Estado -- ^ O 'Estado' anterior.
       -> Estado -- ^ O 'Estado' resultante após o jogador efetuar a jogada.
jogada i j e = case j of Acelera     -> acelera' i e 
                         Desacelera  -> desacelera i e
                         Dispara     -> dispara i e 
                         Movimenta C -> movimentaCima i e 
                         Movimenta D -> movimentaDireita i e 
                         Movimenta B -> movimentaBaixo i e 
                         Movimenta E -> movimentaEsquerda i e 