;; -*- lexical-binding: t; -*-





(use-package package
  :ensure nil
  :config
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
  (package-initialize)
  )

(use-package use-package
  :ensure nil
  :custom
  ;; Always download packages if not available
  (use-package-always-ensure t)
  )

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (if (not (display-graphic-p))
      (setq doom-modeline-icon nil))
  )

(use-package doom-themes
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :config
  (load-theme 'doom-one t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (defun my/switch-to-light-theme ()
    "Switch to doom-one-light theme after disabling current theme"
    (interactive)
    (mapcar #'disable-theme custom-enabled-themes)
    (load-theme 'doom-one-light t)
    )
  (defun my/switch-to-dark-theme ()
    "Switch to doom-one theme after disabling current theme"
    (interactive)
    (mapcar #'disable-theme custom-enabled-themes)
    (load-theme 'doom-one t)
    )
  )

(use-package tex
  :ensure auctex
  :hook
  (TeX-mode . latex-math-mode)
  (TeX-mode . turn-on-reftex)
  (TeX-mode . TeX-fold-buffer)
  ;; (TeX-mode . flymake-mode)
  :hook
  (TeX-mode . TeX-fold-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (LaTeX-item-indent 0)
  (LaTeX-default-options "12pt")
  (LaTeX-math-abbrev-prefix "²")
  (TeX-source-specials-mode 1)
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-method (quote synctex))
  (TeX-source-correlate-start-server (quote ask))
  (TeX-PDF-mode t)
  (TeX-electric-sub-and-superscript 1)
  (LaTeX-math-list
   '(
     (?\) "right)")
     (?\( "left(")
     (?/ "frac{}{}")
     ))

  ;; Preview
  (preview-auto-cache-preamble t)
  (preview-default-option-list '("displaymath" "graphics" "textmath" "floats"))

  ;; Fold-mode

  ;; Personalize the list of commands to be folded
  (TeX-fold-macro-spec-list
   '(("[f]"
      ("footnote" "marginpar"))
     ("[c]"
      ("citeyear" "citeauthor" "citep" "citet" "cite"))
     ("[l]"
      ("label"))
     ("[r]"
      ("ref" "pageref" "eqref" "footref" "fref" "Fref"))
     ("[i]"
      ("index" "glossary"))
     ("[1]:||*"
      ("item"))
     ("..."
      ("dots"))
     ("(C)"
      ("copyright"))
     ("(R)"
      ("textregistered"))
     ("TM"
      ("texttrademark"))
     (1
      ("part" "chapter" "section" "subsection" "subsubsection" "
paragraph" "subparagraph" "part*" "chapter*" "section*" "
subsection*" "subsubsection*" "paragraph*" "subparagraph*" "emph" "
textit" "textsl" "textmd" "textrm" "textsf" "texttt" "textbf" "
textsc" "textup"))))
  ;; Prevent folding of math to let prettify-symbols do the job
  (TeX-fold-math-spec-list-internal nil)
  (TeX-fold-math-spec-list nil)
  (LaTeX-fold-math-spec-list nil)
  :config
  (setq-default TeX-auto-parse-length 200
		TeX-master nil)
  ;; (if is-mswindows
  ;;     (setq preview-gs-command
  ;; 	    "C:\\Program Files\\gs\\gs10.02.1\\bin\\gswin64c.exe")
  ;;   (setq preview-gs-command "gs"))

  (defun my/tex-compile ()
    "Compile TeX document"
    (interactive)
    (save-buffer)
    (TeX-command-menu "latex")
    )

  ;; Beamer
  (defun my/tex-frame ()
    "Run pdflatex on current frame.  Frame must be declared as an environment."
    (interactive)
    (let (beg)
      (save-excursion
	(search-backward "\\begin{frame}")
	(setq beg (point))
	(forward-char 1)
	(LaTeX-find-matching-end)
	(TeX-pin-region beg (point))
	(cl-letf (( (symbol-function 'TeX-command-query) (lambda (x) "LaTeX")))
	  (TeX-command-region)))))
  :bind
  (:map TeX-mode-map
	("C-c e" . TeX-next-error)
	("M-RET" . latex-insert-item)
	("S-<return>" . my/tex-frame)
	("<f9>" . my/tex-compile)
   )
  )

(use-package adaptive-wrap)

(use-package visual-fill-column
  :init
  (setq visual-fill-column-width 100)
  :config
  (defun my/visual-fill ()
    "Toggle visual fill column and visual line mode."
    (interactive)
    (visual-line-mode 'toggle)
    (visual-fill-column-mode 'toggle)
    (adaptive-wrap-prefix-mode 'toggle))

  (defun my/center-text ()
    "Center text in visual fill column."
    (interactive)
    (setq-local visual-fill-column-center-text t))

  (defun my/uncenter-text ()
    "Uncenter text in visual fill column."
    (interactive)
    (setq-local visual-fill-column-center-text nil))
  :bind ("C-c v" . my/visual-fill)
  :hook
  (TeX-mode      . my/visual-fill)
  (markdown-mode . my/visual-fill)
  (bibtex-mode   . my/visual-fill)
  )

(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq
   ;; Number the candidates (use M-1, M-2 etc to select completions).
   company-show-numbers t
   company-idle-delay 0)
  ;; company configuation from
  ;; <https://github.com/radian-software/radian/blob/develop/emacs/radian.el>
  :bind (;; Replace `completion-at-point' and `complete-symbol' with
         ;; `company-manual-begin'. You might think this could be put
         ;; in the `:bind*' declaration below, but it seems that
         ;; `bind-key*' does not work with remappings.
         ([remap completion-at-point] . company-manual-begin)
         ([remap complete-symbol] . company-manual-begin)

         ;; The following are keybindings that take effect whenever
         ;; the completions menu is visible, even if the user has not
         ;; explicitly interacted with Company.

         :map company-active-map

         ;; Make TAB always complete the current selection. Note that
         ;; <tab> is for windowed Emacs and TAB is for terminal Emacs.
         ("<tab>" . company-complete-selection)
         ("TAB" . company-complete-selection)

         ;; Prevent SPC from ever triggering a completion.
         ("SPC" . nil)

         ;; The following are keybindings that only take effect if the
         ;; user has explicitly interacted with Company.

         :map company-active-map
         :filter (company-explicit-action-p)

         ;; Make RET trigger a completion if and only if the user has
         ;; explicitly interacted with Company. Note that <return> is
         ;; for windowed Emacs and RET is for terminal Emacs.
         ("<return>" . company-complete-selection)
         ("RET" . company-complete-selection)
	 )

  :bind* (;; The default keybinding for `completion-at-point' and
          ;; `complete-symbol' is M-TAB or equivalently C-M-i. Here we
          ;; make sure that no minor modes override this keybinding.
          ("M-TAB" . company-manual-begin))
  )

(use-package company-bibtex)
(use-package company-math)
(use-package company-reftex)

(setq company-backends
      (append
       '((:separate company-bibtex
		    ;; deactivate company-reftex-labels because it is too slow
		    ;; company-reftex-labels
                    company-reftex-citations
		    company-math-symbols-latex
		    company-math-symbols-unicode
		    company-latex-commands))
       company-backends))

(use-package company-box
  :hook (company-mode . company-box-mode)
  :custom
  (company-box-doc-enable nil)
  )

(use-package counsel
  :config
  (counsel-mode)
  )

(use-package ivy
  :demand
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "%d/%d ")
  :config
  (ivy-mode)
  (ivy-configure 'counsel-imenu
    :update-fn 'auto)
  )

(use-package swiper
  :config
  ;; swiper is slow for large files so it is replaced by isearch for large files
  (defun my/search-method-according-to-numlines ()
    "Determine the number of lines of current buffer and chooses a
 search method accordingly."
    (interactive)
    (if (< (count-lines (point-min) (point-max)) 20000)
	(swiper)
      (isearch-forward)
      )
    )
  :bind ("C-s" . my/search-method-according-to-numlines)
  )

(use-package ivy-xref
  :init
  (setq xref-show-definitions-function #'ivy-xref-show-defs)
  )

(use-package ivy-prescient
  :after counsel
  :config
  (ivy-prescient-mode)
  )

(use-package yasnippet
  :config
  (yas-global-mode 1)
  )

(use-package cdlatex
  :hook
  (LaTeX-mode . turn-on-cdlatex)
  ; Slow down company for a better use of cdlatex
  (LaTeX-mode . (lambda ()
		  (make-local-variable 'company-idle-delay)
		  (setq company-idle-delay 0.3)))
  (cdlatex-tab . my-cdlatex-indent-maybe)
  :config
  ;; Prevent cdlatex from defining LaTeX math subscript everywhere
  (define-key cdlatex-mode-map "_" nil)
  ;; Allow tab to be used to indent when the cursor is at the beginning of the
  ;; line
  (defun my-cdlatex-indent-maybe ()
    "Indent in TeX when CDLaTeX is active"
    (when (or (bolp) (looking-back "^[ \t]+"))
      (LaTeX-indent-line)))
  :custom
  ;; (cdlatex-math-symbol-prefix "²")
  (cdlatex-command-alist
	'(("equ*" "Insert equation* env"   "" cdlatex-environment ("equation*") t nil))))

(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :hook
  (org-mode . turn-on-org-cdlatex)
  :custom
  (org-export-with-LaTeX-fragments t)       ; Export LaTeX fragment to HTML
  (org-edit-src-content-indentation 0)
  (org-todo-keywords '((type "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)")))
  (org-tag-alist '(("OFFICE" . ?o) ("COMPUTER" . ?c) ("HOME" . ?h) ("PROJECT" . ?p) ("CALL" . ?a) ("ERRANDS" . ?e) ("TASK" . ?t)))
  (org-confirm-babel-evaluate nil)
  ;; Appareance
  (org-pretty-entities 1) ; equivalent of prettify symbols for org
  ; remove some prettification for sub- and superscripts because it makes editing difficult
  (org-pretty-entities-include-sub-superscripts nil) 
  (org-hide-emphasis-markers t) ; remove markup markers
  (org-ellipsis " [+]")
  (org-highlight-latex-and-related '(native))
  (org-startup-indented t) ; Indent text relative to section
  (org-startup-with-inline-images t)
  (org-startup-with-latex-preview t)
  (org-cycle-inline-images-display t)
  (after! org (plist-put org-format-latex-options :scale 1.5))
  :config
  (org-defkey org-cdlatex-mode-map "²" 'cdlatex-math-symbol)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (R . t)
     (shell . t))))

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

(use-package org-modern
    :hook
    (org-mode . global-org-modern-mode))

(use-package oc
  :ensure nil
  :custom
  (org-cite-global-bibliography
   (list (substitute-in-file-name "${BIBINPUTS}/References.bib"))))

(use-package org-fragtog
  :hook
  (org-mode . org-fragtog-mode))

(use-package ess
  :init
  (require 'ess-site)
  :bind (:map ess-r-mode-map
	 ;; Shortcut for pipe |>
         ("C-S-m" . " |>")
	 ;; Shortcut for pipe %>%
	 ("C-%"   . " %>%")
	 ;; Shortcut for assign <-
	 ("M--"   . ess-insert-assign)
	 ("<f9>"  . my-run-rscript-on-current-buffer-file)
         :map inferior-ess-r-mode-map
         ("C-S-m" . " |>")
         ("C-%"   . " %>%")
	 ("M--"   . ess-insert-assign)
	 :map inferior-ess-mode-map
	 ("<home>" . comint-bol))
  :custom
  (ess-roxy-str "#'")
  (ess-roxy-template-alist
   '(("description" . ".. content for \\description{} (no empty lines) ..")
     ("details" . ".. content for \\details{} ..")
     ("param" . "")
     ("return" . "")))
  (ess-nuke-trailing-whitespace-p t)
  (ess-assign-list '(" <-" " <<- " " = " " -> " " ->> "))
  (ess-style 'RStudio)  ; Set code indentation
  (ess-ask-for-ess-directory nil) ; Do not ask what is the project directory
  ;; Following the "source is real" philosophy put forward by ESS, one should
  ;; not need the command history and should not save the workspace at the end
  ;; of an R session. Hence, both options are disabled here.
  (inferior-R-args "--no-restore-history --no-save ")
  :config
  ;; Background jobs for R as in RStudio
  (defun my-run-rscript (arg title)
    "Run Rscript in a compile buffer"
    (let*
	((is-file (file-exists-p arg))
	 (working-directory
	  (if is-file default-directory (file-name-directory arg)))
	 ;; Generate a unique compilation buffer name
	 (combuf-name (format "*Rscript-%s*" title))
	 ;; Get the existing compilation buffer, if any
         (combuf (get-buffer combuf-name))
         (compilation-buffer-name-function
	  (lambda (_) combuf-name)) ; Set the compilation buffer name function
	 ;; Automatically save modified buffers without asking
         (compilation-ask-about-save nil))
      (when combuf
	(kill-buffer combuf)) ; Kill the existing compilation buffer
      ;; Create a new compilation buffer
      (setq combuf (get-buffer-create combuf-name))
      (with-current-buffer combuf
	;; Set the default directory of the compilation buffer
	(setq default-directory working-directory)
	;; Delete any existing content in the compilation buffer
	(delete-region (point-min) (point-max))
	(compilation-mode)) ; Enable compilation mode in the buffer
      (compile (format "Rscript %s" arg)) ; Execute the R script using Rscript
      (with-current-buffer combuf
	;; Rename the compilation buffer to its final name
	(rename-buffer combuf-name))))

  (defun my-run-rscript-on-current-buffer-file ()
    "Run Rscript on the file associated to the current buffer"
    (interactive)
    (let ((filename (buffer-file-name)))
      (when filename
	(my-run-rscript filename (file-name-base filename)))))

  (defun my-run-rscript-on-file ()
    "Run Rscript on the file associated to a file"
    (interactive)
    (let ((filename (read-file-name "R script: ")))
      (my-run-rscript filename (file-name-base filename))))

  (defun my-inferior-ess-init ()
    "Workaround for https://github.com/emacs-ess/ESS/issues/1193"
    (add-hook 'comint-preoutput-filter-functions #'xterm-color-filter -90 t)
    (setq-local ansi-color-for-comint-mode nil)
    (smartparens-mode 1))
  :hook
  (inferior-ess-mode . my-inferior-ess-init))

(use-package rutils
  :defer t
  :after ess)



;; Org-Roam basic configuration


(use-package org-roam
  :ensure t
  :demand t
  :init
  (setq org-roam-v2-ack t)
  (setq org-roam-node-display-template "${tags:50} ${title:100}")
  :custom
  (org-roam-directory "~/OneDrive/Documents/RoamNotes")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("c" "code commandes" plain
      (file "~/OneDrive/Documents/RoamNotes/Templates/code-commandes-template.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("p" "projets" plain
      (file "~/OneDrive/Documents/RoamNotes/Templates/projects-templates.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     )
   )
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n#+filetags: :Project:"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
	 ("C-c n o" . org-id-get-create)
	 ("C-c n A" . org-roam-alias-add)
	 ("C-c n t" . org-roam-tag-add)
	 ("C-c n I" . org-roam-node-insert-immediate)
         ("C-c n p" . my/org-roam-find-project)
         ("C-c n T" . my/org-roam-capture-task)
         ("C-c n b" . my/org-roam-capture-inbox)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
(org-roam-setup)
(require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))


(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(defun my/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))

(defun my/org-roam-list-notes-by-tag (tag-name)
  (mapcar #'org-roam-node-file
          (seq-filter
           (my/org-roam-filter-by-tag tag-name)
           (org-roam-node-list))))

(defun my/org-roam-refresh-agenda-list ()
  (interactive)
  (setq org-agenda-files (my/org-roam-list-notes-by-tag "Project")))

;; Build the agenda list the first time for the session
(my/org-roam-refresh-agenda-list)

(defun my/org-roam-project-finalize-hook ()
  "Adds the captured project file to `org-agenda-files' if the
capture was not aborted."
  ;; Remove the hook since it was added temporarily
  (remove-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)

  ;; Add project file to the agenda list if the capture was confirmed
  (unless org-note-abort
    (with-current-buffer (org-capture-get :buffer)
      (add-to-list 'org-agenda-files (buffer-file-name)))))

(defun my/org-roam-find-project ()
  (interactive)
  ;; Add the project file to the agenda after capture is finished
  (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)

  ;; Select a project file to open, creating it if necessary
  (org-roam-node-find
   nil
   nil
   (my/org-roam-filter-by-tag "Project")
   nil
   :templates
   '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
      :unnarrowed t))))

(defun my/org-roam-find-article ()
  (interactive)
  ;; Add the project file to the agenda after capture is finished
  (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)

  ;; Select a project file to open, creating it if necessary
  (org-roam-node-find
   nil
   nil
   (my/org-roam-filter-by-tag "article")
   nil
   :templates
   '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: article")
      :unnarrowed t))))


(defun my/org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture- :node (org-roam-node-create)
                     :templates '(("i" "inbox" plain "* %?"
                                  :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))

(defun my/org-roam-capture-task ()
  (interactive)
  ;; Add the project file to the agenda after capture is finished
  (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)

  ;; Capture the new task, creating the project file if necessary
  (org-roam-capture- :node (org-roam-node-read
                            nil
                            (my/org-roam-filter-by-tag "Project"))
                     :templates '(("p" "project" plain "** TODO %?"
                                   :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                                          "#+title: ${title}\n#+category: ${title}\n#+filetags: Project"
                                                          ("Tasks"))))))

(defun my/org-roam-copy-todo-to-today ()
  (interactive)
  (let ((org-refile-keep t) ;; Set this to nil to delete the original!
        (org-roam-dailies-capture-templates
          '(("t" "tasks" entry "%?"
             :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
        (org-after-refile-insert-hook #'save-buffer)
        today-file
        pos)
    (save-window-excursion
      (org-roam-dailies--capture (current-time) t)
      (setq today-file (buffer-file-name))
      (setq pos (point)))

    ;; Only refile if the target file is different than the current file
    (unless (equal (file-truename today-file)
                   (file-truename (buffer-file-name)))
      (org-refile nil nil (list "Tasks" today-file nil pos)))))

(add-to-list 'org-after-todo-state-change-hook
             (lambda ()
               (when (equal org-state "DONE")
                 (my/org-roam-copy-todo-to-today))))


(use-package magit
  :init
  ;; this binds `magit-project-status' to `project-prefix-map' when project.el is loaded.
  (require 'magit-extras)
  :bind ("C-x g" . magit-status)
  :custom
  (magit-diff-refine-hunk (quote all))
  :config
  ; Do not diff when committing
  (remove-hook 'server-switch-hook 'magit-commit-diff)
  (remove-hook 'with-editor-filter-visit-hook 'magit-commit-diff))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor-type 'bar)
 '(keyboard-coding-system 'utf-8)
 '(org-agenda-files
   '("c:/Users/romai/OneDrive/Documents/RoamNotes/20240423160746-haute_couture_cepii.org"))
 '(org-format-latex-options
   '(:foreground default :background default :scale 1.75 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(package-selected-packages
   '(magit org-roam rutils ess org org-fragtog org-modern org-appear cdlatex yasnippet ivy-prescient ivy-xref counsel company-box company-reftex company-math company-bibtex company visual-fill-column adaptive-wrap auctex doom-themes doom-modeline)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrains Mono" :foundry "outline" :slant normal :weight regular :height 120 :width normal)))))

