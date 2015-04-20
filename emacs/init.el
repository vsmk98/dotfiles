;;-----------------------KICK STARTER------------------------------
(require 'cl)				; common lisp goodies, loop

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(setq user-emacs-directory "~/.emacs.d")
(setq default-directory "~/")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
	 (end-of-buffer)
	 (eval-print-last-sexp))))

;; now either el-get is `require'd already, or have been `load'ed by the
;; el-get installer.

;; set local recipes
(setq
 el-get-sources
 '((:name buffer-move			; have to add your own keys
	  :after (progn
		   (global-set-key (kbd "<C-S-up>")		'buf-move-up)
		   (global-set-key (kbd "<C-S-down>")	'buf-move-down)
		   (global-set-key (kbd "<C-S-left>")	'buf-move-left)
		   (global-set-key (kbd "<C-S-right>")	'buf-move-right)))

   (:name smex				; a better (ido like) M-x
	  :after (progn
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (global-set-key (kbd "M-x") 'smex)
		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name magit				; git meet emacs, and a binding
	  :after (progn
		   (global-set-key (kbd "C-x C-z") 'magit-status)))

   (:name goto-last-change		; move pointer back to last change
	  :after (progn
		   ;; when using AZERTY keyboard, consider C-x C-_
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))
   
   (:name cider				; a major mode for clojure
	  :after (progn
		   (add-hook 'clojure-mode-hook 'cider-mode)
		   (add-hook 'clojure-mode-hook 'paredit-mode)
		   (add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
		   (add-hook 'cider-repl-mode-hook 'paredit-mode)
		   (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
		   (add-hook 'cider-mode-hook 'rainbow-delimiters-mode)
		   (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
		   (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
		   (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
		   (setq nrepl-hide-special-buffers t)
		   (setq cider-repl-result-prefix "=> ")))
   
   (:name autopair
	  :after (progn
		   (autopair-global-mode)
		   (add-hook 'LaTeX-mode-hook
			     #' (lambda ()
				       (modify-syntax-entry ?$ "\"")
				       (autopair-mode)))
		   (put 'upcase-region 'disabled nil)))
   
   (:name color-theme
	  :after (progn
		   (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
		   (load-theme 'qvintvs t)))
   
   (:name smart-compile
	  :after (progn
		   (global-set-key (kbd "C-'") 'smart-compile)))

   (:name smart-tab
	  :after (progn
		   (add-hook 'java-mode-hook
			     (lambda () (setq indent-tabs-mode t)))
		   (add-hook 'emacs-lisp-mode-hook
			     (lambda () (setq indent-tabs-mode t)))
		   (add-hook 'java-mode-hook 'smart-tab-mode)
		   (add-hook 'emacs-lisp-mode-hook 'smart-tab-mode)))

   (:name powerline
   	  :after (progn
   		   (powerline-default-theme)))

   (:name AUCTeX
   	  :after (progn
   		   (add-hook 'LaTeX-mode-hook 'auto-complete-mode)
   		   (setq TeX-auto-save t)
   		   (setq TeX-parse-self t)
   		   (setq TeX-save-query nil)
   		   (setq TeX-PDF-mode t)))

   (:name yasnippet
	  :after (progn
		   (yas-global-mode 1)))

   (:name rainbow-mode
	  :after (progn
		   (defun all-css-modes() (css-mode) (rainbow-mode))
		   (add-to-list 'auto-mode-alist '("\\.css$" . all-css-modes))))))

;; set packages
(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   auto-complete
   markdown-mode
   sass-mode
   paredit
   rainbow-delimiters
   tuareg-mode
   ess
   ;; matlab-mode
   ))

;;
;; Some recipes require extra tools to be installed
;;

(when (ignore-errors (el-get-executable-find "cvs"))
   (add-to-list 'my:el-get-packages 'emacs-goodies-el)) 

(when (ignore-errors (el-get-executable-find "svn"))
  (loop for p in '(psvn				; M-x svn-status
		   yasnippet		; powerful snippet mode
		   )
	do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
	  (append
	   my:el-get-packages
	   (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)


;;-------------------------VISUAL----------------------------

;; indentation setting
(setq c-basic-offset 4)
(setq tab-width 4)
(setq indent-tabs-mode nil)
(setq tab-stop-list ())
(define-key global-map (kbd "RET") 'newline-and-indent)

(line-number-mode 1)		     ; have line numbers and
(column-number-mode 1)		     ; column numbers in the mode line
(setq fill-column 80)		     ; 80-column
(scroll-bar-mode -1)		     ; no scroll bars
(setq inhibit-splash-screen t)	     ; no splash screen, thanks
(tool-bar-mode -1)		     ; no tool bar with icons
(global-hl-line-mode)		     ; highlight current line
(make-variable-buffer-local 'global-hl-line-mode)
(add-hook 'term-mode-hook
          (lambda () (setq global-hl-line-mode nil)))
(global-linum-mode 1)		     ; add line numbers on the left
(add-hook 'term-mode-hook
	  (lambda () (setq linum-mode nil)))
(setq linum-format " %d")	     ; space before line numbers

(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
(if (string-match "apple-darwin" system-configuration)
    (set-face-font 'default "Monaco-13") ; large for laptop
  ;; (set-face-font 'default "Menlo-11") ; small font for laptop
  ;; (set-face-font 'default "Consolas-16") ; for monitor
  (set-face-font 'default "Monospace-10"))

(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t))

;;-----------------------SMALL FIXES--------------------------

;; fast access to init.el
(defun find-user-init-file ()
  (interactive)
  (find-file-at-point user-init-file))
(global-set-key (kbd "<f5>") 'find-user-init-file)

;; easy window scrolling up and down
(global-set-key (kbd "M-p") 'scroll-up-line)
(global-set-key (kbd "M-n") 'scroll-down-line)

;; quick shell command
(global-set-key (kbd "C-\;") 'async-shell-command)

;; org mode fix
(global-set-key (kbd "<C-M-return>") 'org-insert-heading-after-current)

;; avoid compiz manager rendering bugs
(add-to-list 'default-frame-alist '(alpha . 100))

;; use y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; copy/paste with C-c and C-v and C-x, check out C-RET too
(cua-mode)

;; Use the clipboard, pretty please, so that copy/paste "works"
(setq x-select-enable-clipboard t)

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

; winner-mode provides C-c <left> to get back to previous window layout
(winner-mode 1)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; paren-pair
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;; display current file path
(setq frame-title-format
	  (list (format "%s %%S: %%j " (system-name))
		'(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; PATH
(setenv "PATH" (concat (getenv "PATH") ":/Applications/MATLAB_R2014b.app/bin:/usr/texbin:/usr/local/bin"))
(setq exec-path (append exec-path '("/Applications/MATLAB_R2014b.app/bin" "/usr/texbin" "/usr/local/bin")))


;;-------------------------BIGGER FIXES------------------------------

;; zsh support
(setq multi-term-program "/bin/zsh")
(global-set-key (kbd "<f1>") 'multi-term)
(global-set-key (kbd "M-[") 'multi-term-prev)
(global-set-key (kbd "M-]") 'multi-term-next)

(setq default-terminal-coding-system "utf-8-unix")
(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)
(require 'ucs-normalize) 
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)
(setq system-uses-terminfo nil)

;; Detect endianness of UTF-16 containing a Byte Order Mark U+FEFF
;; Detect EOL mode by looking for CR/LF on the first line
(add-to-list 'auto-coding-regexp-alist '("^\xFF\xFE.*\x0D\x00$" . utf-16-le-dos) t)
(add-to-list 'auto-coding-regexp-alist '("^\xFE\xFF.*\x0D\x00$" . utf-16-be-dos) t)
(add-to-list 'auto-coding-regexp-alist '("^\xFF\xFE" . utf-16-le) t)
(add-to-list 'auto-coding-regexp-alist '("^\xFE\xFF" . utf-16-be) t)

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-c") 'ibuffer)

;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
			   (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f11] 'fullscreen)

;; TRAMP
(require 'tramp)
(setq tramp-default-host "128.199.196.219")
(setq tramp-default-user "root")
(setq tramp-default-method "ssh")

;; whitespace mode tweak
(setq whitespace-display-mappings
       ;; all numbers are Unicode codepoint in decimal. try (insert-char 182 ) to see it
      '(
        (space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT ·, 46 FULL STOP .
        (newline-mark 10 [182 10]) ; 10 LINE FEED
        (tab-mark 9 [8677 9] [92 9]) ; 9 TAB, 8677 RIGHTWARDS ARROW TO BAR ⇥
        ))

;; thesaurus mode
(setq thesaurus-bhl-api-key "d0c3a24ec0f4736607baf64c4340824c")

;; ESS
;; (require 'ess-site)
(add-to-list 'load-path "~/.emacs.d/ess-14-2.09/lisp/")
(load "ess-site")

;; Matlab
;; (add-to-list 'load-path "~/.emacs.d/matlab-emacs/")
;; (load-library "matlab-load")
;; (autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(custom-set-variables
 '(matlab-shell-command-switches '("-nodesktop -nosplash")))
(add-hook 'matlab-mode-hook 'auto-complete-mode)
(add-hook 'matlab-shell-mode-hook 'auto-complete-mode)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))
(setq matlab-indent-function t)
(setq matlab-shell-command "matlab")

;; ARFF syntax highlight
(require 'generic)
(define-generic-mode 'arff-file-mode
  (list ?%)
  (list "attribute" "relation" "end" "data")
  '(
    ("\\('.*'\\)" 1 'font-lock-string-face)    
    ("^\\@\\S-*\\s-\\(\\S-*\\)" 1 'font-lock-string-face)    
    ("^\\@.*\\(real\\)" 1 'font-lock-type-face)    
    ("^\\@.*\\(integer\\)" 1 'font-lock-type-face)    
    ("^\\@.*\\(numeric\\)" 1 'font-lock-type-face)    
    ("^\\@.*\\(string\\)" 1 'font-lock-type-face)    
    ("^\\@.*\\(date\\)" 1 'font-lock-type-face)    
    ("^\\@.*\\({.*}\\)" 1 'font-lock-type-face)    
    ("^\\({\\).*\\(}\\)$" (1 'font-lock-reference-face) (2
'font-lock-reference-face))
    ("\\(\\?\\)" 1 'font-lock-reference-face)    
    ("\\(\\,\\)" 1 'font-lock-keyword-face)    
    ("\\(-?[0-9]+?.?[0-9]+\\)" 1 'font-lock-constant-face)    
    ("\\(\\@\\)" 1 'font-lock-preprocessor-face)    
    )
  (list "\.arff?")
  (list
   (function
    (lambda () 
      (setq font-lock-defaults (list 'generic-font-lock-defaults nil t ; case
insensitive
                                     (list (cons ?* "w") (cons ?- "w"))))
      (turn-on-font-lock))))
  "Mode for arff-files.")

;; ==>flymake

;; (require 'flymake)
;; (defun flymake-get-tex-args (file-name)
;;   (list "pdflatex"
;; 	(list "-file-line-error" "-draftmode" "-interaction=nonstopmode"
;; 	      file-name)))
;; (add-hook 'LaTeX-mode-hook 'flymake-mode)

;; outline
(defun turn-on-outline-minor-mode ()
  (outline-minor-mode 1))
(add-hook 'LaTeX-mode-hook 'turn-on-outline-minor-mode)
(add-hook 'latex-mode-hook 'turn-on-outline-minor-mode)
(setq outline-minor-mode-prefix (kbd "C-c C-o"))

;;--------------------custom VARIABLE--------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't workright.
 '(whitespace-style (quote (face tabs spaces trailing lines space-before-tab newline empty space-mark tab-mark newline-mark))))

;;------------------------------TODO------------------------------
;; evernote
;; setup clojure web stack
;; flymake
;; fix matlab recipe
