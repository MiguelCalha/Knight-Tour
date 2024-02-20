
# Jogo do Cavalo (Knight's Tour)

# Indíce 

* 1- Introdução
* 2- Algoritmo
* 3- Funções Auxiliares ao Algoritmo
* 4- Operadores
* 5- Descrição de tipos abstratos de dados
* 6- Análise Estatística (Computador vs Humano)
* 7- Análise Estatística (Computador vs Computador)
* 8- Limitações técnicas



# 1. Introdução

O Jogo do Cavalo é uma variante do problema matemático conhecido como o Passeio do Cavalo, cujo
objetivo é, através dos movimentos do cavalo, visitar todas as casas de um tabuleiro similar ao de xadrez. Esta
versão decorrerá num tabuleiro de 10 linhas e 10 colunas (10x10), em que cada casa possui uma pontuação. (Enunciado Projeto Ep. Normal pag. 1)

O jogo termina quando não for possível movimentar qualquer um dos cavalos no tabuleiro, sendo o vencedor
o jogador que ganhou mais pontos.
O jogo é composto por dois cavalos: Branco e Preto.

No âmbito do projeto nº2 de Inteligência Artficial de época normal, foi proposto aos alunos o projeto do Jogo do cavalo num tabuleiro 10x10 (10 linhas e 10 colunas). Com jogadas humanas e do computador.

O objetivo deste jogo é separado por duas vertentes:
* Humano vs Computador
* Computador vs Computador 

## 1.1 Características do Knight Tour:

### Jogo de 2 adversários: 

* Caracteriza-se por ser um jogo com dois adversários, onde o MAX joga contra o MIN;

### Jogo simétrico

 * Cada jogador tem a opção de aplicar a sua estratégia específica;

### Jogo sequencial:

 * Como o Player 1 ou Player 2 poderá ter conehcimento da jogada do antecessor, pode ser necessário realizar uma jogada que condiciona o antecessor a não poder efetuar a jogada que queria; 

### Jogo de soma nula, não cooperativo

* Ambiente competitivo onde cada jogador está a tentar maximizar os seus próprios ganhos (ou minimizar as suas próprias perdas) à custa do outro jogador.

###  Jogo com explosão combinatória

* Jogo que tem um crescimento exponencial do número de possíveis configurações ou soluções num problema à media que a sua complexidade aumenta.


# 2. Algoritmo (algoritmo.lisp)

O Negamax é uma simplificação do algoritmo Minimax, utilizada principalmente em jogos de tabuleiro de dois jogadores, como xadrez ou damas. A ideia principal do Negamax é que o valor de utilidade de uma posição para um jogador é o negativo do valor para o outro jogador. O que permite que o mesmo código seja usado para avaliar posições de ambos os jogadores, simplificando a implementação.

A função negamax é chamada com um estado inicial do jogo (nó) e outros parâmetros relevantes.
Ela avalia o estado atual e, se for um estado terminal ou se o limite de tempo/ profundidade for atingido, retorna uma avaliação.
Se não for um estado terminal, a função gera sucessores do estado atual e aplica a procura Negamax recursivamente a esses sucessores.
A poda alpha-beta é usada para cortar ramos da árvore de busca que não precisam ser explorados, pois não levarão a uma solução melhor para o jogador atual.
A memoização é usada para armazenar resultados de cálculos já realizados, o que aumenta a eficiência, especialmente em jogos com muitos estados repetidos.

### 2.1 **Negamax**
```lisp
(defun negamax (node time-limit successor-fn &optional (player -1) (depth 50) 
                   (alpha most-negative-fixnum) (beta most-positive-fixnum) 
                   (start-time (get-internal-real-time)) (nodes-generated 0) (prunes 0))
  (let ((next-nodes (if (= depth 0)
                        (quiescent-successors node)  ; Calls quiescent successors at depth 0
                        (order-negamax-suc (funcall successor-fn node player) player))))
    (cond
     ((or (= depth 0) (null next-nodes) (>= (- (get-internal-real-time) start-time) time-limit))
      (if (= depth 0)
          (quiescent-search node alpha beta)  ; Performs quiescent search at depth 0
          (create-solution-node node nodes-generated prunes start-time)))
     (T (negamax-recursive-search node node next-nodes time-limit successor-fn player depth alpha beta start-time nodes-generated prunes))
     )
    ))

```

