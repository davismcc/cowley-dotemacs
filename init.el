;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Davis's emacs configuration file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;
;; Define load-path
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/auto-complete-1.3.1/")
(let ((default-directory "~/.emacs.d/"))
  (normal-top-level-add-subdirs-to-load-path))

;;;;;;;;
;; Use sexy solarized theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")
(add-to-list 'custom-theme-load-path "/home/davismcc/.emacs.d/themes/emacs-color-theme-solarized")
(load-theme 'solarized-light t)

;; ===== Turn off tab character =====
;;
;; Emacs normally uses both tabs and spaces to indent lines. If you
;; prefer, all indentation can be made from spaces only. To request this,
;; set `indent-tabs-mode' to `nil'. This is a per-buffer variable;
;; altering the variable affects only the current buffer, but it can be
;; disabled for all buffers.
;;
;; Use (setq ...) to set value locally to a buffer
;; Use (setq-default ...) to set value globally 
;;
(setq-default indent-tabs-mode nil) 


;; ===== Turn on Auto Fill mode automatically in all modes =====
;; Auto-fill-mode the the automatic wrapping of lines and insertion of
;; newlines when the cursor goes over the column limit.
;; This should actually turn on auto-fill-mode by default in all major
;; modes. The other way to do this is to turn on the fill for specific modes
;; via hooks.
(setq auto-fill-mode 1)

;; ===== Neat function for better showing matching parentheses =====
(defadvice show-paren-function (after show-matching-paren-offscreen
                                      activate)
  "If the matching paren is offscreen, show the matching line in the                               
echo area. Has no effect if the character before point is not of                                   
the syntax class ')'."
  (interactive)
  (let ((matching-text nil))
    ;; Only call `blink-matching-open' if the character before point                               
    ;; is a close parentheses type character. Otherwise, there's not                               
    ;; really any point, and `blink-matching-open' would just echo                                 
    ;; "Mismatched parentheses", which gets really annoying.                                       
    (if (char-equal (char-syntax (char-before (point))) ?\))
        (setq matching-text (blink-matching-open)))
    (if (not (null matching-text))
        (message matching-text))))

;;;;;;;
;; Set up ESS
(require 'ess-site)

;;;;;;;;
;; Use auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)
;; To use auto-complete with python-mode, just prepend the following lines:
(require 'auto-complete-config)
(ac-config-default)
(ac-flyspell-workaround)

;;;;;;;;
;; Use yasnippets
(add-to-list 'load-path 
	     "~/.emacs.d/plugins/yasnippet")
(add-to-list 'load-path 
	     "/home/davismcc/.emacs.d/plugins/yasnippet")
(require 'yasnippet) ;; not yasnippet-bundle
(yas-global-mode 1)
(yas--initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet/snippets")
;(require 'yasnippet-bundle) ;; yasnippet-bundle

(require 'auto-complete)
(require 'yasnippet)

(defun ac-yasnippet-candidate ()
  (let ((table (yas/get-snippet-tables major-mode)))
    (if table
      (let (candidates (list))
            (mapcar (lambda (mode)          
              (maphash (lambda (key value)    
                (push key candidates))          
              (yas/snippet-table-hash mode))) 
            table)
        (all-completions ac-prefix candidates)))))

(defface ac-yasnippet-candidate-face
  '((t (:background "sandybrown" :foreground "black")))
  "Face for yasnippet candidate.")

(defface ac-yasnippet-selection-face
  '((t (:background "coral3" :foreground "white"))) 
  "Face for the yasnippet selected candidate.")

(defvar ac-source-yasnippet
  '((candidates . ac-yasnippet-candidate)
    (action . yas/expand)
    (limit . 3)
    (candidate-face . ac-yasnippet-candidate-face)
    (selection-face . ac-yasnippet-selection-face)) 
  "Source for Yasnippet.")

(provide 'auto-complete-yasnippet)

;;;;;;;;
;; Load python-mode
(setq py-install-directory "~/.emacs.d/python-mode")
(add-to-list 'load-path py-install-directory)
(require 'python-mode)
;; To enable code completion
(setq py-load-pymacs-p t)


;;;;;;;;
;; Use R-autoyas for snippets for R coding with ESS
;(require 'r-autoyas)
;(add hook 'ess-mode-hook 'r-autoyas-ess-activate)

;;;;;;;;
;; Rope and ropemacs
;;  (setq pymacs-load-path '("/Users/davismcc/Software/python/rope-0.9.4"
;;			  "/Users/davismcc/Software/python/ropemacs-0.7"))
;; Function for lazy loading of ropemacs
(defun load-pymode ()
  "Load python programming mode from init_python.el"
    (interactive)
					;(require 'pymacs)
					;(pymacs-load "ropemacs" "rope-")
    ;; Load the python initialisation script in ~/.emacs.d/init_python.el
    (load-library "init_python") 
    ;; Automatically save project python buffers before refactorings
    (setq ropemacs-confirm-saving 'nil)
    )
(global-set-key "\C-xpl" 'load-ropemacs)
;; And execute ``load-ropemacs`` (or use ``C-x p l``) whenever you want to use ropemacs.






