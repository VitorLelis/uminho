{- | 

=Relatório

A tarefa 6 teve como objetivo a implementação de um robô capaz de jogar /ExciteBike/ automaticamente. O nosso robô foi 
criado de forma a conseguir tirar o maior proveito estando no ar, a disparar cola e a trocar de pista, se ao fazê-lo 
trouxer vantagens. Este pode também desacelerar, verificar se os estado de um jogador é /Morto/ e, quando estiver no chão,
poderá fazer a melhor jogada possível.
     
No ar, o /bot/ tentará ajustar a sua inclinação para que possa ter a maior velocidade resultante possível através da
função _/botNoAr/_.
     
Através da função _/jogadoresAtras/_, que confere se existe algum jogador na mesma peça e a atrás do /bot/, o robô
decide se deve disparar cola.
     
Para trocar de pista, foram criadas cinco funções que ajudam o robô a decidir o melhor trajeto a seguir. Primeiramente, foi
criada a função auxiliar _/trajeto/_, que calcula o trajeto possível numa dada peça. Fá-lo ao usar a função /atrito/, criada na 
tarefa 4, e a distância da peça. Se a peça for uma reta a sua distância será 1.0, e se a peça for uma rampa a sua distância será 
o valor da hipotenusa, cujos catetos associados são o tamnho da peça (1.0) e a diferença entre as alturas.
     
De seguida, foi construída a função valeTrocar que confere se vale a pena trocar de peça, onde o único critério é o trajeto de
cada peça. Só valerá a pena trocar caso a peça em que o /bot/ se encontra tenha o trajeto maior à qual se avalia.
     
Posteriormente, foram criadas as funções _/valeDescer/_ e _/valeSubir/_ que, com a ajuda das funções /podeDescer/ e /podeSubir/ 
da tarefa 2, conferem se vale a pena descer de pista (se tiver uma pista abaixo) e se vale a pena subir de pista (se tiver uma 
pista acima), respetivamente. Outras duas condições são que a diferença de altura da troca seja pelo menos -0.2 (evitando que o 
/Jogador/ morra) e que o novo trajeto seja vantajoso (conferido através da função /valeTrocar).
     
Por fim, basta fazer referência à função _/botNoMeio/_  que compara o trajeto de pistas adjacentes à atual, para determinar qual
entre elas é a mais vantajosa.
     
Faltam ser referidas mais duas funções que auxiliam a análise da melhor jogada a realizar, quando o jogador está no chão: _/rampa/_
que confere se a peça dada é uma rampa e _/estaMorto/_ que confere se o jogador está morto.
     
Com o intuito de realizar a melhor /Maybe Jogada/, a função _/botNoChao/_ analisa as condições dos casos:

1. _/Just Dispara/_

Se o jogador tiver uma munição de cola (/temCola/) e se tiver jogadores atrás de si (/jogadoresAtras/), então o jogador /Dispara/,
para ganhar vantagem;
      
2. _/botNoMeio/_

Se as funções /valeSubir/ e /valeDescer/ forem ambas verdadeiras (/True/), então os trajetos das pistas adjacentes são melhores que
o trajeto atual. Portanto, comparará os trajetos adjacentes entre si, determinando o melhor possível;
      
3. _/Just (Movimenta C)/_

Se a função /valeSubir/ for verdadeira (/True/) e a /valeDescer/ falsa (/False/), então o melhor trajeto é o de cima e, por isso, 
realiza-se a jogada /Movimenta C/;
      
4. _/Just (Movimenta B)/_

Se a função /valeDescer/ for verdadeira (/True/) e a /valeSubir/ falsa (/False/), então o melhor trajeto é o de baixo e, por isso,
realiza-se a jogada /Movimenta B/;
      
5. _/Just Desacelera/_

Se o jogador se encontrar numa rampa (/rampa/) e a /velocidadeJogador/ for maior que 0, para evitar uma desaceleração desnecessária,
então o jogador desacelerará para manter-se mais próximo do chão (/Desacelera/);
     
6. _/Just Acelera/_

Caso todos os casos anteriores não se conferirem, mas o jogador ainda se mantiver no chão, O /Jogador/ irá acelerar normalmente para
manter-se na corrida.
     
Para finalizar, foi construída a função principal desta tarefa, _/bot/_, utilizando as suas funções auxiliares: /botNoAr/ e /botNoChao.
Com a função /bot/ construímos um robô com a capacidade de trocar de pista, de ter uma maior velocidade no ar, de se movimentar, acelerar,
e desacelerar da forma mais vantajosa possível.
     
Deste modo, acreditamos ter conseguido um resultado positivo neste desafio lançado pelos docentes.

-}


module Tarefa6_2019li1g168 where

import LI11920
import Tarefa0_2019li1g168
import Tarefa2_2019li1g168
import Tarefa4_2019li1g168