### 2.2 **Negamax Recursive Search**

Nesta função auxiliar ao algoritmo principal é onde ocorrem os cortes.
No ínicio da função negamax os parâmetros 'alpha' e 'beta' são definidos e inicializados com o valor mais negativo e o valor mais positivo.


```lisp
(defun negamax-recursive-search (node parent-node successors time-limit successor-fn player depth
                                     alpha beta start-time nodes-generated prunes)
  (cond
   ((equal (length successors) 1) 
    (memoized-negamax (car successors) time-limit successor-fn (switch-player player) 
                      (1- depth) (- alpha) (- beta) start-time (1+ nodes-generated) prunes))
   (T
    (let*  ((first-solution (memoized-negamax (car successors) time-limit successor-fn (switch-player player) 
                                             (1- depth) (- alpha) (- beta) start-time (1+ nodes-generated) prunes))
            (first-node (car first-solution))
            (optimal-value (best-f first-node parent-node))
            (new-alpha (max alpha (node-f optimal-value))))
      (if (>= new-alpha beta) ; Pruning
          (create-solution-node parent-node (nth 0 (cadr first-solution)) (1+ (nth 1 (cadr first-solution))) start-time)
        (negamax-recursive-search node parent-node (cdr successors) time-limit successor-fn player depth new-alpha beta 
                                  start-time (nth 0 (cadr first-solution)) (nth 1 (cadr first-solution)))
        )
      )
    )
   ))


```


# 3. Funções Auxiliares ao Algoritmo (algoritmo.lisp)

A memoização serve para armazenar resultados de procuras anteriores e evitar cálculos repetidos.
Foi implementada uma tabela de hash para armazenar resultados de procuras anteriores e também foi definido o tamanho máximo para essa tabela (1000).

### 3.1 **Memoized Negamax**
```lisp
(defun memoized-negamax (node time-limit f-successors &optional (player -1) (prof 50) 
                         (alfa most-negative-fixnum) (beta most-positive-fixnum) 
                         (initial-time (get-internal-real-time)) (generated-nodes 0) (cuts 0))
  (let ((key (list node player prof alfa beta)))
    (or (gethash key *memo-table*)
        (let ((resultado (negamax node time-limit f-successors player prof alfa beta initial-time generated-nodes cuts)))
          (when (< (hash-table-count *memo-table*) *memo-table-max-size*)
            (setf (gethash key *memo-table*) resultado))
          resultado))))
```

### 3.2 **order-negamax-suc**

Esta função filtra nos nós e ordena-os com o algoritmo quick-sort de forma a otimizar o algoritmo.

```lisp


;ordenar nós com o quick sort
(defun order-negamax-suc (node-list player)
  (cond 
   ((null node-list) nil)
   ((= player -1) 
    (append
     (order-negamax-suc (quick-sort< (node-f (car node-list)) (cdr node-list)) player)
     (cons (car node-list) nil)
     (order-negamax-suc (quick-sort>= (node-f (car node-list)) (cdr node-list)) player)
     ))
   (T 
    (append
     (order-negamax-suc (quick-sort>= (node-f (car node-list)) (cdr node-list)) player)
     (cons (car node-list) nil)
     (order-negamax-suc (quick-sort< (node-f (car node-list)) (cdr node-list)) player)
     ))
   )
  )

```


### 3.3 **QuickSort**

Função Quicksort para ordenação de nós.

```lisp
;Quick Sort para valores menores que N
(defun quick-sort< (N node-list)
  (cond
   ((or (null N) (null node-list)) nil)
   ((< N (node-f (car node-list))) (quick-sort< N (cdr node-list)))
   (T (cons (car node-list) (quick-sort< N (cdr node-list))))
   )
  )

;Quick Sort para valores maiores ou iguais que N
(defun quick-sort>= (N node-list)
  (cond
   ((or (null N) (null node-list)) nil)
   ((>= N (node-f (car node-list))) (quick-sort>= N (cdr node-list)))
   (T (cons (car node-list) (quick-sort>= N (cdr node-list))))
   )
  )

```

