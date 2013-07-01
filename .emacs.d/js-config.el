;; -------------------------------
;; -- JS editing and node REPL ---
;; -------------------------------

(require 'js-comint)
(defun whitespace-clean-and-compile ()
  (interactive)
  (whitespace-cleanup-all)
  (compile compile-command))

;; Configure jshint for JS style checking.
;;   - Install: $ npm install -g jshint
;;   - Usage: Hit C-cC-u within any emacs buffer visiting a .js file
(setq jshint-cli "jshint --show-non-errors ")
  (setq compilation-error-regexp-alist-alist
	(cons '(jshint-cli "^\\([a-zA-Z\.0-9_/-]+\\): line \\([0-9]+\\), col \\([0-9]+\\)"
		1 ;; file
		2 ;; line
		3 ;; column
		)
	      compilation-error-regexp-alist-alist))
(setq compilation-error-regexp-alist
      (cons 'jshint-cli compilation-error-regexp-alist))

(add-hook 'js-mode-hook '(lambda ()
                           (local-set-key "\C-x\C-e" 'eval-last-sexp)
                           (local-set-key "\C-cb" 'js-send-buffer)
                           (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
                           (local-set-key "\C-cl" 'js-load-file-and-go)
                           (local-set-key "\C-c!" 'run-js)
                           (local-set-key "\C-c\C-r" 'js-send-region)
                           (local-set-key "\C-c\C-j" 'js-send-line)
                           (set (make-local-variable 'compile-command) 
                                (let ((file buffer-file-name)) (concat jshint-cli file)))
                           (set (make-local-variable 'compilation-read-command) nil)
                           (local-set-key "\C-c\C-u" 'whitespace-clean-and-compile)
                           ))

(defun node-repl-comint-preoutput-filter (output)
  "This function fixes the escape issue with node-repl in js-comint.el.
  Heavily adapted from http://www.squidoo.com/emacs-comint (which
  is in emacs/misc/comint_ticker)

  Basically, by adding this preoutput filter to the
  comint-preoutput-filter-functions list we take the output of
  comint in a *js* buffer and do a find/replace to replace the
  ANSI escape noise with a reasonable prompt.
"
(if (equal (buffer-name) "*js*")
    (progn
      ;; Uncomment these to debug the IO of the node process
      ;; (setq js-node-output output)
      ;; (message (concat "\n----------\n" output "\n----------\n"))

      ;; Replaced ^ with \^ to indicate that doesn't have to be
      ;; at start of line
      (replace-regexp-in-string
       "\\\[0K" ""
       (replace-regexp-in-string
        "\\\[1G" ""
       (replace-regexp-in-string
        "\\\[0J" ""
       (replace-regexp-in-string
        "\\\[3G" ""
       (replace-regexp-in-string
        "\\\[0G" ""
       (replace-regexp-in-string
        "\\[2C" ""
       (replace-regexp-in-string
        "\\[0K" ""
        (replace-regexp-in-string
         "" "" output))))))))
      )
    output
  )
)

(add-hook 'comint-preoutput-filter-functions 'node-repl-comint-preoutput-filter)
(add-hook 'comint-output-filter-functions 'node-repl-comint-preoutput-filter)
