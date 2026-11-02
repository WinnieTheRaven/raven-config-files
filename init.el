;; --- package repositoryt setup ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; --- Automatically download packages if they aren't installed ---
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; --- just comfy stuff ---
(xterm-mouse-mode 1)
(global-display-line-numbers-mode 1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(setq inhibit-startup-screen t)

;; --- theme personalization ---
;;(use-package doom-themes
;;  :ensure t
;;  :custom
;;  (doom-themes-enable-bold t)
;;  (doom-themes-enable-italic t)
;;  :config
;;  (load-theme 'doom-feather-light t)
;;  (doom-themes-visual-bell-config)
;;  (doom-themes-org-config))
(use-package guava-themes
  :ensure t
  :custom
  (guava-themes-visible-duration 0.15)
  (guava-themes-visible-bell-idle-delay 0.0)
  (guava-themes-boxed-mode-line nil)
  (ring-bell-function #'guava-themes-change-visible-bell)
  (visible-bell t)
  :config
  (load-theme 'guava-themes-rhododendron t))

;; --- transparency stuff ---
(add-to-list 'default-frame-alist '(alpha-background . 80))

;; --- clipboard sync ---
(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode))

;; --- C++ IDE Intelligence via LSP (clangd) ---
(use-package eglot
  :ensure t
  :hook
  ((c-mode . eglot-ensure)
   (c++-mode . eglot-ensure))
  :config
  ;; Tell eglot exactly where to find her Debian clangd binary
  (add-to-list 'eglot-server-programs '((c20-mode c++-mode c-mode) "clangd")))

;; --- autocompletion stuff ---
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.0
	company-minimum-prefix-length 1))

;; --- lisp stuff UwUr <3 <3 <3 ---
(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "sbcl"))
(add-hook 'lisp-mode-hook #'sly-mode)
(global-set-key (kbd "C-c s") 'sly)

;; --- column numbers and font stuff ---
(column-number-mode 1)
(set-face-attribute 'default nil
		    :font "spleen 8x16-16")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(base16-theme clipetty company doom-themes gauava-themes guava-themes
		  magit sly)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
