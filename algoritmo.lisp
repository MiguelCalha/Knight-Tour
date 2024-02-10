; Projeto nº2 Inteligência Artifical 23/24 - Jogo do Cavalo
; Prof. Joaquim Filipe, Eng. Filipe Mariano
; Miguel Calha - 201902037
; João Dâmaso - 201901629 
; Marcos Jesus - 201900268 

(defvar *memo-table* (make-hash-table :test 'equal))
(defvar *memo-table-max-size* 10000) ; Ajustar tamanho ( baseado na memória disponível)

#|
_________________________________________________Negamax Algorithm _________________________________________________
|# 

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
      (if (>= new-alpha beta)  
          (create-solution-node parent-node (nth 0 (cadr first-solution)) (1+ (nth 1 (cadr first-solution))) start-time)
        (negamax-recursive-search node parent-node (cdr successors) time-limit successor-fn player depth new-alpha beta 
                                  start-time (nth 0 (cadr first-solution)) (nth 1 (cadr first-solution)))
        )
      )
    )
   ))




(defun memoized-negamax (node time-limit f-successors &optional (player -1) (prof 50) 
                         (alfa most-negative-fixnum) (beta most-positive-fixnum) 
                         (initial-time (get-internal-real-time)) (generated-nodes 0) (cuts 0))
  (let ((key (list node player prof alfa beta)))
    (or (gethash key *memo-table*)
        (let ((resultado (negamax node time-limit f-successors player prof alfa beta initial-time generated-nodes cuts)))
          (when (< (hash-table-count *memo-table*) *memo-table-max-size*)
            (setf (gethash key *memo-table*) resultado))
          resultado))))

#|
_________________________________________________Algorithm (Auxiliar Functions) _________________________________________________
|# 


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

(defun switch-player(player)
  (if(equal player -1) -2 -1)
)

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


(defun get-all-moves (board player)
  (let ((operators '(operator-1 operator-2 operator-3 operator-4
                                operator-5 operator-6 operator-7 operator-8)))
    (remove-if-not 
      (lambda (op) (contains? (possible-moves board operators player) op))
      operators)))

 ;; Generate successors for states where the player has 2 or fewer moves
(defun quiescent-successors (board player)
  (let ((successors '())
        (moves (get-all-moves board player)))
    (dolist (op moves)
      (let ((new-board (funcall op board player)))
        (when (and new-board (<= (length (get-all-moves new-board player)) 2))
          (push new-board successors))))
    successors))
#|
_________________________________________________Evaluation Function _________________________________________________
|# 

(defun calculate-current-score (board player)
  ;; Calcula a pontuação baseada na posição atual do cavalo.
  (let ((knight-position (player-position board player)))
    (if knight-position
        (let ((score (get-position (first knight-position) (second knight-position) board)))
          (if score
              (abs score) ;; Assumindo que a pontuação é o valor absoluto na posição.
              0))
        0)))

(defun calculate-average-mobility (board player)
  ;; Calcula a média de mobilidade para movimentos futuros.
  (let ((moves (get-all-moves board player)))
    (if (> (length moves) 0)
        (/ (reduce #'+ (mapcar (lambda (move) (length (get-all-moves (funcall move board player) player))) moves))
           (length moves))
        0)))


(defvar *state-history* (make-hash-table :test 'equal))

(defun calculate-repetition-penalty (board player)
  ;; Penaliza estados que foram visitados frequentemente.
  (let ((state-key (list board player)))
    (let ((visits (gethash state-key *state-history*)))
      (if visits
          (progn
            (setf (gethash state-key *state-history*) (1+ visits))
            (* -1 visits)) ;; Penalidade aumenta com o número de visitas.
          (progn
            (setf (gethash state-key *state-history*) 1)
            0))))) ;; Nenhuma penalidade para a primeira visita.


; Incentiva a procura a favorcer estados com pontuações mais altas
; Favorece estados que o cavalo tem mais opções de movimento
; Movimentos que levam a estados com mais opções futuras são favorecidos
; Evitar repetições do cavalo ficar a mover-se em loop infinito
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



