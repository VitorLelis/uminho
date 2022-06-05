{- |

=Relatório

A tarefa 5 teve como objetivo implementar o jogo, criado baseado no /ExciteBike/, inteiro. Para tal era necessário construir
as funções __/desenhaEstadoG/__, __/reageEventoG/__ e __/reageTempoG/__ e indicar, através de __/dm/__, __/color1/__, __/fr/__
e __/estadoIncial/__, a dimensão da tela onde decorrerá o jogo (neste caso, /FullScreen/), a cor ddo fundo da tela, a /frame rate/
definida e o estado inicial do jogo (__(Estado [] [],li)__), respetivamente.

A função /desenhaEstadoG/, que desenha o mapa, foi construída com o auxílio da função /desenhaEstadoGAux/ e consequentemente, da 
função /desenhaPista/. /desenhaEStadoGAux/ garante que, para ser desenhado mapa, seja utilizada a função que gera uma pista.

A nossa ideia, uma vez que tivemos dificuldades em desenvolver esta tarefa, foi desenhar o mapa por linhas e distinguir os diferentes
tipos de pisos por cores (/corPiso/).
Para ser criada uma pista, tivemos que construir uma função que dessenhasse uma instrução, dependente do seu tipo (/Anda/, /Sobe/,
/Desce/ e /Repete/). Esta utililza a função /corPiso/, responsável por associar a cada tipo de piso uma cor.

Foi também construída a função __/desenhaJogadors/__, responsável por desenhar uma lista de jogadores. Tal só foi possível criando
a função /desenhaJogador/ que desenha um jogador ao fazer /translate/ de uma imagem correspondente ao mesmo. Para isso, associamos uma
imagem ao índice de cada jogador, de uma lista de jogadores. Definimos que o número máximo de jogadores numa lista seria cinco.

Porém, tentamos sem sucesso, construir a função /reageEventoG/ e apenas conseguimos concluir a função /reageTempoG/, que permite alterar
o estado do jogo consoante a passagem do tempo com o auxílio da função /reageTempoPasso/. A /reageEventoG/ permitiria o uso do teclado para
controlar os movimentos do jogo.

Em suma, deve ser referido que não conseguimos concluir a tarefa 5, pois tivemos dificuldades a mesma. Reconhecemos, por isso, que o resultado
poderia ser melhor.

-}

module Main where

import Graphics.Gloss
import Graphics.Gloss.Interface.Pure.Game
import Graphics.Gloss.Juicy
import Tarefa4_2019li1g168
import Tarefa3_2019li1g168
import LI11920

-- | Função principal da Tarefa 5.
--
-- __NB:__ Esta Tarefa é completamente livre. Deve utilizar a biblioteca <http://hackage.haskell.org/package/gloss gloss> para animar o jogo, e reutilizar __de forma completa__ as funções das tarefas anteriores.

{- | O /EstadoGloss/ é um par ordenado cuja primeira componente é do tipo /Estado/, ou seja, da forma (Estado Mapa [Jogador]),
e cuja segunda componente é do tipo /[Picture]/.-}
type EstadoGloss = (Estado,[Picture])

{- | O estado inicial do jogo é do tipo /EstadoGloss/.
     O jogo começa com duas listas vazias (/Mapa/ e /[Jogador]/) e uma lista de imagens utilizadas no mesmo (/[Picture]/).-}
estadoInicial :: EstadoGloss
estadoInicial = (Estado [] [],li)

-- | Função que, dados o tempo (t) e o estado do jogo, permite alterar o estado do jogo consoante a passagem do tempo.
reageTempoG :: Double -> Estado -> EstadoGloss
reageTempoG t (Estado m js) = (Estado m (reageTempoPasso t m js),is) 

-- | Função que, dados o tempo (t), o mapa e uma lista de jogadores, aplica a função /passo/ a cada jogador.
reageTempoPasso :: Double -> Mapa -> [Jogador] -> [Jogador]
reageTempoPasso t m (j:jr) = (passo t m j) : reageTempoPasso t m jr

-- | A dimensão da tela onde o jogo irá decorrer: /FullScreen/.
dm :: Display
dm = FullScreen

-- | A /frame rate/ definida.
fr :: Int
fr = 50

-- | A cor escolhida para o fundo da tela.
color1 :: Color
color1 = (makeColorI 143 174 164 0)

