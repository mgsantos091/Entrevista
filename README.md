Jogo de Campo Minado. Parâmetros iniciais de Minesweeper: largura, altura e número de minas do tabuleiro.

O usuário tem duas opções neste ambiente (ambas precisam de um objeto Minesweeper instanciado):
1. Criar um engine próprio e trabalhar com as funções públicas do objeto.
2. Chamar o método run que executa o modo interativo built-in na classe Minesweeper.

Funções públicas:
1. play(x, y): coordenadas linha e coluna do tabuleiro aonde a célula será descoberta, aonde 0 < x <= altura_tabuleiro e 0 < y <= largura_tabuleiro. A primeira jogada realiza a distribuição de minas no tabuleiro (evita derrota em primeiro turno). Caso uma bomba exista nesta posição, o jogo será finalizado.
2. flag(x, y): coordenadas linha e coluna do tabuleiro aonde será adicionado uma bandeira, aonde 0 < x <= altura_tabuleiro e 0 < y <= largura_tabuleiro. Caso uma bandeira já exista nesta posição, ela será removida.
3. still_playing?: indica se o jogo ainda esta sendo executado.
4. victory?: indica se o jogo esta em estado de vitória, apenas se o jogo já foi finalizado.
5. board_state: retorna array de objetos do tipo BoardObject que indicam o estado atual do tabuleiro. Caso xray seja passado como true, e o jogo já tenha sido finalizado, os objetos retornados vão ter a informação indicando se a célula é uma mina ou não.
6. run: inicia o modo interativo do jogo.

Como o projeto funciona?
Foi utilizado principios de paradigmas OO do Ruby, a classe Minesweeper manipula objetos Cell para controle do tabuleiro e utiliza BoardObject para devolução de estado das células ao usuário.

Minesweeper possui dois principais arrays de objetos para controlar o tabuleiro: 
1. @cells array bidimensional composto por instancias de Cell
2. @cells_mines_rand array bidimensional composto por posições de arrays (x,y) indicando as minas do tabuleiro.

@cells é populado em Minesweeper.fill_mines na primeira execução de Minesweeper.play, populando @cells_mines_rand de maneira aleatória (usando o método shuffle do produto cartesiano entre os indices de linhas e colunas possiveis do tabuleiro) em Minesweeper.randomize_mines porém descartando a posição da primeira jogada do usuário evitando que o mesmo possa ser derrotado na primeira rodada. No mesmo método fill_mines o método populate_cells_nearby é executado para indicar a cada instancia de Cell quais são seus vizinhos.

A alteração de estado de cada célula é feito dentro da classe Cell, como as operações de bandeira, descoberta e expansão. Inicialmente Cell.expand foi desenvolvido utilizando recursão, porém como o de chamadas é incerto, a sua implementação foi alterado para evitar stack trace overflow e melhorar performance.

Foram desenvolvidos dois printers para este projeto: PrettyPrinter e SimplePrinter sendo o primeiro o que traz informações visuais para o usuário.

Como este projeto foi testado?
Em tc_engine.rb foram desenvolvidos Test Cases para indicar que o projeto funciona como esperado para instanciação, indicação de vitória e derrota em uma centena de jogos aleatórios.

Por favor execute ruby engine.rb para executar o jogo em modo interativo.

Requisitos originais:

1. No início do jogo, a engine deve aceitar parâmetros de altura, largura e número de bombas no tabuleiro. As bombas devem ser distribuídas aleatoriamente, de forma que todas as combinações de posições possíveis tenham a mesma probabilidade de acontecer.

2. Sua engine deve expor um conjunto mínimo de métodos para o cliente:

  - play: recebe as coordenadas x e y do tabuleiro e clica na célula correspondente; a célula passa a ser "descoberta". Deve retornar um booleano informando se a jogada foi válida. A jogada é válida somente se a célula selecionada ainda não foi clicada e ainda não tem uma bandeira. Caso a célula clicada seja válida, não tenha uma bomba e seja vizinha de zero bombas, todos os vizinhos sem bomba e sem bandeira daquela célula também devem ser descobertas, e devem seguir esta mesma lógica para seus próprios vizinhos (esse é o comportamento de expansão quando clicamos em uma grande área sem bombas no jogo de campo minado).

  - flag: adiciona uma bandeira a uma célula ainda não clicada ou remove a bandeira preexistente de uma célula. Retorna um booleano informando se a jogada foi válida.

  - still_playing?: retorna true se o jogo ainda está em andamento, ou false se o jogador tiver alcançado a condição de vitória (todas as células sem bomba foram descobertas) ou de derrota (jogador clicou em uma célula sem bandeira e ela tinha uma bomba).

  - victory?: retorna true somente se o jogo já acabou e o jogador ganhou.

  - board_state: retorna uma representação atual do tabuleiro, indicando quais células ainda não foram descobertas, se alguma foi descoberta e tem uma bomba, quais foram descobertas e têm células com bombas como vizinhas (indicar quantas são as vizinhas minadas), quais não estão descobertas e com bandeira. Se o cliente passar o hash {xray: true} como parâmetro, deve indicar a localização de todas as bombas, mas somente se o jogo estiver terminado.


3. Uma célula descoberta deve saber informar o número de bombas adjacentes a ela, se houver alguma (entre 1 e 8). Se não tiver bombas adjacentes, deve ser considerada uma célula descoberta e vazia.

4. Crie pelo menos dois tipos de objeto "printer" que mostrem no terminal o estado do tabuleiro. Esses printers servem como exemplo de como um cliente pode consumir o método "board_state" da sua engine. Por exemplo, um deles pode simplesmente imprimir uma matriz mapeando os estados para caracteres segundo a especificação:

board_format = {
  unknown_cell: '.',
  clear_cell: ' ',
  bomb: '#',
  flag: 'F'
}
5. Ao efetuar uma jogada em uma bomba (sem bandeira), o jogo deve terminar e nenhuma outra jogada subsequente deve ser considerada válida.

6. Demonstre, da maneira que achar melhor, que o seu projeto funciona como especificado.
