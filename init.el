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
  (add-to-list 'eglot-server-programs '((c20-mode c++-mode c-mode) "/usr/bin/clang")))

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
		    :font "Spleen-20")

;; ===================================================================
;; 1. THE FOUNDATION: AUCTEX & REFTEX
;; ===================================================================

(use-package tex
  :ensure auctex
  :defer t
  :custom
  ;; Don't prompt for saving when compiling; just save
  (TeX-save-query nil)
  ;; Make AUCTeX tightly integrated with RefTeX
  (TeX-reftex-embedding-guard nil)
  ;; Use modern PDF generation by default
  (TeX-PDF-mode t)
  ;; Correlate PDF and source code (SyncTeX)
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-start-server t)
  :config
  ;; Enable parsing of the document to get automatic cross-references/packages
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  ;; Query for master file if working on multi-file papers
  (setq-default TeX-master nil)
  
  ;; Add RefTeX and Flyspell to LaTeX-mode hooks
  (add-hook 'LaTeX-mode-hook #'turn-on-reftex)
  (add-hook 'LaTeX-mode-hook #'flyspell-mode)
  (add-hook 'LaTeX-mode-hook #'TeX-source-correlate-mode))

(use-package reftex
  :ensure nil ; Built-in
  :defer t
  :custom
  ;; Plug into AUCTeX's completion systems
  (reftex-plug-into-AUCTeX t)
  ;; Derive labels automatically from section names
  (reftex-insert-label-flags '("s" "s"))
  :config
  ;; Make RefTeX aware of common CS/math environments (theorems, lemmas)
  (setq reftex-insert-label-flags '("s" "s")) ; customize to auto-label sections
)

;; ===================================================================
;; 2. MATHEMATICS SPEED DEMONS: CDLATEX & PRETTIFY
;; ===================================================================

(use-package cdlatex
  :ensure t
  :defer t
  :hook (LaTeX-mode-hook . turn-on-cdlatex)
  :config
  ;; Custom key-binding or snippet behavior can go here if needed.
  ;; Standard usage: `_` or `^` auto-opens braces `^{}`, `tab` expands math macros.
)

(use-package tex-mode
  :ensure nil ; Built-in
  :hook (LaTeX-mode-hook . prettify-symbols-mode)
  :config
  ;; Visually turns \alpha into α, \sum into ∑ while keeping underlying plain text.
  ;; Crucial for skim-reading heavy mathematical equations without compiling.
  (setq prettify-symbols-unprettify-at-point 'right-edge))

;; ===================================================================
;; 3. COMPUTER SCIENCE & WRITING: ORG-MODE & SNIPPETS
;; ===================================================================

;; Org-mode bridges the gap: write scratchpads, export to LaTeX/Beamer, embed live code.
(use-package org
  :ensure nil ; Built-in
  :defer t
  :config
  ;; Seamless LaTeX exporting and execution of code blocks (literate programming)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((latex . t)
     (python . t)
     (emacs-lisp . t)))
  ;; Make Org visually render LaTeX equations asynchronously
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5)))

(use-package yasnippet
  :ensure t
  :hook (LaTeX-mode-hook . yas-minor-mode)
  :config
  ;; Install or point to a snippet collection (like yasnippet-snippets)
  ;; Perfect for heavy computer science boilerplate/algorithms or math matrices.
  (yas-reload-all))

;; ===================================================================
;; 4. PROOFING & RENDERING: PDF-TOOLS
;; ===================================================================

(use-package pdf-tools
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :config
  ;; Initialize pdf-tools
  (pdf-tools-install)
  ;; Force AUCTeX to open PDFs internally via pdf-tools
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-view-program-list '(("PDF Tools" "TeX-pdf-tools-sync-view")))
  ;; Update PDF buffer automatically after running LaTeX compilation
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; ===================================================================
;; 5. MARKDOWN & PANDOC ECOSYSTEM
;; ===================================================================

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode) ; Use GitHub-Flavored Markdown for READMEs
  :init
  ;; Tell Emacs to use pandoc as the default markdown processor
  (setq markdown-command "pandoc")
  :config
  ;; Enable flyspell for prose writing in Markdown
  (add-hook 'markdown-mode-hook #'flyspell-mode)
  ;; Automatically wrap text at 80 characters for clean git diffs
  (add-hook 'markdown-mode-hook #'turn-on-auto-fill)
  
  :custom
  ;; Display raw asterisks/underscores as actual bold/italic text
  (markdown-hide-markup t)
  ;; Fontify code blocks using the native major mode syntax highlighting (Python, C, etc.)
  (markdown-fontify-code-blocks-natively t))

(use-package pandoc-mode
  :ensure t
  :after markdown-mode
  :hook (markdown-mode-hook . pandoc-mode)
  :config
  ;; This gives you a dedicated menu (C-c /) to completely tweak Pandoc settings.
  ;; You can instantly switch output formats (e.g., markdown -> latex -> pdf)
  ;; and easily manage bibliography tables or PDF engines like xelatex.
  )

;; For the Mathematician: Live LaTeX preview inside Markdown files
(use-package xenops
  :ensure t
  :after markdown-mode
  :hook (markdown-mode-hook . xenops-mode)
  :custom
  ;; Asynchronously renders blocks like $$ \sum_{i=1}^n i $$ directly in the file
  (xenops-math-image-scale 1.5))

  :custom
  ;; Fine-grained zooming instead of large steps
  (pdf-view-resize-factor 1.1))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auctex cdlatex clipetty company doom-themes magit markdown-mode
	    pandoc-mode pdf-tools sly xenops yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