### 3.4 **Procura Quiescente**

A quiescent-search é uma busca especializada que é aplicada em estados do jogo que são considerados "quiescentes", ou seja, relativamente estáveis.
Esta função avalia esses estados de jogo para evitar avaliações erróneas que podem ocorrer em pontos críticos do jogo, como quando há uma ameaça de captura ou outras situações de alto impacto.

* A função recebe um estado do jogo (node), e os valores alfa e beta para a poda alpha-beta.
* Calcula uma avaliação básica do estado (value-estatico).
* Se essa avaliação básica é suficientemente boa (maior ou igual a beta), ela retorna esse valor.
* Caso contrário, explora sucessores quiescentes (através de quiescent-successors) para encontrar um valor mais preciso, atualizando os limites alfa e beta conforme necessário.

```lisp

;Executa a procura quiescente para evitar avaliações erróneas node fim da busca."
(defun quiescent-search (node alfa beta)
  (let ((value-estatico (evaluate-state (node-state node))))
    (if (>= value-estatico beta)
      beta
      (let ((alfa-atual (max alfa value-estatico)))
        (dolist (s (quiescent-successors node) alfa-atual)
          (let ((value (- (quiescent-search s (- beta) (- alfa-atual)))))
            (if (>= value beta)
              (return beta)
              (setf alfa-atual (max alfa-atual value)))))))))


```


### 3.5 **Procura Quiescente (função auxiliar)**

Utilizada para identificar estados importantes e críticos. Centra-se em movimentos que não causam grandes alterações, mas são estrategicamente importantes. Esta função ajuda a quiescent-search a realizar uma avaliação mais precisa do estado do jogo.

* Recebe o estado atual do tabuleiro (board) e o jogador atual (player).
* Utiliza a função get-all-moves para identificar movimentos possíveis.
* Filtra esses movimentos para incluir apenas aqueles que resultam em estados quiescentes (por exemplo, estados onde o jogador tem poucas opções de movimento).

```lisp

(defun quiescent-successors (board player)
  (let ((successors '())
        (moves (get-all-moves board player)))
    (dolist (op moves)
      (let ((new-board (funcall op board player)))
        (when (and new-board (<= (length (get-all-moves new-board player)) 2))
          (push new-board successors))))
    successors))


```




### 3.6 Função de Avaliação (algoritmo.lisp)

A função de avaliação definida, avalia o estado do jogo e segue as seguintes normas:

* Incentiva a procura a favorecer estados com pontuações mais altas;
* Favorece estados que o cavalo tem mais opções de movimento;
* Movimentos que levam a estados com mais opções futuras são favorecidos;
* Evita repetições para que o cavalo não fique em Loop sempre na mesma casa;

```lisp

(defun evaluate-state (node player)
  (let* ((current-score (calculate-current-score (node-state node) player))
         (mobility (length (get-all-moves (node-state node) player)))
         (average-mobility (calculate-average-mobility (node-state node) player))
         (repetition-penalty (calculate-repetition-penalty (node-state node) player))
         (current-score-weight 1.0)
         (mobility-weight 0.5)
         (average-mobility-weight 0.3)
         (repetition-penalty-weight -0.2))
    (+ (* current-score-weight current-score)
       (* mobility-weight mobility)
       (* average-mobility-weight average-mobility)
       (* repetition-penalty-weight repetition-penalty))))


```


# 4. Operadores (jogo.lisp)

De forma geral, os operadores consistem em todos os movimentos possíveis (alterações diretas de estado).

Para este segundo projeto os alunos tiveram uma reformulação completa da maneira como o movimento do cavalo funciona. Dado que a abordagem anterior contemplava apenas a definição de duas fuções de operadores que verificavam dentro delas os movimentos possíveis para uma dada situação. 

Como essa abordagem não é muito funcional, optou-se por se definr todos os movimentos possíveis de um cavalo no tabuleiro e utilizar estas funções para efetuar os movimentos.


