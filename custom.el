(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor-type 'bar)
 '(ess-R-font-lock-keywords
   '((ess-R-fl-keyword:keywords . t)
     (ess-R-fl-keyword:constants . t)
     (ess-R-fl-keyword:modifiers . t)
     (ess-R-fl-keyword:fun-defs . t)
     (ess-R-fl-keyword:assign-ops . t)
     (ess-R-fl-keyword:%op% . t)
     (ess-fl-keyword:fun-calls . t)
     (ess-fl-keyword:numbers)
     (ess-fl-keyword:operators)
     (ess-fl-keyword:delimiters)
     (ess-fl-keyword:=)
     (ess-R-fl-keyword:F&T)))
 '(global-org-modern-mode t)
 '(highlight-indent-guides-auto-character-face-perc 100)
 '(highlight-indent-guides-auto-enabled t)
 '(highlight-indent-guides-auto-even-face-perc 15)
 '(highlight-indent-guides-auto-odd-face-perc 15)
 '(highlight-indent-guides-method 'bitmap)
 '(keyboard-coding-system 'utf-8)
 '(org-agenda-files
   '("d:/capliez/Documents/RoamNotes/20240423160746-haute_couture_cepii.org" "d:/capliez/Documents/RoamNotes/20240429153955-sport.org" "d:/capliez/Documents/RoamNotes/20240423191949-vie.org" "d:/capliez/Documents/RoamNotes/20240429164618-emacs_improve.org" "d:/capliez/Documents/RoamNotes/20240501165908-theatre.org" "d:/capliez/Documents/RoamNotes/20240430092556-economie_mondiale.org"))
 '(org-format-latex-options
   '(:foreground default :background default :scale 1.75 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-modern-checkbox '((88 . "☑") (45 . "□–") (32 . "□")))
 '(org-modern-star "◉○◈◇✳")
 '(org-priority-lowest 68)
 '(org-return-follows-link t)
 '(package-selected-packages
   '(indent-guide highlight-indent-guides copilot quelpa-use-package quelpa diff-hl magit-delta outline-minor-faces bicycle org-roam-ui rainbow-delimiters ligature nerd-icons-completion nerd-icons-ibuffer nerd-icons-ivy-rich nerd-icons-dired rainbow-mode ivy-rich magit org-roam rutils ess org org-fragtog org-modern org-appear cdlatex yasnippet ivy-prescient ivy-xref counsel company-box company-reftex company-math company-bibtex company visual-fill-column adaptive-wrap auctex doom-themes doom-modeline))
 '(safe-local-variable-values
   '((eval add-hook 'after-save-hook
	   (lambda nil
	     (if
		 (y-or-n-p "Tangle?")
		 (org-babel-tangle)))
	   nil t)
     (eval add-hook 'after-save-hook
	   (lambda nil
	     (if
		 (y-or-n-p "Reload?")
		 (load-file user-init-file)))
	   nil t))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrains Mono" :foundry "outline" :slant normal :weight regular :height 120 :width normal)))))
