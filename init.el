;; melpa package management
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://stable.melpa.org/packages/")
   t)
  (package-initialize))
;; refresh contents if necessary
(when (not package-archive-contents)
  (package-refresh-contents))
;;

;; so it can find lein and other commands
(add-to-list 'exec-path "/usr/local/bin")
;;

;; add custom load path
(add-to-list 'load-path "~/.emacs.d/thoughtmanifest/")
(add-to-list 'custom-theme-load-path' "~/.emacs.d/thoughtmanifest/")
;;

;; shift select
(setq shift-select-mode t)
;;

;; enable cua mode Copy/Cut/Paste uses C-c/C-x/C-v and enables delete-selection-mode by default
(cua-mode t)
;;

;; set default find-file (C-x C-f) directory
(setq default-directory (concat (getenv "HOME") "/src/metis/"))
;; end default find-file directory

;; load in front
(x-focus-frame nil)
;;

;; list packages
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; scala-mode
    scala-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; inf-clojure
    inf-clojure

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    ;; cider

    ;; dumb-jump https://github.com/jacktasia/dumb-jump
    dumb-jump

    ;; org-mode
    org

    ;; git gutter
    git-gutter

    ;; volatile highlights
    volatile-highlights

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; exec path from shell
    exec-path-from-shell

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; ensime
    ;; http://ensime.org
    ensime

    ;; git integration
    magit

    ;; in support of magit
    git-commit

    ;; auto-complete
    ;; https://github.com/auto-complete/auto-complete
    auto-complete

    ;; elixir mode
    elixir-mode

    ;; neotree - directory visualization
    neotree
    ))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))
;;
;; linum mode
(add-hook 'clojure-mode-hook #'linum-mode)

