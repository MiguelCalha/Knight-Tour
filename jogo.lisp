; Projeto nº2 Inteligência Artifical 23/24 - Jogo do Cavalo
; Prof. Joaquim Filipe, Eng. Filipe Mariano
; Miguel Calha - 201902037
; João Dâmaso - 201901629 
; Marcos Jesus - 201900268 


(defvar *play*)
(defvar *white-horse*)
(defvar *black-horse*)



#|
_________________________________________________ Game Functions _________________________________________________
|# 

; Função para colocar o cavalo no tabuleiro
(defun set-knight (board player)
  (cond
   ((null (player-position board player))
    (cond
     ((= player -1)
      (format t "~%Choose a position in the first row to place your Knight (A1 to J1): "))
     (t
      (format t "~%Choose a position in the last row to place your Knight (A10 to J10): ")))
    (let* ((coordinate (convert-str-to-coordinate))
           (new-board (choose-player-position coordinate board player)))
      (cond
       ((null new-board)
        (format t "~%Invalid Option!") 
        (set-knight board player))
       (t
        (setq *play* new-board)))))
   (t nil)))




(defun human-vs-computer()
  (let* ((first-player (get-starting-player)) (time (get-ex-time)) 
         (format (get-gameplay-type)) (board (create-rnd-board))
         (player (if(equal first-player 'human) -1 -2)))
    (progn
      (cond
       ((equal first-player 'human) 
        (progn
          (showBoard board)
          (set-knight board player)
          (metrics-header)
          (computer-moves *play* time (switch-player player))
          ))
       (T (progn
            (metrics-header)
            (computer-moves board time (switch-player player))
            (set-knight *play* player)
            ))
       )
      (cond
       ((equal first-player 'human)
        (human-vs-computer-aux time format -1))
       (T (human-vs-computer-aux time format -2))
       )))
  )

(defun human-vs-computer-aux (time format first-player)
  (let* ((play-computer-first (cond ((= first-player -2)
                                     (computer-moves *play* time (switch-player first-player)))))
         (operator (play-decision format first-player))
         (human-play (human-play first-player operator))
         (play-pc-segundo (cond ((= first-player -1)
                                 (computer-moves *play* time (switch-player first-player))))))
    (cond ((and (null human-play) (null play-computer-first) (null play-pc-segundo))
           (game-over-prompt 'human-computer first-player))
          (t (human-vs-computer-aux time format first-player)))))



(defun human-play (player operator)
  (cond
    ((or (null *play*) (null player) (null operator)) nil)

    ((null (player-position *play* player))
     (node-state (put-player (build-node *play* nil) player)))

    (t (let* ((successor (new-successor (build-node *play* nil) operator player))
              (points (abs (node-f successor))))
         (setq *play* (node-state successor))
         (showBoard *play*)
         (cond
           ((= player -1)
            (setq *player1* (+ points *player1*))
            (format t "~&White Knight [Human] Move: ~d points scored.~%" points))
           ((= player -2)
            (setq *player2* (+ points *player2*))
            (format t "~&Black Knight [Human] Move: ~d points scored.~%" points)))
         (write-metrics 'human player points)
         T))))




(defun computer-moves (state time player)
  (let* ((path (negamax (build-node state nil) time 'successors player))
         (new-node (get-play (car path)))
         (new-state (node-state new-node))
         (stats (second path)))
    (cond 
      ((not new-state) nil)
      (t
       (setq *play* new-state)
       (showBoard *play*)
       (let ((points (abs (node-f new-node))))
         (cond 
           ((= player -1)
            (format t "~&White Knight's move (Negamax): ~d points scored.~%" points)
            (setq *player1* (+ points *player1*)))
           (t
            (format t "~&Black Knight's move (Negamax): ~d points scored.~%" points)
            (setq *player2* (+ points *player2*))))
         (format t "~&Game Statistics:~%")
         (format t "  - Nodes Analyzed: ~d~%" (first stats))
         (format t "  - Branches Cut: ~d~%"   (second stats))
         (format t "  - Execution Time: ~d~%" (third stats))
         (write-metrics 'computer player points stats)
         T)))))



(defun play-decision (format first-player)
  (if (equal format 'coordinate)
      (move-to-coordinates first-player)
      (read-possible-moves *play* first-player)))


(defun game-over-prompt(tipo-jogo &optional first-player)
  (game-over-menu)
  (progn
    (format t "~% Points by White Kngiht : ~d" *player1*)
    (format t "~% Points by Black Knight : ~d" *player2*)

    (write-metrics-aux tipo-jogo first-player)
    )
)




#|
_________________________________________________Computer Vs Computer _________________________________________________
|# 

(defun computer-vs-computer()
  (let ((time (get-ex-time))
        (board (create-rnd-board)))
    (metrics-header)
    (computer-moves board time -1)
    (computer-moves *play* time -2)
    (computer-computerAux time)))


(defun computer-computerAux(time-limite)
  (let ((play1 (computer-moves *play* time-limite -1))
        (play2 (computer-moves *play* time-limite -2)))
    (cond
     ((and (null play1) (null play2)) (game-over-prompt 'pc-pc))
     (T (computer-computerAux time-limite)))))


#|
_________________________________________________Selectors _________________________________________________
|# 

(defun line (index board)
  (loop for item in board for idx from 0
        when (= idx index) return item))

(defun cell (x y board)
  (let ((target-line (line x board)))
    (line y target-line)))

(defun line-index (line value &optional (index 0))
  (when line
    (if (= (car line) value)
        index
        (line-index (cdr line) value (1+ index)))))

(defun best-value-house (line &optional (best-value nil))
  (loop for item in line
        when (and item (or (null best-value) (> item best-value)))
        do (setf best-value item)
        finally (return (line-index line best-value))))


#|
_________________________________________________Board Settings _________________________________________________
|# 

; Gera o format do board
(defun showBoard (board &optional (stream t))
  (format stream "~%    A    B    C    D    E    F    G    H    I    J")
  (format stream "~%  +----+----+----+----+----+----+----+----+----+----+")
  (showBoard-aux board stream))

(defun showBoard-aux (board &optional (stream t) (index 1))
  (when board
    (format stream "~%~2d |" index)
    (mapcar (lambda (cell)
              (format stream "~4A|" (if (null cell) "NIL" cell))) ; Writes "NIL" if the cell is empty
            (car board))
    (format stream "~%") ; This ensures we go to a new line after printing a row.
    (format stream "  +----+----+----+----+----+----+----+----+----+----+") ; Draw the row separator.
    (showBoard-aux (cdr board) stream (1+ index))))



;format number
(defun format-number(&optional (n 100))
  (cond
   ((< n 0) nil)
   ((equal n 1) ( cons (- n 1) NIL))
   (T (cons (- n 1) (format-number (- n 1))))
   )
)

; shuffle-matrix
(defun shuffle-matrix (lista)
  (cond
   ((NULL lista) NIL)
   (T (let ((n (nth (random (length lista)) lista)))
        (cons n (shuffle-matrix (remove-predic #'(lambda (x) (= x n)) lista)))
        )
   )))

; creates a random board
(defun create-rnd-board (&optional (lista (shuffle-matrix (format-number))) (n 10))
  (cond
   ((null lista) nil)
   (t (cons (subseq lista 0 n) (create-rnd-board (subseq lista n) n)))
   ))


#|
_________________________________________________Positioning _________________________________________________
|# 

(defun replace-position(x lista &optional (value NIL))
  (cond
   ((NULL lista) NIL)
   ((equal x 0) (cons value (cdr lista)))
   (T (cons (car lista) (replace-position (- x 1) (cdr lista) value)))
   ))

; Substitui a posição xy pelo valor de value
(defun replace-xy(x y board &optional (value NIL))
  (cond 
   ((or (NULL board)) NIL)
   ((equal x 0) 
    (cons (replace-position y (car board) value) 
                               (replace-xy (- x 1) y (cdr board) value)))
   (T (cons (car board) (replace-xy (- x 1) y (cdr board) value)))
   ))

(defun get-position(x y board)
  (if (AND (>= x 0) 
           (<= x (1- (length board))) 
           (>= y 0) 
           (<= y (1- (length board))) 
           (NOT (NULL board)))
           (nth y (nth x board))
    NIL))

(defun get-line-value(value line &optional (y 0))
  (cond
   ((NULL line) NIL)
   ((equal value (car line)) y)
   (T (get-line-value value (cdr line) (1+ y)))
   )
)

(defun get-value(value board &optional (x 0))
  (let ((y (get-line-value value (car board))))
    (cond
     ((NULL board) NIL)
     ((NULL y) (get-value value (cdr board) (1+ x)))
     (T (cons x (cons y nil)))
     )
    )
)


; devolve a posição do cavalo se o mesmo esitver no tabuleiro
(defun player-position (board player)
  (if (null board)
      nil
      (if (null (find player (car board)))
          (player-position (cdr board) player)
          (list (- (length (car board)) (length board))
                (- (length (car board)) (length (member player (car board))))))))


; Coloca o cavalo na posição escolhida
(defun put-player (node player)
  (let* ((knight-position (player-position (node-state node) player))
         (line (if (= player -1) 0 (1- (length (node-state node)))))
         (knight-position-y (best-value-house (line line (node-state node))))
         (value-new-position (get-position line knight-position-y (node-state node))))
    (cond
     ((and (null knight-position)
           (not (null value-new-position))
           (or (not (equal player value-new-position))
               (not (equal (switch-player player) value-new-position))))
      (let* ((board1 (replace-xy line knight-position-y (node-state node) player)))
        (cond
         ((null (symmetric-check (cell line knight-position-y (node-state node)) board1))
          (build-node (replace-xy line knight-position-y (node-state node) player) node value-new-position))
         (t
          (let* ((symmetric (symmetric-check (cell line knight-position-y (node-state node)) board1)))
            (build-node (replace-xy (car symmetric) (cadr symmetric) board1 nil) node value-new-position))
          ))))
     (t (node-state node)))))



; Escolhe uma posição no tabuleiro com base no cavalo do jogador e das coordenadas
(defun choose-player-position(coordinates board player)
  (cond
   ((or (null coordinates) (null board) (null player)) nil)
   ((and (= player -1) (= 0 (first coordinates))) (replace-xy (first coordinates) (second coordinates) board -1))
   ((and (= player -2) (= (1- (length board)) (first coordinates))) (replace-xy (first coordinates) (second coordinates) board -2))
   (T nil)
   )
)



#|
_________________________________________________Game Rules Functions _________________________________________________
|# 
(defun number-to-list (n)
  (loop for c across (write-to-string n) collect (digit-char-p c)))

(defun highest-dupe-line (line &optional (max-dupe nil))
  (let ((number-list (number-to-list (car line))))
    (cond
     ((null line) max-dupe)
     ((null max-dupe)
      (if (and (not (equal t (car line))) (equal (car number-list) (cadr number-list)))
          (highest-dupe-line (cdr line) (car line))
          (highest-dupe-line (cdr line) max-dupe)))
     ((not (null max-dupe))
      (if (and (not (null (car line))) (not (equal t max-dupe))
               (equal (car number-list) (cadr number-list)) (< max-dupe (car line)))
          (highest-dupe-line (cdr line) (car line))
          (highest-dupe-line (cdr line) max-dupe)))
     (t (highest-dupe-line (cdr line) max-dupe)))))

(defun contains? (lista value)
  (cond
   ((null lista) nil)
   ((equal (car lista) value) t)
   (t (contains? (cdr lista) value))))

(defun highest-dupe (table &optional (max-dupe nil))
  (let ((max-line (highest-dupe-line (car table))))
    (cond 
     ((null table) max-dupe)
     ((null max-dupe)
      (if (and (not (null max-line)) (not (equal t max-line)))
          (highest-dupe (cdr table) max-line)
          (highest-dupe (cdr table) max-dupe)))
     ((not (null max-dupe))
      (if (and (not (null max-line)) (not (equal t max-dupe)) (< max-dupe max-line))
          (highest-dupe (cdr table) max-line)
          (highest-dupe (cdr table) max-dupe)))
     (t (highest-dupe (cdr table) max-dupe)))))

(defun reverse-list (l)
  (cond
   ((null l) '())
   (t (append (reverse-list (cdr l)) (list (car l))))))

(defun symmetric-check-line (n line &optional (y 0))
  (let* ((numero-lista (number-to-list n)) (car-line-lista (number-to-list (car line))))
    (cond
     ((null line) nil)
     ((equal 1 (length numero-lista))
      (if (equal (cons n (cons 0 nil)) car-line-lista)
          y
          (symmetric-check-line n (cdr line) (1+ y))))
     ((and (equal (car numero-lista) (car line)) (equal 0 (cadr numero-lista))) y)
     ((equal (reverse-list numero-lista) car-line-lista) y)
     (t (symmetric-check-line n (cdr line) (1+ y))))))

(defun symmetric-check (n board &optional (x 0))
  (let ((symmetric (symmetric-check-line n (car board))))
    (cond
     ((null board) nil)
     ((or (equal (car (number-to-list n)) (cadr (number-to-list n))) (equal n 0))
      (get-value (highest-dupe board) board))
     ((not (null symmetric)) (cons x (cons symmetric nil)))
     (t (symmetric-check n (cdr board) (1+ x))))))

(defun convert-str-to-coordinate ()
  (let* ((coordinate (format nil "~S" (read))))
    (list (1- (parse-integer (subseq coordinate 1 (length coordinate)))) (- (char-code (char coordinate 0)) 65))))

(defun remove-predic (pred lista)
  (cond
   ((null lista) nil)
   ((funcall pred (car lista)) (remove-predic pred (cdr lista)))
   (t (cons (car lista) (remove-predic pred (cdr lista))))))

#|
_________________________________________________Operators _________________________________________________
|# 

;Determina o operador para mover para uma certa coordenada
(defun operator-to-coordinate (coordinate board player)

  (let ((knight-position (player-position board player))
        (line (first coordinate))
        (column (second coordinate)))
    (cond
     ((null knight-position) nil)
     (t (let ((delta-x (- line (car knight-position)))
              (delta-y (- column (cadr knight-position))))
          (cond
           ((and (= 2 delta-x) (= -1 delta-y)) 'operator-1)
           ((and (= 2 delta-x) (= 1 delta-y)) 'operator-2)
           ((and (= 1 delta-x) (= 2 delta-y)) 'operator-3)
           ((and (= -1 delta-x) (= 2 delta-y)) 'operator-4)
           ((and (= -2 delta-x) (= 1 delta-y)) 'operator-5)
           ((and (= -2 delta-x) (= -1 delta-y)) 'operator-6)
           ((and (= -1 delta-x) (= -2 delta-y)) 'operator-7)
           ((and (= 1 delta-x) (= -2 delta-y)) 'operator-8)
           (t nil)
           )))))

)

;; Esta função gera uma lista de movimentos possíveis para o jogador especificado no tabuleiro.
(defun possible-moves (board operators player)

  (labels ((valid-move? (operator)
             (let ((new-board (funcall operator board player)))
               (and new-board (not (equal new-board board)))))
           (filter-valid-operators (ops)
             (cond
              ((null ops) nil)
              ((valid-move? (car ops))
               (cons (car ops) (filter-valid-operators (cdr ops))))
              (t (filter-valid-operators (cdr ops))))))
    (filter-valid-operators operators)))


(defun operators()
  (list 'operator-1 'operator-2 'operator-3 'operator-4 'operator-5 'operator-6 'operator-7 'operator-8))


;; Esta função calcula o novo tabuleiro após aplicar o operador especificado.
(defun operator-aux (inc-x inc-y board player)

  (let* ((knight-position (player-position board player))
         (new-x (+ (car knight-position) inc-x))
         (new-y (+ (cadr knight-position) inc-y))
         (new-position (get-position new-x new-y board)))
    (cond
     ((or (null new-position) (equal player new-position) (equal (switch-player player) new-position)) nil)
     (t
      (let* ((board1 (replace-xy (car knight-position) (cadr knight-position) board nil))
             (board2 (replace-xy new-x new-y board1 player))
             (symmetric (symmetric-check (cell new-x new-y board) board2)))
        (cond
         ((null symmetric) board2)
         (t (replace-xy (car symmetric) (cadr symmetric) board2 nil))
         ))))))


; Esta função solicita coordenadas ao utilizador e converte para operador.
(defun move-to-coordinates (player)
  (format t "~%Insert the coordinates where you want to move your Knight (ex: B1): ")
  (let ((coordinates (convert-str-to-coordinate)))
    (if (null coordinates)
        (progn
          (format t "~%Invalid Coordinates! The move you are choosing is impossible!")
          (move-to-coordinates player))
        (operator-to-coordinate coordinates *play* -1))))




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



#|
_________________________________________________Data Structure _________________________________________________
|# 
(defun position-value(node successor player)
  (let ((knight-position (player-position successor player)))
    (if (null knight-position)
        nil
        (if (= player -1)
            (get-position (car knight-position) (cadr knight-position) (node-state node))
            (* -1 (get-position (car knight-position) (cadr knight-position) (node-state node)))
            )
        )
    ))

(defun new-successor(node op player)
  (let* ((successor (build-node (funcall op (node-state node) player) node))
         (value (position-value node (node-state successor) player)))
    (if (or (null node) (null successor) (null value))
        nil
        (build-node (node-state successor) node value)
        )
    )
  )

(defun successors(node &optional (player -1) (operators (operators)))
  (if (or (null node) (null operators))
      nil
      (if (null (player-position (node-state node) player))
          (list (put-player node player))
          (remove-predic #'(lambda (x) (null x))
                         (mapcar #'(lambda (op) (new-successor node op player)) operators)
                         )
          )
      )
  )

(defun build-node (board father &optional (f 0))
  (list board father f))

(defun create-solution-node (node analyzed-nodes prunn-numbers initial-time)
  (list node (list analyzed-nodes prunn-numbers (- (get-internal-real-time) initial-time))))

(defun node-state (node)
  (car node))

(defun father-node (node)
  (cadr node))

(defun node-f (node)
  (caddr node))

(defun node-exists-p (node lista-node)
  (member node lista-node))

(defun node-depth (node)
  (cond
   ((null (father-node node)) 0)
   (t (1+ (node-depth (father-node node))))))

(defun best-f (a b)
  (if (> (node-f a) (node-f b))
      a
      b))

(defun get-play (node &optional node-child)
  (if (null (father-node node))
      node-child
      (get-play (father-node node) node)))

#|
_________________________________________________Metrics _________________________________________________
|# 

(defun file-path ()
  (make-pathname :directory '(:absolute "Users" "duart" "Desktop")
                 :name "log"
                 :type "dat"))




(defun write-metrics(tipo-player player points &optional stats)
  (progn
    (with-open-file (file (file-path) :direction :output :if-exists :append :if-does-not-exist :create)
      (progn
        (showBoard *play* file)
        (format file "~%                                                     ")
        (format file "~%+--------------------------------------------------------+")
        (format file "~%|                      PLAY RESULTS                      | ")
        (format file "~%+--------------------------------------------------------+")
        (format file "~%|  Player: ~d (~s)                                       |" (if (= player -1) 1 2) tipo-player)
        (format file "~%|  Points made in the play: ~d                           | " points)
        (if (equal tipo-player 'computer)
        (format file "~%|  Number of Analyzed nodes: ~d                          | " (first stats))
        (format file "~%|  Number of Analyzed nodes: node NODES ANALYZED         |                  "))
        (if (equal tipo-player 'computer)
        (format file "~%| Number of Cuts: ~d                                     |" (second stats))
        (format file "~%| Number of Cuts: N/A                                    |"))
        (if (equal tipo-player 'computer)
        (format file "~%| Execution Time: ~d ms                                  |" (third stats))
          (format file "~%| Execution Time: N/A ms                               |"))
      (format file "~%  +--------------------------------------------------------+")
      (format file "~%                                                     ")
      (format file "~%                                                     ")
        ))
    )
  )


(defun write-metrics-aux(tipo-jogo first-player)
  (with-open-file (file (file-path) :direction :output :if-exists :append :if-does-not-exist :create)
    (progn
        (format file "~%                                                     ")
        (format file "~%+--------------------------------------------------------+")
        (format file "~%|                      GAME RESULTS                      | ")
        (format file "~%+--------------------------------------------------------+")
      (if (equal tipo-jogo 'pc-pc)
       (format file"~%  | Computer VS Computer                                   |")
       (format file"~%  | Human VS Computer                                      |"))
      (format file "~%  |                                                        |")
      (format file "~%  |                                                        |")
      (if (equal tipo-jogo 'human-computer) 
          (if (equal first-player -1)
          (format file "| First Player: Human                                    |")
          (format file "| First Player Computer                                  |")))
      (format file "~%  | White Knight points: ~d                                |" *player1*)
      (format file "~%  | Black Knight points: ~d                                |" *player2*)
      (format file "~%  +--------------------------------------------------------+")
      (format file "~%                                                     ")
      (format file "~%                                                     ")
      ))
  )