### 4.1 Operadores do jogo
```lisp
; Movimento do cavalo duas casas para cima e uma para a esquerda
(defun operator-1(board player) (operator-aux 2 -1 board player))

; Movimento do cavalo duas casas para cima e uma para a direita
(defun operator-2(board player) (operator-aux 2 1 board player))

; Movimento do cavalo uma casa para cima e duas para a direita
(defun operator-3(board player) (operator-aux 1 2 board player))

; Movimento do cavalo uma casa para baixo e duas para a direita
(defun operator-4(board player) (operator-aux -1 2 board player))

; Movimento do cavalo duas casas para baixo e uma para a direita
(defun operator-5(board player) (operator-aux -2 1 board player))

; Movimento do cavalo duas casas para baixo e uma para a esquerda
(defun operator-6(board player) (operator-aux -2 -1 board player))

; Movimento do cavalo uma casa para baixo e duas para a esquerda
(defun operator-7(board player) (operator-aux -1 -2 board player))

; Movimento do cavalo uma casa para cima e duas para a esquerda
(defun operator-8(board player) (operator-aux 1 -2 board player))
)
```

# 5. Descrição de tipos abstratos de dados

Existem diversos tipos abstratos de dados utilizados no jogo para representar e manipular diferentes aspetos do jogo.

* 1. Listas: Permitem a representação flexível de estruturas como tabuleiros e sequ~encias de movimentos, com operações fáceis de adição, remoção e acesso;

* 2. Tabelas Hash: Permitem o acesso rápido e eficiente aos dados, o que é crucial para a memoização no algoritmo Negamax;

* 3. Árvores: Servem para representar as possibilidades de jogadas e escolhas estratégicas no jogo;

