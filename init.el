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
(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-outrun-electric t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; --- clipboard sync
(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode))

;; --- C and C++ ide stuff
(use-package eglot
  :ensure t
  :hook
  ((c-mode . eglot-ensure)
   (c++-mode . eglot-ensure))
  :config
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
		    :font "spleen-16")
