;;-----------------------------------------------------------
;;                     KICK STARTER                         |
;;-----------------------------------------------------------

(require 'cl)				; common lisp goodies, loop

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

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
		   (global-set-key (kbd "<C-S-up>")     'buf-move-up)
		   (global-set-key (kbd "<C-S-down>")   'buf-move-down)
		   (global-set-key (kbd "<C-S-left>")   'buf-move-left)
		   (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

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
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))))

;; set packages
(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   escreen            			; screen for emacs, C-\ C-h
   php-mode-improved			; if you're into php...
   switch-window			; takes over C-x o
   auto-complete			; complete as you type with overlays
   zencoding-mode			; http://www.emacswiki.org/emacs/ZenCoding
   color-theme		                ; nice looking emacs
   autopair
   smart-compile
   rainbow-mode
   markdown-mode
))	                

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
;; (when (el-get-executable-find "cvs")
;;   (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

(when (el-get-executable-find "svn")
  (loop for p in '(psvn    		; M-x svn-status
		   yasnippet		; powerful snippet mode
		   )
	do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)


;;-----------------------------------------------------------
;;                        VISUAL                            |
;;-----------------------------------------------------------

;; indentation setting
(setq c-basic-offset 4)
(setq tab-width 4)
(setq indent-tabs-mode nil)
(setq tab-stop-list ())

(load-theme 'hickey t)                  ; theme setting

(column-number-mode 1)                  ; column numbers in the mode line
(line-number-mode 1)                    ; have line numbers and

(setq fill-column 80)                   ; 80-column 

(scroll-bar-mode -1)                    ; no scroll bars
(setq inhibit-splash-screen t)          ; no splash screen, thanks
(tool-bar-mode -1)                      ; no tool bar with icons

(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
(if (string-match "apple-darwin" system-configuration)
    (set-face-font 'default "Monaco-13")
;;  (set-face-font 'default "Consolas-16")  -> for large screen
  (set-face-font 'default "Monospace-10"))

(global-hl-line-mode)		        ; highlight current line
(global-linum-mode 1)			; add line numbers on the left

(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t))

;; Set Ido color
(custom-set-faces
   ;; Face used by ido for highlighting subdirs in the alternatives.
   '(ido-subdir ((t (:foreground "#C0AEDE")))) 
   ;; Face used by ido for highlighting first match.
   '(ido-first-match ((t (:foreground "#AEE239")))) 
   ;; Face used by ido for highlighting only match.
   '(ido-only-match ((t (:foreground "#FD971F")))) 
   ;; Face used by ido for highlighting its indicators (don't actually use this)
   '(ido-indicator ((t (:foreground "#ffffff")))) 
   ;; Ido face for indicating incomplete regexps. (don't use this either)
   '(ido-incomplete-regexp ((t (:foreground "#ffffff")))))


;;-----------------------------------------------------------
;;                     SMALL FIXED                          |
;;-----------------------------------------------------------

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

;; key binding
(global-set-key (kbd "C-\;") 'async-shell-command)

;; paren-pair
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;;display current file path
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; mode hook
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

;;-----------------------------------------------------------
;;                       BIGGER FIX                         |
;;-----------------------------------------------------------

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

;; smart compile
(require 'smart-compile)
(global-set-key (kbd "C-'") 'smart-compile)

;; TRAMP
(require 'tramp)
(setq tramp-default-host "cz2006.ciel.im")
(setq tramp-default-user "root")
(setq tramp-default-method "ssh")

;; CSS and Rainbow modes
(defun all-css-modes() (css-mode) (rainbow-mode)) 
(add-to-list 'auto-mode-alist '("\\.css$" . all-css-modes))

;;autopair
(require 'autopair)
(autopair-global-mode)
(put 'upcase-region 'disabled nil)
