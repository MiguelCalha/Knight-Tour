; Projeto n�2 Intelig�ncia Artifical 23/24 - Jogo do Cavalo
; Prof. Joaquim Filipe, Eng. Filipe Mariano
; Miguel Calha - 201902037
; Jo�o D�maso - 201901629 
; Marcos Jesus - 201900268 

; Alterar conforme o ambiente
(defun current-directory ()
  (let ((path "C:\\Users\\duart\\Desktop\\Projeto2IA\\"))
    path
  )
)

#|
_________________________________________________ Input Functions _________________________________________________
|#
; Fun��o para come�ar o Jogo
(defun start()
  (load (compile-file (concatenate 'string (current-directory)      "jogo.lisp")))
  (load (compile-file (concatenate 'string (current-directory)      "algoritmo.lisp")))
  (intro)
  (setq *player1* 0)
  (setq *player2* 0)
  (loop
    (let ((opt (read)))
      (cond 
       ((eq opt 4) (format t "Goodbye, Player!") (return))
       ((or (not (numberp opt)) (> opt 3) (< opt 1)) 
        (format t "Choose a valid option.~%"))
       (t
        (case opt
          (1 (human-vs-computer))
          (2 (computer-vs-computer))
          (3 (op-info-menu))))))))



(defun get-starting-player()
  (progn 
    (choose-fp-menu)
    (let ((opt (read-line)))
      (cond 
       ((string= opt "q") (format t "Au revoir Player!!~%"))
       ((or (string= opt "1") (string= opt "2")) ; Check if the input is "1" OR "2"
        (ecase (parse-integer opt) ; Parse the option as an integer and use it in ecase
          (1 'human)
          (2 'computer)))
       (T (progn (format t "Choose a valid option.~%") (get-starting-player)))
       ))
    )
  )



(defun get-ex-time()
  (progn 
    (processing-time-menu)
    (let ((usr-input (read-line)))
      (cond 
       ((string= usr-input "q") (format t "au revoir Player!! "))
       ((or (not (numberp (parse-integer usr-input :junk-allowed t)))
            (< (parse-integer usr-input :junk-allowed t) 1)
            (> (parse-integer usr-input :junk-allowed t) 5))
        (progn 
          (format t "Choose Between 1 and 5 seconds")
          (format t "Insert the correct time again.")
          (get-ex-time)))
       (T (* (parse-integer usr-input :junk-allowed t) 1000))
       ))
    )
  )




(defun get-gameplay-type()
  (progn 
    (gameplay-style-menu)
    (let ((opt (read)))
      (cond 
       ((eq opt 'q) (format t "au revoir Player!!"))
       ((or (not (numberp opt)) (> opt 1)) 
        (progn (format t "Insert a valid option") (get-gameplay-type)))
       (T (ecase opt
            (1 'operator)
            (T (progn (format t "Invalid option. Choose again.") (get-gameplay-type)))
            ))
       ))
    ))



(defun read-possible-moves(board player)
  (cond
   ((null (possible-moves board (operators) player)) nil)
   (T 
    (progn
      (operator-menu board player)
      (format t "~%Which operator do you want to execute?: ")
      (let* ((opt (read)) (possibilities (possible-moves board (operators) player)))
        (cond
         ((and (= opt 1) (contains? possibilities 'operator-1)) 'operator-1)
         ((and (= opt 2) (contains? possibilities 'operator-2)) 'operator-2)
         ((and (= opt 3) (contains? possibilities 'operator-3)) 'operator-3)
         ((and (= opt 4) (contains? possibilities 'operator-4)) 'operator-4)
         ((and (= opt 5) (contains? possibilities 'operator-5)) 'operator-5)
         ((and (= opt 6) (contains? possibilities 'operator-6)) 'operator-6)
         ((and (= opt 7) (contains? possibilities 'operator-7)) 'operator-7)
         ((and (= opt 8) (contains? possibilities 'operator-8)) 'operator-8)
         (T (progn
              (format t "~%Invalid move!")
              (read-possible-moves board player)))
         ))))
   ))



#|
_________________________________________________ Menus _________________________________________________
|# 

(defun loadingBar()
  (format t "           ")
  (loop for x in '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _  )
        do (format t "~A" x) (SLEEP 0.030) )
  )

(defun loading()
  (format t "                         ")
  (loop for x in '(K N I G H T " " T O U R  )
        do (format t " ~A" x) (SLEEP 0.15) )
  )

(defun horse-intro ()
  (progn
    (format t "~%~%~%~%~%")
    (format t "                             ,....,                             ~%")
    (format t "                           ,:::::<<                            ~%")
    (format t "                          ,::/^\"``.                           ~%")
    (format t "                         ,::/, `   e`.                         ~%")
    (format t "                        ,::; |        '.                       ~%")
    (format t "                        ,::|  \\___,-.  c)                      ~%")
    (format t "                       ;::|     \\   '-'                      ~%")
    (format t "                        ;::|      \\                           ~%")
    (format t "                        ;::|   _.=`\\                          ~%")
    (format t "                        `;:|.=` _.=`\\                         ~%")
    (format t "                          '|_.=`   __\\                        ~%")
    (format t "                          `\\_..==`` /                         ~%")
    (format t "                           .'.___.-'.                         ~%")
    (format t "                          /          \\                        ~%")
    (format t "                         ('--......--')                        ~%")
    (format t "                         /'--......--'\\                       ~%")
    (format t "                         `\"--......--\"`                       ~%")
    (format t "~%~%~%~%~%")
  )	
)


(defun intro ()
(progn
    (format t "~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%"                                 )
    (loadingBar)
    (format t "~%           ______________________________________________________~%"    )
    (format t "~%                                                           ~%"          ) 
    (format t "~%                                                                 ~%~%"  )      
    (loading)
    (format t "~%                                                                 ~%"    ) 
    (format t "~%           ______________________________________________________~%"    ) 
    (loadingBar)
    (menu)
    )	

)

;;; Menus
(defun menu()
  (progn
  (format t "~%~%~%~%")
  (horse-intro)
    (format t "~%   +--------------------------------------------------------+")
    (format t "~%   �           Knight Tour   -  Welcome                     �")
    (format t "~%   �                                                        �")
    (format t "~%   �              1 - Play Human vs Computer                �")
    (format t "~%   �              2 - Play Computer vs Computer             �")
    (format t "~%   �              3 - Operator List                         �")
    (format t "~%   �              q - Quit                                  �")
    (format t "~%   �                                                        �")
    (format t "~%   +--------------------------------------------------------+~%> ")
    )
  )


(defun processing-time-menu()
  (progn
    (format t "~%   +--------------------------------------------------------+")
    (format t "~%   �           Knight Tour   -  Set Time                    �")
    (format t "~%   �       Time for Computer's play Processing              �")
    (format t "~%   �                                                        �")
    (format t "~%   �              1 - 1 second                              �")
    (format t "~%   �              2 - 2 seconds                             �")
    (format t "~%   �              3 - 3 seconds                             �")
    (format t "~%   �              4 - 4 seconds                             �")
    (format t "~%   �              5 - 5 seconds                             �")
    (format t "~%   �              q - Quit                                  �")
    (format t "~%   �                                                        �")
    (format t "~%   +--------------------------------------------------------+~%> ")
    )
  )



(defun choose-fp-menu()
 (progn
    (format t "~%   +--------------------------------------------------------+")
    (format t "~%   �             Knight Tour - Starting Player              �")
    (format t "~%   �                                                        �")
    (format t "~%   �              1 - Me                                    �")
    (format t "~%   �              2 - Computer                              �")
    (format t "~%   �              q - Quit                                  �")
    (format t "~%   �                                                        �")
    (format t "~%   +--------------------------------------------------------+~%> ")
    )
  )


(defun gameplay-style-menu()
 (progn
    (format t "~%   +--------------------------------------------------------+")
    (format t "~%   �           Knight Tour - Playing Format                 �")
    (format t "~%   �                                                        �")
    (format t "~%   �              1 - Operator                              �")
    (format t "~%   �              q - Quit                                  �")
    (format t "~%   �                                                        �")
    (format t "~%   +--------------------------------------------------------+~%> ")
    )
  )


(defun game-over-menu ()
(progn
    (format t "~%   +--------------------------------------------------------+")
    (format t "~%   �                         GAME OVER                      �")
    (format t "~%   �                                                        �")
    (format t "~%   +--------------------------------------------------------+~%> ")
))

(defun op-info-menu ()
(progn
    (format t "~%     +--------------------------------------------------------+")
    (format t "~%     �                         OPERATORS                      �")
    (format t "~%     �                                                        �")
    (format t "~%     �                OPERATOR1 - 2UP,     1LEFT              �")
    (format t "~%     �                OPERATOR2 - 2UP,     1RIGHT             �")
    (format t "~%     �                OPERATOR3 - 1UP,     2RIGHT             �")
    (format t "~%     �                OPERATOR4 - 1DOWN,   2RIGHT             �")
    (format t "~%     �                OPERATOR5 - 2DOWN,   1RIGHT             �")
    (format t "~%     �                OPERATOR6 - 2DOWN,   1LEFT              �")
    (format t "~%     �                OPERATOR-7 - 1DOWN,  2LEFT              �")
    (format t "~%     �                OPERATOR-8 - 1UP,    2LEFT              �")
    (format t "~%     +--------------------------------------------------------+~%> ")
))

(defun metrics-header()
  (progn
    (with-open-file (file (file-path) :direction :output :if-exists :append :if-does-not-exist :create)
      (progn
    (format t "~%   +--------------------------------------------------------+")
    (format t "~%   �                         GAME STARTED                   �")
    (format t "~%   �                                                        �")
    (format t "~%   +--------------------------------------------------------+~%> ")
        ))
    )
  )


;Menu de operadores que mostra os operadores disponiveis para a jogada
(defun operator-menu (board player)
  (let ((knight-pos (player-position board player)))
    (if (null knight-pos)
        (format t "The Knight is yet to be positioned")
        (display-possible-movements board knight-pos))))


;Fun��o auxiliar ao menu de operador 
(defun display-possible-movements (board knight-pos)
  (format t "    ~% ------------------------")
  (format t "    ~%|  Possible Moves        |")
  (dolist (offset '(((2 . -1) 1) ((2 . 1) 2) ((1 . 2) 3) ((-1 . 2) 4) 
                    ((-2 . 1) 5) ((-2 . -1) 6) ((-1 . -2) 7) ((1 . -2) 8)))
    (let* ((dx (caar offset))
           (dy (cdar offset))
           (op-num (cdr offset)))
      (when (get-position (+ (car knight-pos) dx) (+ (cadr knight-pos) dy) board)
        (format t "~%|     ~A- Operator-~A      |" op-num op-num))))
  (format t "    ~% ------------------------~%~%> "))