-- | Função que torna possível o uso de teclas para controlar os movimentos dos jogadores.
reageEventoG :: Event -> EstadoGloss -> EstadoGloss
reageEventoG (EventKey (SpecialKey KeyUp)    Down _ _) (Estado m js,li) = e
reageEventoG (EventKey (SpecialKey KeyDown)  Down _ _) (Estado m js,li) = e
reageEventoG (EventKey (SpecialKey KeyRight) Down _ _) (Estado m js,li) = e
reageEventoG (EventKey (SpecialKey KeyLeft)  Down _ _) (Estado m js,li) = e
reageEventoG (EventKey (Char 'w') Down _ _) (Estado m js,li)            = e
reageEventoG (EventKey (Char 's') Down _ _) (Estado m js,li)            = e
reageEventoG (EventKey (Char 'd') Down _ _) (Estado m js,li)            = e
reageEventoG (EventKey (Char 'a') Down _ _) (Estado m js,li)            = e
reageEventoG _ e                                                        = e

{- | Função que define a cor da peça consoante o seu tipo de piso:

     1. Se for /Terra/ será castanho;

     2. Se for /Relva/ será verde;

     3. Se for /Cola/ será branco;

     4. Se for /Boost/ será vermelho;

     5. Se for /Lama/ será castanho avermelhado.-}
corPiso :: Piso -> Color
corPiso Terra = (makeColorI 360 100 7 1)
corPiso Relva = Color green
corPiso Cola  = Color white
corPiso Boost = Color red
corPiso Lama  = (makeColorI 360 100 19 1)

{- | Função que desenha uma dada instrução, dependendo do seu tipo. A cor da mesma corresponderá à cor do piso do tipo
     da peça em questão.
     Também é possível trabalhar com esta função quando se trata de uma instrução mais compacta, nomeadamennte do tipo
     /Repete/.-}
desenhaInstrucao :: Instrucao -> Picture
desenhaInstrucao (Anda _ p)                   = color (corPiso p) (Line [(0,0),(1,0)])
desenhaInstrucao (Sobe _ p h)                 = color (corPiso p) (Line [(0,0),(1,h)])
desenhaInstrucao (Desce _ p h)                = color (corPiso p) (Line [(0,h),(1,0)])
desenhaInstrucao (Repete n ((Anda _ p):t))    = color (corPiso p) (Line [(0,0),(n,0)])
desenhaInstrucao (Repete n ((Sobe _ p h):t))  = color (corPiso p) (Line [(0,0),(n,n*h)])
desenhaInstrucao (Repete n ((Desce _ p h):t)) = color (corPiso p) (Line [(0,n*h),(n,0)])

-- | Função que desenha uma pista dada uma lista de instruções
desenhaPista :: Instrucoes -> Float -> Float -> [Picture]
desenhaPista [] = []
desenhaPista (h:t) x y = (desenhaInstrucao h x y) : desenhaPista t (x+12.5) y

desenhaEstadoGAux :: Estado -> Float -> Float -> [Picture]
desenhaEstadoGAux (Estado [] js) _ _ = []
desenhaEstadoGAux (Estado (p:ps) js) x y = translate x y (desenhaPista p) : (desenhaEstadoGAux (Estado ps js) x (y-12.5)) 

desenhaEstadoG :: EstadoGloss -> [Picture]
desenhaEstadoG (e,li) = desenhaEstadoGAux e (-940) 525

-- | Função que desenha um jogador ao fazer /translate/ de uma imagem correspondente ao mesmo.
desenhaJogador :: Jogador -> [Picture] -> Picture
desenhaJogador (Jogador _ _ _ _ (Morto _)) li  = Blank
desenhaJogador (Jogador p dist velo cola _) li = translate dist p imgJogador

{- | Função que associa uma imagem ao indíce de uma dada lista de imagens:
     * 0 -> mota1 (rosa);
     
     * 1 -> mota2 (vermelha);
     
     * 2 -> mota3 (verde);
     
     * 3 -> mota4 (laranja);
     
     * 4 -> mota5 (amarela).-}
imgJogador :: [Picture] -> Picture
imgJogador li = case (encontraIndiceLista l) of 0 -> mota1
                                                1 -> mota2
                                                2 -> mota3
                                                3 -> mota4
                                                4 -> mota5

-- | Função que dada uma lista de jogadores, os desenha.
desenhaJogadors :: [Jogador] -> [Picture]
desenhaJogadors [] = []
desenhaJogadors (j:js) = (desenhaJogador j) : desenhaJogadors js

main :: IO ()
main = do
         Just mota1 <- loadJuicy "motorosa.png"
         Just mota2 <- loadJuicy "motovermelha.png"
         Just mota3 <- loadJuicy "motoverde.png"
         Just mota4 <- loadJuicy "motolaranja.png"
         Just mota5 <- loadJuicy "motoamarela.png"
         play dm   
              color1 
              fr     
              estadoInicial
              desenhaEstadoG 
              reageEventoG 
              reageTempoG