;;; ess-r-args.el --- Insert R function's arguments

;; Copyright (C) 2007 Sven Hartenstein <mail at svenhartenstein dot de>
;; Copyright (C) 2007 A.J. Rossini, Richard M. Heiberger, Martin
;;      Maechler, Kurt Hornik, Rodney Sparapani, and Stephen Eglen.

;; This file is part of ESS

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; Last update: 2012-02-27

;;; Commentary:

;; == DOCUMENTATION ==

;; This file provides some functions that show or insert a
;; R-function's arguments (and their default values) by using R's
;; args() function. This code requires ESS (http://ess.r-project.org).
;; For screenshots as well as information on requirements,
;; installation, configuration and troubleshooting, please visit
;; http://www.svenhartenstein.de/emacs-ess.php

;; Users of XEmacs (or maybe non-GNU-Emacs users): The code below must
;; be slightly adapted in order to work in XEmacs (i.e. comment out
;; the delete-trailing-whitespace function call by putting a semicolon
;; at the beginning of the line). Furthermore, the tooltip option does
;; NOT work in XEmacs (yet) (and will probably only ever work if the
;; ESS-core team will adapt the code for XEmacs compatibility).

;; == Requirements ==

;; * ESS mode must be loaded and running.
;; * A R process must be running within ESS.
;; * For the tooltip option to work, Emacs must not run within a
;;   terminal but (directly) under the X window system (in case of
;;   GNU/Linux).
;; * The tooltip option currently requires GNU Emacs (i.e. not XEmacs
;;   or a similar other derivate).

;; == Installation ==

;; To make Emacs aware of the functions defined in this file load it
;; into Emacs by including something like the following in your
;; ~/.emacs file (adapt "/PATH/TO"!).
;;
;; (add-hook 'ess-mode-hook (lambda () (load "/PATH/TO/ess-r-args.el")))
;;
;; This file is included with ESS; if you are reading this file as
;; part of the ESS distribution, then you do not need to add the above
;; line.

;; == Configuration ==

;; Configuration should be done by setting some variables in your
;; ~/.emacs file, the following is an example only, adjust it to your
;; needs.

;; ;; ess-r-args-noargsmsg is printed, if no argument information
;; ;; could be found. You could set it to an empty string ("") for no
;; ;; message.
;; (setq ess-r-args-noargsmsg "No args found.")
;;
;; ;; ess-r-args-show-as determines how (where) the information is
;; ;; displayed. Set it to 'tooltip little tooltip windows or to
;; ;; 'message (the default) which will use the echo area at the bottom of
;; ;; your Emacs frame.
;; (setq ess-r-args-show-as nil)
;;
;; ;; ess-r-args-show-prefix is a string that is printed in front of
;; ;; the arguments list. The default is "ARGS: ".
;; (setq ess-r-args-show-prefix "ARGS: ")

;; == Usage ==

;; The functions should be called when point (text cursor) is between
;; two parentheses of a R function call (see screenshots above). It
;; will then (invisibly) query R for which arguments the respective
;; function knows as well as their default values and show or insert
;; the result.

;; There are currently two functions: ess-r-args-show echoes the
;; arguments in the echo area or as tooltip, ess-r-args-insert prints
;; the arguments at point.

;; In order to not having to type the whole function name each time
;; you want to see the arguments list, you most probably want to bind
;; the functions to a key which again should be done in your ~/.emacs
;; file. You can also let Emacs call the function each time you insert
;; an opening parenthesis ("(").

;; -----> do this below

;; Again, the following is an example only:

;; bind ess-r-args-show to F2
;; (define-key ess-mode-map [f2] 'ess-r-args-show)

;; bind ess-r-args-insert to F3
;; (define-key ess-mode-map [f3] 'ess-r-args-insert)

;; == Setting the tooltip position ==

;; Unfortunately (?), tooltips are by default shown at the mouse
;; pointer's position, which is not necessarily where you are looking
;; at. If you use Emacs' mouse-avoidance-mode with option "banish"
;; then the mouse pointer will automatically be put at the upper right
;; corner of the Emacs window so that you know where to look for the
;; tooltip. Emacs also allows for setting the tooltip position
;; relative to the upper left corner of your screen. If you know how
;; to let Emacs determine the point (text cursor) position in pixels
;; from the upper left corner of the screen, please let me know. It
;; would then be possible to show the tooltip near the point, which I
;; would consider preferably.
;; SJE: see code at bottom 2009-01-30...

;; ;; Put mouse away when using keyboard
;; (mouse-avoidance-mode 'banish)

;; ;; Set the tooltip position in absolute pixels from the upper left
;; ;; corner of the screen
;; (setq tooltip-frame-parameters
;;   '((name . "tooltip")
;;   (left . 20)
;;   (top . 20)))

;; == Changelog ==

;; * 2007-04-03: The function should now do nothing (instead of
;;   irritating cursor movement) if the current ESS process is
;;   anything but R.
;; * 2007-04-05: Function names changed. Much more modular. GPLed. New
;;   prefix configuration variable. Minor changes.
;; * 2007-04-30: Error handling added. Bugfix: Emacs used to lock up
;;   when function was called within parentheses following the "#"
;;   character (Thanks to John Bullock for his bug report!).

;; == Troubleshooting ==

;; Before sending reports of problems, please check the following.

;; * Doublecheck the requirements section above.
;; * Please be sure you tried both the "tooltip" option and the "echo
;;   area" option and tell me whether both failed or just one.
;; * Check whether it is a key binding problem. Run the function with
;;   M-x ess-r-args-show RET. If it works but not the key binding, try
;;   binding it to another key. Some window managers might not pass
;;   the function key keystrokes to Emacs.

;; If you encounter problems, please send me detailed bug reports.
;; Please also indicate the ESS version you are running and the Emacs
;; type (GNU vs. X) and operating system. I will do my best to help
;; but please be aware that I'm everything but an emacs lisp expert.

;; == TODO ==

;; These are things that I would like to see improved. Please let me
;; know if you know how it could be done.

;; * As mentioned above, I would like to place the tooltip near the
;;   point (text cursor) but I do not see how this could be done.
;; * Both the message in the echo area and the tooltip automatically
;;   disappear as soon as a key is pressed. That is, you will need to
;;   call the function again if you have entered the first
;;   parameter(s) and wonder what additional parameters are possible.
;;   I would prefer the information to be shown, say, five seconds or
;;   so.

;;; Code:

(eval-and-compile
  (require 'ess-custom))

(eval-when-compile
  (if ess-has-tooltip
      (require 'tooltip))); for tooltip-show

(require 'ess)

(defun ess-r-args-current-function ()
  "Returns the name of the R function assuming point is currently
within the argument list or nil if no possible function name is
found."
  (save-excursion
    (condition-case nil (up-list -1)
      (error (message "Can't find opening parenthesis.")))
    (let ((posend (point)))
      (backward-sexp 1)
      (let ((rfunname (buffer-substring-no-properties posend (point))))
        (if (posix-string-match "^[a-zA-Z0-9_\.]+$" rfunname)
            rfunname nil)))))

(defun ess-r-args-get (&optional function trim)
  "Returns string of arguments and their default values of R
function FUNCTION or nil if no possible function name
found. Calls ess-r-args-current-function if no argument given.
If TRIM is non-nill remove tabs and newlines and replace ' = '
with '=' (useful for display in minibuffer to avoid window and
buffer readjustments for multiline string)."
  (if (null function)
      (setq function (ess-r-args-current-function)))
  (when (and function
             (or ess-current-process-name
                 (interactive-p)))
    (ess-force-buffer-current "R process to use: ")
    ;; ^^^^^^^^^^^^^^^ has own error handler
    (cadr (ess-function-arguments function))
    ))

;;     (let ((ess-nuke-trailing-whitespace-p t)
;;        (args))
;;       (ess-command (format "try({fun<-\"%s\"; fundef<-paste(fun, '.default',sep='')
;; if(exists(fundef, mode = \"function\")) args(fundef) else args(fun)}, silent=F)\n" function)
;;                 (get-buffer-create "*ess-r-args-tmp*"))
;;       (with-current-buffer "*ess-r-args-tmp*"
;;      (goto-char (point-min))
;;      (if (null (search-forward "function" 20 t))
;;          (message ess-r-args-noargsmsg)
;;        (goto-char (point-min))
;;        (search-forward "(" nil t)
;;        (delete-region (point-min) (point))
;;        (goto-char (point-max))
;;        (search-backward ")" nil t)
;;        (delete-region (point) (point-max))
;;        (ess-nuke-trailing-whitespace); should also work in Xemacs
;;        (setq args (buffer-string))
;;        (if trim
;;            (replace-regexp-in-string " = " "="
;;                                      (replace-regexp-in-string "[\n \t]+" " " args))
;;          args)
;; )))))

(defun ess-r-args-show (&optional function)
  "Show arguments and their default values of R function. Calls
\\[ess-r-args-current-function] if called without argument."
  (interactive "*")
  (ess-message "(ess-r-args-show): start")
  (if (null function)
      (setq function (ess-r-args-current-function)))
  (ess-message ".... function='%s'" function)
  (when function
    (let* ((tt (and (equal ess-r-args-show-as 'tooltip)
                    ess-has-tooltip))
           (args (concat ess-r-args-show-prefix (ess-r-args-get function (not tt)))))
      (ess-message "(ess-r-args-show): args='%s'" args)
      (when  args
        (if (not tt)
            (message args)
          (require 'tooltip)
          ;; value of 30 in next call is just a guess,
          ;; should really be based
          ;; on something like pixel height of 1-2 vertical
          ;; lines of text
          (ess-tooltip-show-at-point args 0 30))
        ))))

(defun ess-r-args-auto-show ()
  "Typically assigned to \"(\": If there's an ess-process, automatically show arguments
and their default values of an R function. Built on \\[ess-r-args-show]."
  (interactive)
  (insert "("); (skeleton-pair-insert-maybe nil)
  (if (and (not eldoc-mode)
           ess-local-process-name ; has a process and it must still be running
           (get-ess-process ess-local-process-name))
      (ess-r-args-show)))

;; MM: I would strongly discourage use of the following:
;;     it leads to clueless newbie-users  who indeed
;;     explicitly call a function with all its default arguments;
;;     instead of only setting the required arguments
(defun ess-r-args-insert (&optional function)
  "Insert arguments and their default values of function. Calls
ess-r-args-current-function if no argument given."
  (interactive "*")
  (if (null function)
      (setq function (ess-r-args-current-function)))
  (if function
      (let ((args (ess-r-args-get function))
            (pointpos (point)))
        (insert args)
        (goto-char pointpos))))


;; (defvar ess-r-object-tooltip-alist
;;   '((numeric    . "summary")
;;     (integer    . "summary")
;;     (factor     . "table")
;;     (lm         . "summary")
;;     (other      . "str"))
;;   "List of (<class> . <R-function>) to be used in \\[ess-r-object-tooltip].
;;  For example, when called while point is on a factor object, a table of that
;;  factor will be shown in the tooltip.
;;  The special key \"other\" in the alist defines which function to call when
;;  the class is not mached in the alist.  The default, str(), is a fairly useful
;;  default for many, including data.frame and function objects.")

;; From Erik Iversion, slightly modified,
;; http://www.sigmafield.org/2009/10/01/r-object-tooltips-in-ess/
;; (defun ess-r-object-tooltip ()
;;   "Get info for object at point, and display it in a tooltip."
;;   (interactive)
;;   (let ((proc (get-ess-process))
;;         (objname (current-word))
;;         (curbuf (current-buffer))
;;         (tmpbuf (get-buffer-create " *ess-r-object-tooltip*"))
;;         bs)
;;     (when objname
;;       (ess-write-to-dribble-buffer
;;        (format "ess-r-object-tooltip: objname='%s'\n" objname))
;;       (ess-command (concat "class(" objname ")\n") tmpbuf nil nil nil proc)
;;       (with-current-buffer tmpbuf
;;         (goto-char (point-min))
;;         ;; CARE: The following can only work in an English language locale!
;;         ;; .lang. <- Sys.getenv("LANGUAGE"); Sys.setenv(LANGUAGE="en")
;;         ;; .lc. <- Sys.getlocale("LC_MESSAGES"); Sys.setlocale("LC_MESSAGES","en_US.utf-8")
;;         ;; and *afterward*  Sys.setenv(LANGUAGE=.lang.); Sys.setlocale("LC_MESSAGES", .lc.)
;;         ;; but that fails sometimes, e.g., on Windows
;;         (unless (re-search-forward "\(object .* not found\)\|unexpected" nil t)
;;           (re-search-forward "\"\\(.*\\)\"" nil t)
;;           (let* ((objcls (match-string 1))
;;                  (myfun (or (cdr (assoc-string objcls ess-r-object-tooltip-alist))
;;                             (cdr (assoc 'other ess-r-object-tooltip-alist)))))
;;             (ess-command (concat myfun "(" objname ")\n") tmpbuf nil nil nil proc))
;;           (setq bs (buffer-string)))))
;;     (if bs
;;       (ess-tooltip-show-at-point bs 0 30))))

;; Erik: my default key map
;;(define-key ess-mode-map "\C-c\C-g" 'ess-r-object-tooltip)

;; On http://www.sigmafield.org/2009/10/01/r-object-tooltips-in-ess/
;; in the comments, "Charlie" recommended

;; (custom-set-faces
;; '(tooltip ((t (:background "white" :foreground "blue" :foundry "fixed")))))



(provide 'ess-r-args)

;;; ess-r-args.el ends here