-- * Funções principais da Tarefa 6.
-- Bot enquanto estiver no Ar
{- | Função onde o /bot/ quando estiver no ar tentará ajustar sua inclinação para ser a mesma da /Peca/ em que ele pousará.
     Desta forma, garante-se que ele terá a maior velocidade resultante possível, já que sua velocidade ao pousar será:

         Velocidade ao pousar = velocidade no ar * cos(diferença dos ângulos);

     Ou seja, quanto mais próximo estivermos do valor máximo de cosseno (cos(0) = 1), maior será sua velocidade ao pousar.  -}
botNoAr :: Jogador -> Peca -> Maybe Jogada
botNoAr j@(Jogador p d v c (Ar h i g)) p1  | (i' - ip) < 0 = Just (Movimenta E) 
                                           | (i' - ip) > 0 = Just (Movimenta D) 
                                           | otherwise    = Nothing
                                                 where ip = calcularInclinacao p1
                                                       i' = corrigirAngulo i

--Bot para disparar cola 

{- | Função que confere de forma recursiva na lista de jogadores se algum jogador está na mesma /Pista/, mas atrás do dado /Jogador/.
     Para determinar isto, compara-se a /Pista/ e a /Distancia/ do primeiro /Jogador/ na lista com o dado /Jogador/ "j".
     Se conferir nas condições, é porque pelo menos um está atrás.
     Caso contrário, chama a função de forma recursiva com a lista restante até encontrar ou chegar à lista Vazia. -} 
jogadoresAtras :: Jogador -> [Jogador] -> Bool
jogadoresAtras j [] = False
jogadoresAtras j (jh:jt) = if p1 == p2 && d1 > d2 then True else jogadoresAtras j jt
                                 where p1 = pistaJogador j 
                                       p2 = pistaJogador jh 
                                       d1 = distanciaJogador j 
                                       d2 = distanciaJogador jh

--Bot trocando de pista

{- | Função auxiliar que calcula o possível trajeto que seria feito na determinada /Peca/. 
     O cálculo é feito através do produto entre o atrito do /Piso/ da /Peca/ com o que seria percorrido na superfície da /Peca/. 
     A distância percorrida na superfície varia de acordo com o tipo da /Peca/:

     * Recta -> percorre uma distâcia igual a 1.0, visto que é o tamanho da /Peca/ em si;
     * Rampa -> percorre a hipotenusa da /Peca/ onde os catetos seriam: o tamanho da /Peca/ (1.0) e a diferença entre as alturas.-} 
trajeto :: Peca -> Double
trajeto (Recta p h) = (atrito p) * 1.0 -- 1.0 distancia da peça
trajeto (Rampa p h1 h2) = (atrito p) * hipo
                             where hipo = sqrt (1.0 + h')
                                   h'   = (fromIntegral (h1-h2))^2 

{- | Função que confere se valeria trocar de uma /Peca/ para outra, onde o critério seria o trajeto de cada. 
     Caso a /Peca/ em que se encontra (/pAtual/) tenha o trajeto maior à qual se avalia (/pPossivel/), valeria trocar (/True/).
     Caso contrário, não valeria trocar (/False/). -}
valeTrocar :: Peca -> Peca -> Bool
valeTrocar pAtual pPossivel = trajeto pAtual > trajeto pPossivel

{- | Função que analisa se vale trocar para /Pista/ acima, seguindo determinadas condições:
      
      1 -> confere a função /podeSubir/, que analisa se a /Pista/ atual possui uma outra acima de si;

      2 -> confere na /compararAltura/ se a diferença de altura da troca é pelo menos -0.2, evitando que o /Jogador/ morra;
           
      3 -> confere ,por fim, na /valeTrocar/ se o novo trajeto seria de fato mais vantajoso. -}
valeSubir :: Jogador -> Mapa -> Bool
valeSubir j m = podeSubir j && (compararAltura j m) >= (-0.2) && valeTrocar p1 p0 
                              where p1 = encontraPosicaoMatriz (p,d) m 
                                    p0 = encontraPosicaoMatriz (p-1,d) m
                                    p  = pistaJogador j 
                                    d  = floor (distanciaJogador j)

{- | Função que analisa se vale trocar para /Pista/ abaixo, seguindo determinadas condições:
      
      1 -> confere a função /podeDescer/, que analisa se a /Pista/ atual possui uma outra abaixo de si;

      2 -> confere na /compararAltura/ se a diferença de altura na troca é pelo menos -0.2, evitando que o /Jogador/ morra;
           
      3 -> confere ,por fim, na /valeTrocar/ se o novo trajeto seria de fato mais vantajoso. -}
valeDescer :: Jogador -> Mapa -> Bool
valeDescer j m = podeDescer j m && (compararAltura2 j m) >= (-0.2) && valeTrocar p1 p2
                              where p1 = encontraPosicaoMatriz (p,d) m
                                    p2 = encontraPosicaoMatriz (p+1,d) m 
                                    p  = pistaJogador j 
                                    d  = floor (distanciaJogador j)

-- | Função que compara o trajeto de /Pistas/ adjacentes à atual, para determinar qual entre elas é mais vantajosa.
botNoMeio :: Jogador -> Mapa -> Maybe Jogada 
botNoMeio j m = if trajeto p0 <= trajeto p2 then Just (Movimenta C) else Just (Movimenta B)
                             where  p0 = encontraPosicaoMatriz (p-1,d) m
                                    p2 = encontraPosicaoMatriz (p+1,d) m 
                                    p  = pistaJogador j 
                                    d  = floor (distanciaJogador j)

--Bot para desacelerar

-- | Função que confere se a /Peca/ dada é uma /Rampa/.
rampa :: Peca -> Bool
rampa (Rampa _ _ _) = True
rampa _ = False

--Bot morto

-- | Função que confere se o /EstadoJogador/ é /Morto/.
estaMorto :: Jogador -> Bool
estaMorto (Jogador _ _ _ _ (Morto _)) = True
estaMorto _ = False                                       

-- Bot no Chao
{- | Função que analisa as condições dos casos para realizar a melhor /Maybe Jogada/:
   
    1 -> /Just Dispara/:

       1.A -> Confere na função /temCola/ se o /Jogador/ possui munição de /Cola/;

       1.B -> Confere em /jogadoresAtras/ se há jogadores atrás;

       1.C -> Se ambas conferirem, ele realiza a jogada /Dispara/ para atrapalhar os adversários atrás;

    2 -> /botNoMeio/:

       2.A -> Confere se /valeSubir/ e /valeDescer/ são ambas verdadeiras (/True/);

       2.B -> Caso sejam, significa que o trajeto das /Pistas/ adjacentes são melhores que o atual.
              Portanto, para determinar o melhor possível, comparará os adjacentes entre si;

    3 -> /Just (Movimenta C)/:

       3.A -> Confere se /valeSubir/ é verdadeira (/True/) e /valeDescer/ falsa (/False/);

       3.B -> Quando isto ocorrer, significa que o trajeto de cima é o melhor. Logo, se realiza a jogada /Movimenta C/;

    4 -> /Just (Movimenta B)/:

       4.A -> Confere se /valeDescer/ é verdadeira (/True/) e /valeSubir/ falsa (/False/);

       4.B -> Quando isto ocorrer, significa que o trajeto de baixo é o melhor. Logo se realiza jogada /Movimenta B/;

    5 -> /Just Desacelera/:

       5.A -> A função /rampa/ confere se o /Jogador/ se encontra numa /Peca/ do tipo /Rampa/;

       5.B -> Verifica-se se a /velocidadeJogador/ é maior que 0, para evitar uma desaceleração desnecessária;

       5.C -> Se conferirem, o /Jogador/ realizará uma desaceleração para manter-se mais próximo da superfície, ou seja, o chão;

    6 -> /Just Acelera/:

       6.A -> Quando todos os casos anteriores não conferirem, mas ele ainda se mantiver no chão;

       6.B -> O /Jogador/ irá acelerar normalmente para manter-se na corrida.  
-}
botNoChao :: Jogador -> Estado -> Maybe Jogada
botNoChao j (Estado m js) | temCola j && jogadoresAtras j js = Just Dispara
                          | valeSubir j m && valeDescer j m = botNoMeio j m
                          | valeSubir j m && valeDescer j m == False = Just (Movimenta C)
                          | valeDescer j m && valeSubir j m == False = Just (Movimenta B)
                          | rampa p1 && v > 0 = Just Desacelera
                          | otherwise = Just Acelera 
                              where p1 = encontraPosicaoMatriz (p,d) m
                                    p  = pistaJogador j 
                                    d  = floor (distanciaJogador j)
                                    v  = velocidadeJogador j

-- | Define um ro'bot' capaz de jogar autonomamente o jogo.
bot :: Int          -- ^ O identificador do 'Jogador' associado ao ro'bot'.
    -> Estado       -- ^ O 'Estado' para o qual o ro'bot' deve tomar uma decisão.
    -> Maybe Jogada -- ^ Uma possível 'Jogada' a efetuar pelo ro'bot'.
bot i e@(Estado m js)   | estaNoAr j = botNoAr j p1 
                        | estaNoChao j = botNoChao j e
                        | estaMorto j = Nothing
                              where j  = encontraIndiceLista i js 
                                    p1 = encontraPosicaoMatriz (p,d) m
                                    p  = pistaJogador j 
                                    d  = floor (distanciaJogador j)