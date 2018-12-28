(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)
(package-refresh-contents)

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))


(require 'use-package)

(use-package tango-2-theme :ensure tango-2-theme)
(use-package smartparens :ensure smartparens)
(use-package powerline :ensure powerline)
(use-package airline-themes :ensure airline-themes)
(use-package iedit :ensure iedit)
(use-package yasnippet :ensure yasnippet)
(use-package yasnippet-snippets :ensure yasnippet-snippets)
(use-package auto-complete-clang :ensure auto-complete-clang)
(use-package flycheck :ensure flycheck)
(use-package company-irony :ensure company-irony)
(use-package company-irony-c-headers :ensure company-irony-c-headers)
(use-package cpputils-cmake :ensure cpputils-cmake)
(use-package google-c-style :ensure google-c-style)
(use-package cmake-mode :ensure cmake-mode)
(use-package nyan-mode :ensure nyan-mode)
(use-package helm :ensure helm)
(use-package helm-git-grep :ensure helm-git-grep)

(require 'tango-2-theme)
(require 'smartparens-config)
(require 'powerline)
(require 'airline-themes)
(require 'iedit)
(require 'yasnippet)
(require 'yasnippet-snippets)
(require 'auto-complete)
(require 'auto-complete-config)
(require 'auto-complete-clang)
(require 'flycheck)
(require 'company-irony)
(require 'company-irony-c-headers)
(require 'company)
(require 'irony)
(require 'cpputils-cmake)
(require 'google-c-style)
(require 'cmake-mode)
(require 'nyan-mode)
(require 'helm)
(require 'helm-git-grep) ;; Not necessary if installed by package.el

;;-------------------------------------- CONFIG

(global-set-key (kbd "C-c g") 'helm-git-grep)
;; Invoke `helm-git-grep' from isearch.
(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
;; Invoke `helm-git-grep' from other helm.
(eval-after-load 'helm
  '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))

(global-set-key (kbd "C-c p") 'helm-git-grep-at-point)
(eval-after-load 'helm '(define-key helm-map (kbd "C-c p") 'helm-git-grep-at-point))

(global-set-key (kbd "C-x b") 'helm-buffers-list)

(load-theme 'tango-dark)

(show-paren-mode 1)

(powerline-default-theme)

(yas-global-mode 1)

(semantic-mode 1)

;;; Nyancat
(setq-default nyan-animate-nyancat t)
(setq-default nyan-wavy-trail t)
(setq-default nyan-minimum-window-width 100)
(nyan-mode 1)
(nyan-start-animation)

(setq ac-source-yasnippet nil)

(ac-config-default)
(setq-default ac-sources '(ac-source-words-in-all-buffer))

(ac-set-trigger-key "TAB")
(define-key ac-mode-map  [(control tab)] 'auto-complete)

(global-flycheck-mode)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))

;;(add-hook 'c++-mode-hook 'irony-mode)
;;(add-hook 'c-mode-hook 'irony-mode)
;;(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'after-init-hook 'global-company-mode)

(add-hook 'c-mode-common-hook
          (lambda ()
            (if (derived-mode-p 'c-mode 'c++-mode)
                (cppcm-reload-all)
              )))
;; OPTIONAL, somebody reported that they can use this package with Fortran
(add-hook 'c90-mode-hook (lambda () (cppcm-reload-all)))
;; OPTIONAL, avoid typing full path when starting gdb
(global-set-key (kbd "C-c C-g")
		'(lambda ()(interactive) (gud-gdb (concat "gdb --fullname " (cppcm-get-exe-path-current-buffer)))))

					; Add cmake listfile names to the mode list.
(setq auto-mode-alist
      (append
       '(("CMakeLists\\.txt\\'" . cmake-mode))
       '(("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))

(autoload 'cmake-mode "~/CMake/Auxiliary/cmake-mode.el" t)

(global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(defun jrh-isearch-with-region ()
  "Use region as the isearch text."
  (when mark-active
    (let ((region (funcall region-extract-function nil)))
      (deactivate-mark)
      (isearch-push-state)
      (isearch-yank-string region))))

(add-hook 'isearch-mode-hook #'jrh-isearch-with-region)


;;(add-hook 'c-mode-common-hook (lambda () (interactive) (column-marker-3 80)))

;;-------------------------------------- MISC
(setq inhibit-startup-message t)

(tool-bar-mode -1)

(menu-bar-mode -1)

(scroll-bar-mode -1)

(global-hl-line-mode 1)
(set-face-background 'hl-line "#151515")
(set-face-foreground 'highlight nil)

(fset 'yes-or-no-p 'y-or-n-p)

(setq confirm-nonexistent-file-or-buffer nil)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq transient-mark-mode t)

(setq kill-buffer-query-functions (remq 'process-kill-buffer-query-function kill-buffer-query-functions)) (setq backup-directory-alist `((".*" . ,temporary-file-directory)))

(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(ido-mode 1)

(add-hook 'text-mode-hook 'auto-fill-mode)

;;-------------------------------------- KEYBINDS
(global-set-key (kbd "C-<next>") 'previous-buffer)
(global-set-key (kbd "C-<prior>") 'next-buffer)
(global-set-key (kbd "C-<home>") 'kill-this-buffer)
(global-set-key (kbd "C-<end>") 'other-window)
(global-set-key (kbd "C-x <delete>") 'delete-window)

(add-hook 'c-mode-common-hook (lambda() (local-set-key (kbd "<f5>") 'cppcm-compile-in-root-build-dir)))
(add-hook 'c-mode-common-hook (lambda() (local-set-key (kbd "<f6>") 'cppcm-recompile)))
(add-hook 'c-mode-common-hook (lambda() (local-set-key (kbd "<C-insert>") 'ff-find-other-file)))
(add-hook 'c-mode-common-hook (lambda() (linum-mode 1)))
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-hook 'c-mode-common-hook #'smartparens-mode)


(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-git-grep helm nyan-mode yatemplate yasnippet-snippets nasm-mode yasnippet use-package tango-2-theme srefactor smartparens iedit google-c-style flycheck editorconfig cpputils-cmake company-irony-c-headers company-irony cmake-mode auto-complete-clang airline-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