;; org mode
;; Fast vertical navigation
(add-hook 'clojure-mode-hook #'outline-minor-mode)
(global-set-key  (kbd "M-p") 'outline-previous-visible-heading)
(global-set-key  (kbd "M-n") 'outline-next-visible-heading)
;;

(setq truncate-lines t)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ;; inferior-lisp
;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq inferior-lisp-program "lein trampoline run -m clojure.main")
;; (require 'inf-lisp)
;; (require 'clojure-mode)
;; (require 'paredit)

;; ;; Right now I only use inferior lisp for clojure, so we configure for that
;; (define-key clojure-mode-map (kbd "C-c C-c") 'lisp-eval-defun)

;; (add-hook 'inferior-lisp-mode-hook
;;           (lambda ()
;;             (paredit-mode t)))

;; (defun comint-clear-buffer ()
;;   (interactive)
;;   (let ((comint-buffer-maximum-size 0))
;;     (comint-truncate-buffer)))

;; (define-key inferior-lisp-mode-map (kbd "C-c M-o") #'comint-clear-buffer)

;; clojure mode extra font locking
(require 'clojure-mode-extra-font-locking)
;;

;; auto-highlight-symbol
(require 'auto-highlight-symbol)
(add-hook 'clojure-mode-hook #'auto-highlight-symbol-mode)
(global-auto-highlight-symbol-mode t)
;;

;; inf-clojure
(autoload 'inf-clojure "inf-clojure" "Run an inferior Clojure process" t)
(add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)
(setq inf-clojure-lein-cmd "lein repl")
(setq inf-clojure-log-activity t)
;;

;; cider
;; (autoload 'cider "CIDER" "Run a CIDER process" t)
;; (add-hook 'clojure-mode-hook #'cider-mode)
;;

;; git gutter
(global-git-gutter-mode +1)
;;

;; dumb-jump
(require 'dumb-jump)
(add-to-list 'dumb-jump-language-file-exts '(:language "clojure" :ext "cljc"))
(add-to-list 'dumb-jump-language-file-exts '(:language "clojure" :ext "cljs"))

(global-set-key (kbd "M-.") 'dumb-jump-go)
(global-set-key (kbd "M-,") 'dumb-jump-back)
;;

;;remove all trailing whitespace and trailing blank lines before
;;saving the file
(defvar live-ignore-whitespace-modes '(markdown-mode))
(defun live-cleanup-whitespace ()
  (if (not (member major-mode live-ignore-whitespace-modes))
      (let ((whitespace-style '(trailing empty)) )
        (whitespace-cleanup))))

(add-hook 'before-save-hook 'live-cleanup-whitespace)

;; volatile highlights
(require 'volatile-highlights)
(volatile-highlights-mode t)
;;

;; ElDoc
(add-hook 'clojure-mode-hook #'eldoc-mode)
;; (add-hook 'cider-repl-mode-hook #'eldoc-mode)
(add-hook 'inf-clojure-mode-hook #'eldoc-mode)
;;

;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)
;;

;; rainbow delimiters mode
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;; (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
(add-hook 'inf-clojure-mode-hook #'rainbow-delimiters-mode)
;;

;; paredit
(require 'paredit)
(add-hook 'clojure-mode-hook #'paredit-mode)
;; (add-hook 'cider-repl-mode-hook
;; 	  '(lambda ()
;; 	     (define-key cider-repl-mode-map "{" #'paredit-open-curly)
;; 	     (define-key cider-repl-mode-map "}" #'paredit-close-curly)))
;; (add-hook 'cider-repl-mode-hook #'paredit-mode)
(add-hook 'inf-clojure-mode-hook
	  '(lambda ()
	     (define-key inf-clojure-mode-map "{" #'paredit-open-curly)
	     (define-key inf-clojure-mode-map "}" #'paredit-close-curly)))
(add-hook 'inf-clojure-mode-hook #'paredit-mode)

(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code."
  t)
(add-hook 'lisp-mode-hook '(lambda () (paredit-mode +1)))
(add-hook 'emacs-lisp-mode-hook '(lambda () (paredit-mode +1)))

(show-paren-mode t)
;;

;; for PATH and env variables
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
(exec-path-from-shell-copy-env "AWS_ACCESS_KEY_ID")
(exec-path-from-shell-copy-env "AWS_SECRET_KEY")
(exec-path-from-shell-copy-env "CASSANDRA_USERNAME")
(exec-path-from-shell-copy-env "CASSANDRA_PASSWORD")
(exec-path-from-shell-copy-env "PG_USERNAME")
(exec-path-from-shell-copy-env "PG_PASSWORD")

;;

;; neotree for directory visualization
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-autorefresh nil)
;;

;; ido mode
(ido-mode 1)
(ido-everywhere 1)
;; ido-ubiquitous
(require 'ido-ubiquitous)
(ido-ubiquitous-mode 1)
;;

;; smex
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
;;

;; projectile
(projectile-global-mode)
;;

;; magit https://magit.vc/manual/magit/Getting-started.html#Getting-started
(global-set-key (kbd "C-x g") 'magit-status)
;;

;; auto-complete
(require 'auto-complete-config)
(ac-config-default)

;; Turn off automatic start of auto-complete
;; (setq ac-auto-start nil)

(add-hook 'auto-complete-mode-hook
          (lambda ()
            (local-set-key (kbd "M-/") 'auto-complete)
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)
            (define-key ac-completing-map (kbd "C-g") 'ac-stop)
            (define-key ac-completing-map (kbd "ESC") 'ac-stop)))

(add-hook 'inf-clojure-mode-hook #'auto-complete-mode)
;; (add-hook 'cider-repl-mode-hook #'auto-complete-mode)
;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#000000" "#8b0000" "#00ff00" "#ffa500" "#7b68ee" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(custom-enabled-themes (quote (cyberpunk)))
 '(custom-safe-themes
   (quote
    ("0f3e5004f31fe101a0427c25340efe003db5b77873e174414bd1c77c6ec3c653" "e51bba638ca966d689c7616dc29518a1581a9e22491452bc8151c6f5ceb372f6" "727ddccc30515640c681ca1733b0664e71634ef5cee609f62c52e8c051a49b5a" "076a01f9c80b3b1f6b0092b4def01ed5fab03e973d934832dc8742739d70711d" "55db67066183c8a6d20499a5124700ee944d31d9f5f46adf5ecbbaf6e8286d36" "68c62ecb4de7af63f9a3f084525762e8178d519cb884e4f191c27c38ff89eddf" "b4895a8742988d2c2189f64d76ff213bf91a7a31e4a606661a8325509064732e" "1b2e1d8fc6f84faded0a8723784d82a193b94de90167e90034d26e6d164ace87" "33733515690b54cf4c5a839faa1f6b0b33f4979b76c6967dad39b97f9234205a" "7528c43a5627427937d253a534bd41d3200735a822782f94d0d90e57cfe7467a" "cdbd0a803de328a4986659d799659939d13ec01da1f482d838b68038c1bb35e8" "bcc6775934c9adf5f3bd1f428326ce0dcd34d743a92df48c128e6438b815b44f" "71ecffba18621354a1be303687f33b84788e13f40141580fa81e7840752d31bf" "7c33d91f9896614a9c28e96def4cbd818f0aa7f151d1fb5d205862e86f2a3939" default)))
 '(fci-rule-color "#383838")
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (neotree elixir-mode auto-complete inf-clojure zerodark-theme zenburn-theme volatile-highlights undo-tree tagedit smex scala-mode rainbow-mode rainbow-delimiters projectile paredit org markdown-mode magit ido-ubiquitous hc-zenburn-theme git-gutter exec-path-from-shell dumb-jump clojure-mode-extra-font-locking cider)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(vc-annotate-background "#202020")
 '(vc-annotate-color-map
   (quote
    ((20 . "#C99090")
     (40 . "#D9A0A0")
     (60 . "#ECBC9C")
     (80 . "#DDCC9C")
     (100 . "#EDDCAC")
     (120 . "#FDECBC")
     (140 . "#6C8C6C")
     (160 . "#8CAC8C")
     (180 . "#9CBF9C")
     (200 . "#ACD2AC")
     (220 . "#BCE5BC")
     (240 . "#CCF8CC")
     (260 . "#A0EDF0")
     (280 . "#79ADB0")
     (300 . "#89C5C8")
     (320 . "#99DDE0")
     (340 . "#9CC7FB")
     (360 . "#E090C7"))))
 '(vc-annotate-very-old-color "#E090C7"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