* 4. Pares e Tuples: São formas simples e eficazes de agrupar dados relacionados sem criar estuturas complexas;
esentação de jogadores ('human, 'computer) e operadores (como 'operator-1)

* 5. Átomos e Símbolos: Utilizados para representar os jogadores, escolhas do menu e outros elementos não numéricos.


# 6. Análise Estatística (Computador vs Humano)

### 6.1 Tabuleiro Inicial (Computador vs Humano)

Podemos verificar o tabuleiro para este caso teste.

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

   ```


### 6.3. **Tabela de Resultados - Computador vs Humano**
Os resultados deste jogo podem ser consultados no ficheiro log.dat presente nesta pasta.
Em baixo temos todas as jogadas efetuadas pelo computador neste jogo contra um humano.


 | Jogada | Número de cortes | Nós Gerados| Pontos efetuados | Tempo Limite | Tempo de Execução |
| --- | :---: | :---: | :---: | :---: | :---: |
| 1º | 1277 | 6299   | 99 | 1 segundo | 1022 ms | 
| 2º | 1359 | 5743   | 77 | 1 segundo | 1018 ms | 
| 3º | 1359 | 5169   | 71 | 1 segundo | 1017 ms | 
| 4º | 1360 | 5368   | 76 | 1 segundo | 1015 ms | 
| 5º | 1347 | 5788   | 89 | 1 segundo | 1011 ms | 
| 6º | 1768 | 6166   | 47 | 1 segundo | 1006 ms | 
| 7º | 1483 | 5631   | 94 | 1 segundo | 1006 ms | 
| 8º | 13   | 56       | 87 | 1 segundo | 12 ms | 
| 9º | 1277 | 6643   | 23 | 1 segundo | 1022 ms | 
| 10º | 1315 | 5702  | 40 | 1 segundo | 1006 ms | 
| 11º | 1598 | 6255  | 61 | 1 segundo | 1001 ms | 
| 12º | 1073 | 3889  | 51 | 1 segundo | 630 ms | 
| 13º | 82 | 253  | 9 | 1 segundo | 43 ms | 
| 14º | 111 | 382  | 64 | 1 segundo | 61 ms |
| 15º | 110 | 380  | 34 | 1 segundo | 60 ms |
| 16º | 2 | 8  | 36 | 1 segundo | 1 ms |
| 17º | 1 | 5  | 12 | 1 segundo | 1 ms |
| 18º | 0 | 3  | 82 | 1 segundo | 0 ms |
| 19º | 0 | 1  | 59 | 1 segundo | 0 ms |

  * White Knight points: 830                              
  * Black Knight points: 1281 

### Tabuleiro Final (Computador vs Humano)
   ```lisp

    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |NIL |NIL |42  |NIL |NIL |NIL |2   |86  |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 2 |NIL |NIL |60  |85  |NIL |NIL |NIL |NIL |38  |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 3 |NIL |NIL |NIL |NIL |NIL |58  |NIL |NIL |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 4 |NIL |NIL |NIL |NIL |41  |NIL |68  |NIL |72  |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 5 |NIL |-1  |56  |NIL |NIL |NIL |NIL |83  |NIL |3   |
  +----+----+----+----+----+----+----+----+----+----+
 6 |NIL |20  |NIL |NIL |NIL |NIL |NIL |6   |NIL |27  |
  +----+----+----+----+----+----+----+----+----+----+
 7 |NIL |NIL |NIL |NIL |30  |NIL |NIL |NIL |14  |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 8 |65  |NIL |NIL |NIL |NIL |11  |NIL |NIL |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 9 |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |24  |NIL |
  +----+----+----+----+----+----+----+----+----+----+
10 |-2  |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+

  ```

### 6.4 Estatísticas Descritivas (Computador vs Humano)

####  Número de cortes:
*  Média: 817.63
*  Desvio Padrão: 695.54
*  Mínimo: 0
*  Máximo: 1768

O valor médio de cortes é significativamente menor do que o máximo, indicando que algumas jogadas tiveram um número muito maior de cortes.


#### Nós Gerados:
* Média: 3354.79
* Desvio Padrão: 2875.51
* Mínimo: 1
* Máximo: 6643

A média de nós gerados é significativamente alta, mas há uma grande variação indicada pelo desvio padrão.

#### Pontos Efetuados:
* Média: 58.47
* Desvio Padrão: 27.43
* Mínimo: 9
* Máximo: 99

Os pontos efetuados também variam bastante, com alguns jogos tendo pontuações muito altas e outros muito baixas.

#### Tempo de Execução (ms):
* Média: 575.37 ms
* Desvio Padrão: 492.52 ms
* Mínimo: 0 ms
* Máximo: 1022 ms

A execução do tempo varia significativamente, com alguns jogos sendo processados quase que imediatamente e outros aproximando-se do limite de tempo.

### 6.5 Análise Geral (Computador vs Humano)

* O número médio de cortes (817.63) sugere que o algoritmo de poda está ativo e é eficaz a cortar ramos subótimos da árvore de busca. No entanto, o desvio padrão elevado (695.54) junto com a diferença significativa entre o mínimo (0) e o máximo (1768) indica uma grande inconsistência no número de cortes entre diferentes jogos. Isso pode ser devido à natureza do espaço da procura ou à variabilidade na qualidade dos movimentos do jogador humano.

* A média de nós gerados (3354.79) indica que o algoritmo explora um número significativo de possíveis movimentos durante o jogo. O desvio padrão alto (2875.51) e a diferença entre o mínimo (1) e o máximo (6643) sugerem uma grande variabilidade no número de nós gerados em diferentes jogos. A alta variação no número de nós gerados sugere que alguns jogos são consideravelmente mais complexos ou envolvem mais tomadas de decisão do que outros. 

* A média de pontos efetuados (58.47) com um desvio padrão de 27.43 indica uma variabilidade considerável na pontuação entre os jogos. A gama de pontos (de 9 a 99) sugere que há jogos em que o jogador humano ou o computador performam excepcionalmente bem ou mal. A ampla gama de pontuações sugere que o jogo pode ser altamente imprevisível e possivelmente influenciado por movimentos estratégicos cruciais em determinados pontos. 

* O tempo médio de execução de 575.37 ms, com um desvio padrão de 492.52 ms, mostra que, embora a maioria dos jogos são processados em menos de um segundo, há uma variação significativa no tempo de processamento. A diferença entre o mínimo (0 ms) e o máximo (1022 ms) destaca essa variação. O tempo de execução pode variar com base na complexidade do estado do jogo e na profundidade da árvore. Enquanto a maioria dos jogos é processada rapidamente, alguns exigem tempo substancialmente maior. 


# 7. Análise Estatística (Computador vs Computador)

### 7.1 Tabuleiro Inicial (Computador vs Computador)

Podemos verificar o tabuleiro para este caso teste.

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

   ```

### 7.2. **Tabela de Resultados - Computador vs Computador**
Os resultados deste jogo podem ser consultados no ficheiro log.dat presente nesta pasta.
Em baixo temos todas as jogadas efetuadas pelo computador neste jogo contra um humano.


 | Player | Número de cortes | Nós Gerados| Pontos efetuados | Tempo Limite | Tempo de Execução |
| --- | :---: | :---: | :---: | :---: | :---: |
| Player 1 | 1258 | 5958   | 98 | 1 segundo | 1019 ms | 
| Player 2 | 1573 | 6369   | 95 | 1 segundo | 1016 ms | 
| Player 1 | 1261 | 5978   | 93 | 1 segundo | 1020 ms | 
| Player 2 | 1573 | 5723   | 88 | 1 segundo | 1014 ms | 
| Player 1 | 1494 | 4794   | 37 | 1 segundo | 1017 ms | 
| Player 2 | 1302 | 5986   | 86 | 1 segundo | 1011 ms | 
| Player 1 | 1616 | 5777   | 96 | 1 segundo | 1014 ms | 
| Player 2 | 1221 | 5759   | 87 | 1 segundo | 1021 ms | 
| Player 1 | 1303 | 5079   | 74 | 1 segundo | 1010 ms | 
| Player 2 | 1438 | 5829   | 62 | 1 segundo | 1011 ms | 
| Player 1 | 922 | 5703   | 83 | 1 segundo | 1008 ms | 
| Player 2 | 1347 | 5025   | 90 | 1 segundo | 1008 ms | 
| Player 1 | 1387 | 6148   | 42 | 1 segundo | 1006 ms | 
| Player 2 | 1407 | 4628   | 32 | 1 segundo | 1009 ms | 
| Player 1 | 1276 | 5611   | 15 | 1 segundo | 1005 ms | 
| Player 2 | 1480 | 5206   | 80 | 1 segundo | 1003 ms | 
| Player 1 | 1552 | 5457   | 61 | 1 segundo | 1004 ms | 
| Player 2 | 1450 | 5681   | 79 | 1 segundo | 1008 ms | 
| Player 1 | 1562 | 5863   | 84 | 1 segundo | 1003 ms | 
| Player 2 | 1271 | 5795   | 91 | 1 segundo | 1003 ms | 
| Player 1 | 1559 | 5607   | 75 | 1 segundo | 1005 ms | 
| Player 2 | 1400 | 5622   | 58 | 1 segundo | 1004 ms | 
| Player 1 | 598 | 2554   | 17 | 1 segundo | 428 ms | 
| Player 2 | 1411 | 5596   | 76 | 1 segundo | 1003 ms | 
| Player 1 | 98 | 444   | 72 | 1 segundo | 68 ms | 
| Player 2 | 29 | 155   | 50 | 1 segundo | 25 ms | 
| Player 1 | 216 | 1041   | 33 | 1 segundo | 178 ms | 
| Player 2 | 202 | 865   | 82 | 1 segundo | 149 ms | 
| Player 1 | 3 | 63   | 65 | 1 segundo | 8 ms |
| Player 2 | 32 | 188   | 36 | 1 segundo | 27 ms |
| Player 1 | 4 | 21   | 94 | 1 segundo | 3 ms |
| Player 2 | 4 | 106   | 92 | 1 segundo | 14 ms |
| Player 1 | 5 | 24   | 54 | 1 segundo | 3 ms |
| Player 2 | 6 | 39   | 21 | 1 segundo | 6 ms |
| Player 1 | 2 | 31   | 31 | 1 segundo | 2 ms |
| Player 2 | 6 | 33   | 66 | 1 segundo | 4 ms |
| Player 1 | 4 | 12   | 46 | 1 segundo | 2 ms |
| Player 2 | 2 | 13   | 35 | 1 segundo | 1 ms |
| Player 1 | 1 | 12   | 70 | 1 segundo | 2 ms |
| Player 2 | 0 | 6   | 30 | 1 segundo | 1 ms |
| Player 1 | 1 | 4   | 20 | 1 segundo | 1 ms |
| Player 2 | 0 | 4   | 60 | 1 segundo | 0 ms |


* White Knight points: 1260                               
* Black Knight points: 1396


### Tabuleiro Final (Computador vs Computador)
   ```lisp

    A    B    C    D    E    F    G    H    I    J
  +----+----+----+----+----+----+----+----+----+----+
 1 |43  |NIL |NIL |NIL |NIL |NIL |NIL |25  |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 2 |14  |40  |NIL |NIL |NIL |NIL |NIL |52  |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 3 |NIL |18  |NIL |NIL |NIL |NIL |NIL |NIL |81  |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 4 |NIL |22  |NIL |NIL |NIL |NIL |NIL |-1  |1   |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 5 |NIL |NIL |NIL |NIL |NIL |-2  |NIL |NIL |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 6 |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 7 |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |44  |
  +----+----+----+----+----+----+----+----+----+----+
 8 |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |NIL |
  +----+----+----+----+----+----+----+----+----+----+
 9 |NIL |NIL |NIL |NIL |4   |NIL |NIL |NIL |41  |10  |
  +----+----+----+----+----+----+----+----+----+----+
10 |NIL |NIL |NIL |NIL |NIL |NIL |0   |34  |11  |NIL |
  +----+----+----+----+----+----+----+----+----+----+

  ```

### 7.3 Estatísticas Descritivas (Computador vs Computador)

### 7.3.1, Player 1:

#### Número de Cortes

* Média: 806.05
* Desvio Padrão: 681.12

#### Nós Gerados:
* Média: 3308.45
* Desvio Padrão: 2711.35

#### Pontos Efetuados:
* Média: 59.5
* Desvio Padrão: 27.91

#### Tempo de Execução:
* Média: 590.20 ms
* Desvio Padrão: 485.39 ms


### 7.3.2. Player 2:

#### Número de Cortes:
* Média: 857.7
* Desvio Padrão: 695.31

#### Nós Gerados:
* Média: 3431.1
* Desvio Padrão: 2755.04

#### Pontos Efetuados:
* Média: 68.3
* Desvio Padrão: 23.02

#### Tempo de Execução:
* Média: 616.85 ms
* Desvio Padrão: 494.02 ms


### 7.4 Análise Geral (Computador vs Computador)

* Ambos os jogadores mostram um padrão semelhante nas estatísticas. O número de cortes e nós gerados tem uma correlação muito forte com o tempo de execução, o que é esperado, pois quanto mais complexa a jogada (mais cortes e nós), mais tempo o algoritmo leva para processar essa jogada.

* Os pontos efetuados, enquanto variáveis importantes do ponto de vista do jogo, não mostram uma correlação tão forte com a complexidade das jogadas ou com o tempo de execução quanto as outras métricas. Isso sugere que a capacidade do computador de marcar pontos não está diretamente relacionada à complexidade computacional das jogadas.

* A variabilidade nos dados (indicada pelo desvio padrão) é bastante alta em todas as métricas, o que indica que há uma grande dispersão nos resultados das jogadas, tanto em termos de complexidade quanto de eficácia (pontos efetuados).

* Interessantemente, o Player 2 tende a ter médias um pouco mais altas em cortes, nós gerados e pontos efetuados, mas também leva mais tempo, em média, para concluir as jogadas. Isso pode indicar que o Player 2 está a assumir estratégias ligeiramente mais complexas ou arriscadas que resultam numa maior pontuação mas também requerem mais cálculos.

## 8. Limitações técnicas


O nosso jogo  apresenta algumas limitações técnicas, sendo as principais:


 * Memória Heap: Se não for definido um limite de memória a ser utilizada pela memoização, a mesma vai guardar demasiados valores que faz com que o LispWorks feche inesperadamente.

 * Opção de modo de jogo por coordenada (A10): Apesar do nosso jogo implementar este formato de inserção de coordenadas, optamos por não definir o mesmo como uma escolha para o utilizador jogar. Sendo apenas utilizado para definir a posição inicial no tabuleiro.


