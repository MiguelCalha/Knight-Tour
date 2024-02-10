# Projeto Nº2: Época Normal 

![Alt text](https://di.ips.pt/Content/images/DI/Logo_IPS.png)

## Inteligência Artificial 23/24

* Prof. Joaquim Filipe
* Eng. Filipe Mariano

# Jogo do Cavalo (Knight's Tour)

### Manual de Utilizador

 Realizado por:

* Miguel Calha - 201902037

* João Dâmaso - 201901629 

* Marcos Jesus - 201900268 

# Índice

1. Introdução
2. Instalação
3. Configuração
4. Execução
5. Modos de Jogo
6. Output esperado
7. Limitações Técnicas

# 1. Introdução

Este documento contempla os passos que são necessários de seguir para a execução bem sucedida da aplicação.

# 2. Instalação

Para visualizar o código fonte e executar o mesmo é necessário recorrer à instalação de um IDE chamado "Lisp Works".


O LispWorks é uma plataforma integrada que serve como ferramenta de desenvolvimento para Common Lisp.
É possível fazer download do mesmo seguindo este [link](http://www.lispworks.com/products/lispworks.html)

![alt text](https://european-lisp-symposium.org/static/logos/lispworks.png?sanitize=true "LispWorks")

# 3. Configuração

O jogo contempla 4 ficheiros diferentes: 

* interact.lisp - Interação com o utilizador, escrita e leitura de ficheiros.

* jogo.lisp - Implementação da resolução do problema incluindo seletores, operadores do jogo

* algoritmo.lisp - Implementação do algoritmo de procura de profundidade Negamax com cortes Alfa-Beta

* log.dat - Ficheiro gerado para guardar os logs das execuções e métricas

 Visto que a estrutura do projeto é composta por 3 ficheiros distintos, para cada máquina temos de configurar o caminho da diretoria desses ficheiros, então a alteração a realizar deverá alterar o *Path* no ficheiro:

O primeiro passo será abrir o ficheiro "intercat.lisp" com o IDE LispWorks. No topo do mesmo encontra-se a função abaixo que devemos alterar o path para o path do nosso computador onde temos o projeto:

```lisp 
(defun current-directory ()
  (let ((path "C:\\Users\\duart\\Desktop\\Projeto2IA\\"))
    path
  )
)
```

Após configurarmos o path dos ficheiros, é necessário abrirmos o ficheiro "jogo" e alterarmos também o file-path do ficheiro log.dat:

```lisp 
(defun file-path ()
  (make-pathname :directory '(:absolute "Users" "duart" "Desktop")
                 :name "log"
                 :type "dat"))
```
# 4. Execução

Para executarmos o jogo é necessário abrir o ficheiro: interact. Irmos à barra de cima e clicarmos na terceira opção a partir da bola vermelha que se chama: "Compile Buffer". 

Na imagem abaixo é possível observar onde temos de clicar (quadrado preto).

![alt text](https://gcdnb.pbrd.co/images/lXgRdLSsDIEz.png?o=1)

*Fig.1 Compile Buffer*

Após compilarmos, inserimos o seguinte comando no Listner:

```lisp
(start)
```

Após inserir o comando, o menu inicial é mostrado.

# 5. Modos de Jogo

Após seguirmos os passos mencionados nos tópicos anteriores, deverá surgir este menu na consola:


![alt text](https://gcdnb.pbrd.co/images/5CCHYZLI3KPU.png?o=1)

*Fig.2 Menu Principal*

Para escolher um modo de jogo é só inserir um dos números das opções na consola e clicar "Enter".
Podemos inserir as seguintes opções: 1, 2 ,3 ou q.

### 5.1 Play Human vs Computer

No primeiro modo de jogo é necessário escolher quem começa o jogo (Humano ou computador), seguido do tempo que queremos que o computador demore a executar o programa. Como podemos observar na imagem:



![alt text](https://gcdnb.pbrd.co/images/1SwKh377HTZK.png?o=1)

*Fig.3 HumanVsComputer*

Seguidamente, neste caso como selecionamos que o computador começava, é atribuído o cavalo branco ao computador e a posição -1 mostra onde o computador se encontra de momento:


![alt text](https://gcdnb.pbrd.co/images/ALXsnPJQSirw.png?o=1)

*Fig.4 Colocar cavalo*

Após inserirmos a coordenada onde queremos que o nosso cavalo começe o jogo vai desenrolando e o computador vai jogando e depois o humano. Nas vezes do humano é mostrado um menu que mostra os operadores disponíveis para efetuar os movimentos.


![alt text](https://gcdnb.pbrd.co/images/UYnRBfDig3GX.png?o=1)

*Fig.5 operadores*
### 5.2 Play Computer vs Computer

Quando selecionamos esta opção, é nos apresentado um menu para escolher o tempo de processamento do computador (1 a 5 segundos). 


![alt text](https://gcdnb.pbrd.co/images/uI81y20fl3Pw.png?o=1)

*Fig.6 Tempo de processamento*

Após escolher o tempo o jogo é iniciado e o computador vai jogar com ele prórpio.

### 5.3 Operator List

Se selecionarmos a opção de ver o menu de operadores, é apresentado o menu da figura 7 que contém que movimentos é que fazem cada um dos operadores.

![alt text](https://gcdnb.pbrd.co/images/FiozIvLyLmFb.png?o=1)

*Fig.7 Menu de operadores*

Para escolher uma opção de jogo novamente, basta inserir o valor 1 ou 2 e vai entrar no modo de jogo correspondente.

# 6. Exemplo de output esperado

# 6.1 Computador vs Humano
```lisp
  A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |-1  |96  |42  |32  |5   |90  |2   |86  |10  |74  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |29  |NIL |60  |85  |46  |53  |70  |49  |38  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |15  |73  |69  |80  |63  |58  |66  |93  |75  |57  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |91  |0   |7   |50  |41  |13  |68  |37  |72  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 5 |81  |19  |56  |21  |39  |95  |16  |83  |97  |3   |
  +----+----+----+----+----+----+----+----+----+----+
 6 |4   |20  |59  |43  |48  |92  |98  |6   |52  |27  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |25  |82  |71  |78  |30  |84  |26  |31  |14  |8   |
  +----+----+----+----+----+----+----+----+----+----+
 8 |65  |54  |45  |17  |36  |11  |18  |94  |40  |9   |
  +----+----+----+----+----+----+----+----+----+----+
 9 |33  |76  |12  |77  |62  |47  |61  |64  |24  |87  |
  +----+----+----+----+----+----+----+----+----+----+
10 |35  |-2  |67  |89  |1   |34  |79  |23  |51  |22  |
  +----+----+----+----+----+----+----+----+----+----+
|                      PLAY RESULTS                      | 
                                                       
  Player: 2 (COMPUTER)                                       
  Points made in the play: 99                            
  Number of Analyzed nodes: 6299                           
 Number of Cuts: 1277                                   
 Execution Time: 1022 ms                               
    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |NIL |96  |42  |32  |5   |90  |2   |86  |10  |74  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |29  |NIL |60  |85  |46  |53  |70  |49  |38  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |15  |-1  |69  |80  |63  |58  |66  |93  |75  |57  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |91  |0   |7   |50  |41  |13  |68  |NIL |72  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 5 |81  |19  |56  |21  |39  |95  |16  |83  |97  |3   |
  +----+----+----+----+----+----+----+----+----+----+
 6 |4   |20  |59  |43  |48  |92  |98  |6   |52  |27  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |25  |82  |71  |78  |30  |84  |26  |31  |14  |8   |
  +----+----+----+----+----+----+----+----+----+----+
 8 |65  |54  |45  |17  |36  |11  |18  |94  |40  |9   |
  +----+----+----+----+----+----+----+----+----+----+
 9 |33  |76  |12  |77  |62  |47  |61  |64  |24  |87  |
  +----+----+----+----+----+----+----+----+----+----+
10 |35  |-2  |67  |89  |1   |34  |79  |23  |51  |22  |
  +----+----+----+----+----+----+----+----+----+----+
|                      PLAY RESULTS                      | 
                                                       
  Player: 1 (HUMAN)                                       
  Points made in the play: 73                            
  Number of Analyzed nodes: node NODES ANALYZED                           
 Number of Cuts: N/A                                  
 Execution Time: N/A ms                             
    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |NIL |96  |42  |32  |5   |90  |2   |86  |10  |74  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |29  |NIL |60  |85  |46  |53  |70  |49  |38  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |15  |-1  |69  |80  |63  |58  |NIL |93  |75  |57  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |91  |0   |7   |50  |41  |13  |68  |NIL |72  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 5 |81  |19  |56  |21  |39  |95  |16  |83  |97  |3   |
  +----+----+----+----+----+----+----+----+----+----+
 6 |4   |20  |59  |43  |48  |92  |98  |6   |52  |27  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |25  |82  |71  |78  |30  |84  |26  |31  |14  |8   |
  +----+----+----+----+----+----+----+----+----+----+
 8 |65  |54  |45  |17  |36  |11  |18  |94  |40  |9   |
  +----+----+----+----+----+----+----+----+----+----+
 9 |33  |76  |12  |-2  |62  |47  |61  |64  |24  |87  |
  +----+----+----+----+----+----+----+----+----+----+
10 |35  |NIL |67  |89  |1   |34  |79  |23  |51  |22  |
  +----+----+----+----+----+----+----+----+----+----+
|                      PLAY RESULTS                      | 
                                                       
  Player: 2 (COMPUTER)                                       
  Points made in the play: 77                            
  Number of Analyzed nodes: 5743                           
 Number of Cuts: 1359                                   
 Execution Time: 1018 ms                               
    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |NIL |96  |42  |32  |NIL |90  |2   |86  |10  |74  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |29  |NIL |60  |85  |46  |53  |70  |49  |38  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |15  |NIL |69  |80  |63  |58  |NIL |93  |75  |57  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |91  |0   |7   |-1  |41  |13  |68  |NIL |72  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 5 |81  |19  |56  |21  |39  |95  |16  |83  |97  |3   |
  +----+----+----+----+----+----+----+----+----+----+
 6 |4   |20  |59  |43  |48  |92  |98  |6   |52  |27  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |25  |82  |71  |78  |30  |84  |26  |31  |14  |8   |
  +----+----+----+----+----+----+----+----+----+----+
 8 |65  |54  |45  |17  |36  |11  |18  |94  |40  |9   |
  +----+----+----+----+----+----+----+----+----+----+
 9 |33  |76  |12  |-2  |62  |47  |61  |64  |24  |87  |
  +----+----+----+----+----+----+----+----+----+----+
10 |35  |NIL |67  |89  |1   |34  |79  |23  |51  |22  |
  +----+----+----+----+----+----+----+----+----+----+
|                      PLAY RESULTS                      | 
                                                       
  Player: 1 (HUMAN)                                       
  Points made in the play: 50                            
  Number of Analyzed nodes: node NODES ANALYZED                           
 Number of Cuts: N/A                                  
 Execution Time: N/A ms                             
    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |NIL |96  |42  |32  |NIL |90  |2   |86  |10  |74  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |29  |NIL |60  |85  |46  |53  |70  |49  |38  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |15  |NIL |69  |80  |63  |58  |NIL |93  |75  |57  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |91  |0   |7   |-1  |41  |13  |68  |NIL |72  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 5 |81  |19  |56  |21  |39  |95  |16  |83  |97  |3   |
  +----+----+----+----+----+----+----+----+----+----+
 6 |4   |20  |59  |43  |48  |92  |98  |6   |52  |27  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |25  |82  |-2  |78  |30  |84  |26  |31  |14  |8   |
  +----+----+----+----+----+----+----+----+----+----+
 8 |65  |54  |45  |NIL |36  |11  |18  |94  |40  |9   |
  +----+----+----+----+----+----+----+----+----+----+
 9 |33  |76  |12  |NIL |62  |47  |61  |64  |24  |87  |
  +----+----+----+----+----+----+----+----+----+----+
10 |35  |NIL |67  |89  |1   |34  |79  |23  |51  |22  |
  +----+----+----+----+----+----+----+----+----+----+
|                      PLAY RESULTS                      | 
                                                       
  Player: 2 (COMPUTER)                                       
  Points made in the play: 71                            
  Number of Analyzed nodes: 5169                           
 Number of Cuts: 1359                                   
 Execution Time: 1017 ms                               
```

# 6.3 Computador vs Computador

```lisp
 A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |43  |83  |71  |39  |90  |19  |-1  |25  |91  |85  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |14  |40  |59  |74  |53  |64  |3   |52  |93  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |42  |18  |6   |32  |51  |62  |37  |79  |81  |58  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |78  |22  |12  |30  |96  |80  |5   |20  |1   |7   |
  +----+----+----+----+----+----+----+----+----+----+
 5 |69  |15  |48  |49  |87  |60  |24  |36  |76  |47  |
  +----+----+----+----+----+----+----+----+----+----+
 6 |29  |38  |56  |61  |35  |16  |21  |26  |70  |82  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |55  |84  |NIL |86  |65  |8   |46  |50  |92  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 8 |97  |88  |17  |27  |31  |66  |94  |67  |13  |23  |
  +----+----+----+----+----+----+----+----+----+----+
 9 |75  |9   |45  |57  |4   |33  |99  |73  |41  |10  |
  +----+----+----+----+----+----+----+----+----+----+
10 |63  |68  |95  |72  |77  |54  |0   |34  |11  |2   |
  +----+----+----+----+----+----+----+----+----+----+
                                                     
|                      PLAY RESULTS                      | 
|  Player: 1 (COMPUTER)                                       |
|  Points made in the play: 98                           | 
|  Number of Analyzed nodes: 5958                          | 
| Number of Cuts: 1258                                     |
| Execution Time: 1019 ms                                  |
  +--------------------------------------------------------+
                                                     
                                                     
    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |43  |83  |71  |39  |90  |19  |-1  |25  |91  |85  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |14  |40  |NIL |74  |53  |64  |3   |52  |93  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |42  |18  |6   |32  |51  |62  |37  |79  |81  |58  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |78  |22  |12  |30  |96  |80  |5   |20  |1   |7   |
  +----+----+----+----+----+----+----+----+----+----+
 5 |69  |15  |48  |49  |87  |60  |24  |36  |76  |47  |
  +----+----+----+----+----+----+----+----+----+----+
 6 |29  |38  |56  |61  |35  |16  |21  |26  |70  |82  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |55  |84  |NIL |86  |65  |8   |46  |50  |92  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 8 |97  |88  |17  |27  |31  |66  |94  |67  |13  |23  |
  +----+----+----+----+----+----+----+----+----+----+
 9 |75  |9   |45  |57  |4   |33  |99  |73  |41  |10  |
  +----+----+----+----+----+----+----+----+----+----+
10 |63  |68  |-2  |72  |77  |54  |0   |34  |11  |2   |
  +----+----+----+----+----+----+----+----+----+----+
                                                     
|                      PLAY RESULTS                      | 
|  Player: 2 (COMPUTER)                                       |
|  Points made in the play: 95                           | 
|  Number of Analyzed nodes: 6369                          | 
| Number of Cuts: 1573                                     |
| Execution Time: 1016 ms                                  |
  +--------------------------------------------------------+
                                                     
                                                     
    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |43  |83  |71  |NIL |90  |19  |NIL |25  |91  |85  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |14  |40  |NIL |74  |53  |64  |3   |52  |-1  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |42  |18  |6   |32  |51  |62  |37  |79  |81  |58  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |78  |22  |12  |30  |96  |80  |5   |20  |1   |7   |
  +----+----+----+----+----+----+----+----+----+----+
 5 |69  |15  |48  |49  |87  |60  |24  |36  |76  |47  |
  +----+----+----+----+----+----+----+----+----+----+
 6 |29  |38  |56  |61  |35  |16  |21  |26  |70  |82  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |55  |84  |NIL |86  |65  |8   |46  |50  |92  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 8 |97  |88  |17  |27  |31  |66  |94  |67  |13  |23  |
  +----+----+----+----+----+----+----+----+----+----+
 9 |75  |9   |45  |57  |4   |33  |99  |73  |41  |10  |
  +----+----+----+----+----+----+----+----+----+----+
10 |63  |68  |-2  |72  |77  |54  |0   |34  |11  |2   |
  +----+----+----+----+----+----+----+----+----+----+
                                                     
|                      PLAY RESULTS                      | 
|  Player: 1 (COMPUTER)                                       |
|  Points made in the play: 93                           | 
|  Number of Analyzed nodes: 5978                          | 
| Number of Cuts: 1261                                     |
| Execution Time: 1020 ms                                  |
  +--------------------------------------------------------+
                                                     
                                                     
    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |43  |83  |71  |NIL |90  |19  |NIL |25  |91  |85  |
  +----+----+----+----+----+----+----+----+----+----+
 2 |14  |40  |NIL |74  |53  |64  |3   |52  |-1  |28  |
  +----+----+----+----+----+----+----+----+----+----+
 3 |42  |18  |6   |32  |51  |62  |37  |79  |81  |58  |
  +----+----+----+----+----+----+----+----+----+----+
 4 |78  |22  |12  |30  |96  |80  |5   |20  |1   |7   |
  +----+----+----+----+----+----+----+----+----+----+
 5 |69  |15  |48  |49  |87  |60  |24  |36  |76  |47  |
  +----+----+----+----+----+----+----+----+----+----+
 6 |29  |38  |56  |61  |35  |16  |21  |26  |70  |82  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |55  |84  |NIL |86  |65  |8   |46  |50  |92  |44  |
  +----+----+----+----+----+----+----+----+----+----+
 8 |97  |-2  |17  |27  |31  |66  |94  |67  |13  |23  |
  +----+----+----+----+----+----+----+----+----+----+
 9 |75  |9   |45  |57  |4   |33  |NIL |73  |41  |10  |
  +----+----+----+----+----+----+----+----+----+----+
10 |63  |68  |NIL |72  |77  |54  |0   |34  |11  |2   |
  +----+----+----+----+----+----+----+----+----+----+
                                                     
|                      PLAY RESULTS                      | 
|  Player: 2 (COMPUTER)                                       |
|  Points made in the play: 88                           | 
|  Number of Analyzed nodes: 5723                          | 
| Number of Cuts: 1573                                     |
| Execution Time: 1014 ms                                  |
  +--------------------------------------------------------+
```

# 7. Limitações Técnicas

* Menu não aparece novamente no fim. Temos que selecionar a opção escrevendo na consola (1,2,3,q).

* A indrodução do programa (barras a carregar sequencialmente) pode atrasar a execução do emsmo o que se poderá tornar chat de executar várias vezes.

* Linguagem Inglesa, nem todos os utilizadores podem saber falar inglês. No entanto o grupo optou por escolher pois trata-se da linguagem universal.