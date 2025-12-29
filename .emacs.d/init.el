;; Performance

;; I read somewhere that this is beneficial
(require 'server)
(unless (server-running-p)
  (server-start))

;; Reset GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.15)))

;; Options

(setq user-full-name "Evan Alvarez")
(setq user-mail-address "lwq7e50ygv8f1w@tuta.com")

;; Allow for shorter responses: "y" for yes and "n" for no.
(setq read-answer-short t)
(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))

;; Allow nested minibuffers
(setq enable-recursive-minibuffers t)

;; Show matching parentheses immediately
(setq show-paren-delay 0
      show-paren-highlight-openparen t
      show-paren-when-point-inside-paren t
      show-paren-when-point-in-periphery t)
(show-paren-mode 1)

;; Save place in files between sessions
(save-place-mode 1)

;; Disable auto-adding a new line at the bottom when scrolling.
(setq next-line-add-newlines nil)

;; Compilation stuff
(setq compilation-ask-about-save nil
      compilation-always-kill t
      compilation-scroll-output 'first-error)

;; Avoid backups or lockfiles to prevent creating world-readable copies of files
(setq create-lockfiles nil)
(setq make-backup-files nil)

;; Line numbers configuration
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-width-start t)
(global-display-line-numbers-mode 1)
(dolist (hook '(org-mode-hook term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook hook #'display-line-numbers-mode -1))

;; Better scrolling
(setq scroll-conservatively 101)
(setq scroll-margin 3)
(setq scroll-preserve-screen-position t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)

;; Remove duplicates from the kill ring to reduce clutter
(setq kill-do-not-save-duplicates t)

;; Delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Indent first, then complete on subsequent TABs
(setq tab-always-indent 'complete)

;; Wrapping and fill columns
(setq-default word-wrap t)
(setq-default fill-column 80)

;; Auto-revert files when changed on disk
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Basic editing modes
(electric-pair-mode 1)
(delete-selection-mode 1)

;; Disable the blinking cursor
(when (bound-and-true-p blink-cursor-mode)
  (blink-cursor-mode -1))

;; Don't blink the paren matching the one at point, it's too distracting.
(setq blink-matching-paren nil)

;; Recent files
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; No backup or lock files
(setq auto-save-default nil)

;; Don't confirm when creating new files/buffers
(setq confirm-nonexistent-file-or-buffer nil)

;; Follow symlinks without asking
(setq vc-follow-symlinks t)

;; Refresh dired buffers automatically
(setq dired-auto-revert-buffer t)

;; Spell checking with Flyspell
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

;; Make dired open files in their default application
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "W")
              (lambda ()
                (interactive)
                (let ((file (dired-get-file-for-visit)))
                  (start-process "external-app" nil "xdg-open" file)))))


;; Enable hl-line-mode so you can see where your cursor is
(setq global-hl-line-mode t)
(setq hl-line-mode t)

;; Eliminate delay before highlighting search matches
(setq lazy-highlight-initial-delay 0)

;; Makes Emacs omit the load average information from the mode line.
(setq display-time-default-load-average nil)

;; Do not notify the user each time Python tries to guess the indentation offset
(setq python-indent-guess-indent-offset-verbose nil)

(setq sh-indent-after-continuation 'always)

;; Dired stuff
(setq dired-free-space nil
      dired-dwim-target t
      dired-deletion-confirmer 'y-or-n-p
      dired-filter-verbose nil
      dired-recursive-deletes 'top
      dired-recursive-copies 'always
      dired-vc-rename-file t
      dired-create-destination-dirs 'ask
      ;; Suppress Dired buffer kill prompt for deleted dirs
      dired-clean-confirm-killing-deleted-buffers nil)

;; Packages

(require 'package)

(setq package-archives '(("elpa". "https://elpa.gnu.org/packages/")
			             ("org". "https://orgmode.org/elpa/")
			             ("melpa". "https://melpa.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(setq package-vc-allow-build-commands t)

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-medium t))

(use-package tab-bar
  :ensure nil
  :config
  (tab-bar-mode 1)
  (setq tab-bar-show 1)
  (setq tab-bar-close-button-show nil)
  (setq tab-bar-new-button-show nil)
  (setq tab-bar-new-tab-choice "*scratch*")
  (setq tab-bar-new-tab-to 'rightmost)
  (setq tab-bar-tab-hints nil)
  (setq tab-bar-separator "")
  (setq tab-bar-auto-width nil)

  (set-face-attribute 'tab-bar nil
                      :background "#282828"
                      :foreground "#ebdbb2")

  (set-face-attribute 'tab-bar-tab nil
                      :background "#504945"
                      :foreground "#ebdbb2"
                      :weight 'bold
                      )

  (set-face-attribute 'tab-bar-tab-inactive nil
                      :background "#3c3836"
                      :foreground "#a89984"
                      :weight 'normal
                      )

  (setq tab-bar-tab-name-format-function
        (lambda (tab i)
          (let* ((current-p (eq (car tab) 'current-tab))
                 (name (alist-get 'name tab))
                 (face (if current-p 'tab-bar-tab 'tab-bar-tab-inactive)))
            (propertize (concat "  " name "  ") 'face face))))
  )

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".git" ".projectile"))

  :config
  (when (file-directory-p "~/Code")
    (dolist (dir (directory-files "~/Code" t "^[^.]"))
      (when (and (file-directory-p dir)
                 (or (file-exists-p (expand-file-name ".git" dir))
                     (file-exists-p (expand-file-name ".projectile" dir))))
        (project-remember-project (project-current nil dir)))))
  (setq project-switch-commands
        '((project-find-file "Find file")
          (project-dired "Dired")
          (consult-ripgrep "Ripgrep")
          (magit-project-status "Magit")))
  :bind (
         ("C-c p p" . project-switch-project)
         ("C-c p f" . project-find-file)
         ("C-c p b" . project-switch-to-buffer)
         ("C-c p d" . project-dired)
         ("C-c p c" . project-compile)))

(use-package icomplete
  :ensure nil
  :init
  (fido-vertical-mode 1)

  :custom
  (icomplete-show-matches-on-no-input t)

  (icomplete-prospects-height 10)

  (icomplete-compute-delay 0)

  (completion-category-overrides '((file (styles basic partial-completion))))

  (completions-format 'one-column)

  :bind (:map icomplete-minibuffer-map
              ("C-n" . icomplete-forward-completions)
              ("C-p" . icomplete-backward-completions)
              ("TAB" . icomplete-force-complete-and-exit)
              ("RET" . exit-minibuffer)))

(use-package consult
  :bind (
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s r" . consult-ripgrep)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-g o" . consult-outline)
         ("C-x C-r" . consult-recent-file)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("C-x r b" . consult-bookmark))
  :custom
  (consult-preview-key 'any)
  (consult-narrow-key "<")
  :config
  (setq orderless-style-dispatchers
        '(+orderless-consult-dispatch orderless-affix-dispatch))
  (setq consult-project-function #'consult--default-project-function)

  (defun consult-project-switch-project ()
    "Switch to a project and run consult-buffer."
    (interactive)
    (let ((project (project-prompt-project-dir)))
      (project-switch-project project)
      (consult-buffer)))

  (global-set-key (kbd "C-c p p") #'consult-project-switch-project))

(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1))

(use-package eglot
  :ensure nil
  :hook ((c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (sh-mode . eglot-ensure)
         (markdown-mode . eglot-ensure)
         (typst-ts-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure)
         (svelte-mode . eglot-ensure))
  :config
  (add-hook 'before-save-hook
            (lambda ()
              (when (bound-and-true-p eglot--managed-mode)
                (eglot-format-buffer))))

  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode) . ("clangd"
                                      "--background-index"
                                      "--clang-tidy"
                                      "--completion-style=detailed"
                                      "--header-insertion=iwyu"
                                      "--function-arg-placeholders=0"
                                      "--pch-storage=memory"
                                      "--j=6")))

  (add-to-list 'eglot-server-programs
               '(typst-ts-mode . ("tinymist")))

  (add-to-list 'eglot-server-programs
               '(markdown-mode . ("marksman")))

  (add-to-list 'eglot-server-programs
               '(python-mode . ("rass" "python")))

  (add-to-list 'eglot-server-programs
               '((typescript-ts-mode, tsx-ts-mode) . ("rass" "typescript")))

  (add-to-list 'eglot-server-programs
               '(svelte-mode . ("rass" "svelte")))

  (setq eglot-events-buffer-size 250)
  (setq eglot-sync-connect 0)
  (setq eglot-autoshutdown t)
  (setq jsonrpc-event-hook nil)
  (setq eglot-events-buffer-config '(:size 0 :format short)))

(use-package corfu
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.05)
  (corfu-auto-prefix 2)
  (corfu-preselect-first nil)
  (corfu-on-exact-match nil)
  (corfu-cycle t)
  (corfu-popupinfo-mode 1)
  (corfu-echo-mode 1)
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ("C-n"    . corfu-next)
              ("C-p"    . corfu-previous)
              ("M-p"    . corfu-popupinfo-scroll-down)
              ("M-n"    . corfu-popupinfo-scroll-up)))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (setq-default eglot-workspace-configuration
                '((python (maxCompletions . 200)))))

(setq completion-category-overrides
      '((file (styles basic partial-completion))))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides
   '((file (styles . (partial-completion)))))
  (completion-pcm-leading-wildcard t)

  (orderless-style-dispatchers '(orderless-affix-dispatch))
  (orderless-component-separator #'orderless-escapable-split-on-space))

(use-package multiple-cursors
  :bind (
         ("C-S-c C-S-c" . 'mc/edit-lines)
         ("C->" . 'mc/mark-next-like-this)
         ("C-<" . 'mc/mark-previous-like-this)
         ("C-c C-<" . 'mc/mark-all-like-this)
         ("C-\"" . 'mc/skip-to-next-like-this)
         ("C-:" . 'mc/skip-to-previous-like-this)
         ("C-c m u"     . mc/unmark-next-like-this)
         ("C-c m U"     . mc/unmark-previous-like-this)))

(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'indent-region-advice)
(advice-add 'move-text-down :after 'indent-region-advice)

(use-package move-text
  :bind(
        ("M-P" . move-text-up)
        ("M-N" . move-text-down))
  )

(use-package yasnippet
  :config
  (yas-global-mode 1)
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets"))
  :bind (("C-c y n" . yas-new-snippet)
         ("C-c y v" . yas-visit-snippet-file)))

(use-package org
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-indent-mode))
  :custom
  (org-directory "~/notes")
  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-agenda-files
   (directory-files-recursively org-directory "\\.org$"))

  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-startup-folded 'content)
  (org-startup-indented t)
  (org-auto-align-tags t)

  (org-startup-with-inline-images t)
  (org-image-actual-width '(300))

  (org-file-apps
   '((auto-mode . emacs)
     (directory . emacs)
     ("\\.pdf\\'" . "zathura %s")
     ("\\.epub\\'" . "zathura %s")
     (t . "xdg-open %s")))

  (org-return-follows-link t)
  (org-special-ctrl-a/e t)
  (org-special-ctrl-k t)
  (org-ctrl-k-protect-subtree t)

  (org-todo-keywords
   '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (org-todo-keyword-faces
   '(("TODO" . org-warning)
     ("WAITING" . (:foreground "yellow" :weight bold))
     ("DONE" . org-done)
     ("CANCELLED" . (:foreground "gray" :strike-through t))))

  (org-priority-faces
   '((?A . (:foreground "red" :weight bold))
     (?B . (:foreground "orange"))
     (?C . (:foreground "yellow"))))

  (org-agenda-start-with-log-mode t)
  (org-log-done 'time)
  (org-log-into-drawer t)

  (org-refile-targets
   '((nil :maxlevel . 3)
     (org-agenda-files :maxlevel . 3)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-refile-allow-creating-parent-nodes 'confirm)

  (org-startup-with-latex-preview t)
  (org-preview-latex-default-process 'dvipng)

  (org-capture-templates
   '(
     ("t" "Todo" entry
      (file+headline "~/notes/todo.org" "Inbox")
      "* TODO %^{Task}\n DEADLINE: %^{Deadline}t\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?")

     ("e" "Event" entry
      (file+headline "~/notes/calendar.org" "Events")
      "* %^{Event}\n%^{SCHEDULED}T\n:PROPERTIES:\n:CREATED: %U\n:CONTACT: %(org-capture-ref-link \"~/notes/contacts.org\")\n:END:\n%?")

     ("c" "Contact" entry
      (file+headline "~/notes/contacts.org" "Inbox")
      "* %^{Name}

:PROPERTIES:
:CREATED: %U
:RELATIONSHIP: %^{Relationship}
:EMAIL: %^{Email}
:PHONE: %^{Phone}
:BIRTHDAY: %^{Birthday +1y}u
:LOCATION: %^{Address}
:END:
*** Notes
%?")

     ("h" "Homework" entry (file+headline "~/notes/school/f2025.org" "Homework")
      "* TODO %^{Assignment} :%^{Subject}:\n  DEADLINE: %^{Due date}t\n  :PROPERTIES:\n  :COURSE: %^{Course name}\n  :POINTS: %^{Points}\n  :END:\n  \n  %?\n  \n  Added: %U"
      :empty-lines 1)

     ("E" "Exam/Quiz" entry (file+headline "~/notes/school/f2025.org" "Exams")
      "* TODO Study for %^{Exam name} :exam:%^{Subject}:\n  SCHEDULED: %^{Study date}t DEADLINE: %^{Exam date}t\n  :PROPERTIES:\n  :COURSE: %^{Course name}\n  :CHAPTERS: %^{Chapters/Topics}\n  :END:\n \n** Exam Details\n %?\n \n** Topics to Review\n - [ ] \n   \n**  Added: %U"
      :empty-lines 1)

     ("S" "Study Session" entry (file+headline "~/notes/school/f2025.org" "Study")
      "* %^{Subject} - %^{Topic}\n  SCHEDULED: %T\n  :PROPERTIES:\n  :END:\n  \n** Learned\n - [ ]  \n** Linked Concepts\n - "
      :clock-in t
      :clock-resume t
      :empty-lines 1)
     ))

  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-edit-src-content-indentation 0)
  (org-src-window-setup 'current-window)

  (org-confirm-babel-evaluate nil)

  (org-babel-C-compiler "gcc")
  (org-babel-C++-compiler "g++"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (C . t)
   (shell . t)
   (python . t)))

(defun org-capture-ref-link (file)
  "Create a link to a contact in contacts.org"
  (let* ((headlines (org-map-entries
                     (lambda ()
                       (cons (org-get-heading t t t t)
                             (org-id-get-create)))
                     t
                     (list file)))
         (contact (completing-read "Contact: "
                                   (mapcar #'car headlines)))
         (id (cdr (assoc contact headlines))))
    (format "[[id:%s][%s]]" id contact)))

(defun org-insert-contact-link ()
  "Insert a link to a contact in contacts.org"
  (interactive)
  (let* ((file "~/notes/contacts.org")
         (headlines (with-current-buffer (find-file-noselect file)
                      (org-map-entries
                       (lambda ()
                         (cons (org-get-heading t t t t)
                               (org-id-get-create)))
                       t)))
         (contact (completing-read "Contact: "
                                   (mapcar #'car headlines)))
         (id (cdr (assoc contact headlines))))
    (insert (format "[[id:%s][%s]]" id contact))))

(global-set-key (kbd "C-c n C") #'org-insert-contact-link)

(use-package org-cliplink
  :bind ("C-c C-l" . org-cliplink))

(use-package org-roam
  :after org
  :defer
  :commands (org-roam-node-find org-roam-capture org-roam-db-sync)
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today)
         ("C-c n d" . org-roam-dailies-goto-today))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :custom
  (org-roam-directory "~/notes/roam")
  (org-roam-completion-everywhere t)
  (org-roam-database-connector 'sqlite-builtin)
  (org-roam-capture-templates
   '(
     ("s" "School" plain
      "\n\n* Notes\n "
      :target (file+head
               "school/f2025/%^{Course shortname}-U%^{Unit number}L%^{Lesson number}-${slug}.org"
               "#+title: %^{Course shortname}-U%^{Unit number}L%^{Lesson number}-${title}\n#+date: %U\n#+filetags: :school:%^{Course shortname}:\n:PROPERTIES:\n:COURSE: %^{Course full name}\n:TEACHER: %^{Teacher}\n:UNIT: %^{Unit number}\n:LESSON: %^{Lesson number}\n:CREATED: %U\n:MODIFIED: %U\n:END:\n\n")
      :unnarrowed t)

     ("l" "Literature" plain
      "Notes\n %? \n\n* References\n  - "
      :target (file+head "literature/${slug}.org"
                         "#+title: ${title}\n#+date: %U\n#+filetags: :book:\n:PROPERTIES:\n:AUTHOR: %^{Author}\n:SOURCE: \n:CREATED: %U\n:MODIFIED: %U\n:END:\n\n")
      :unnarrowed t)

     ("z" "Zettel" plain
      "%?\n\n* Related\n  - \n\n* References\n  - "
      :target (file+head "zettel/${slug}.org"
                         "#+title: ${title}\n#+date: %U\n#+filetags: :seed:\n:PROPERTIES:\n:CREATED: %U\n:MODIFIED: %U\n:END:\n\n")
      :unnarrowed t)

     ("M" "Map of Content (MOC)" plain
      "\n\n* Notes\n %? \n\n* Resources\n  - "
      :target (file+head "moc/${slug}.org"
                         "#+title: MOC - ${title}\n#+date: %U\n#+filetags: :moc:\n:PROPERTIES:\n:TYPE: MOC\n:CREATED: %U\n:MODIFIED: %U\n:END:\n\n")
      :unnarrowed t)
     ))

  (org-roam-dailies-capture-templates
   '(
     ("d" "default" entry
      "* %<%H:%M> %?"
      :target (file+head "%<%Y-%m-%d>.org"
                         ":PROPERTIES:\n:ID: %(org-id-new)\n:END:#+title: %<%B %d, %Y>\n#+date: %U\n#+filetags: :daily:\n\n* Scratch Pad\n - "))
     ))

  :config
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

;; Languages

;; Elisp
(use-package elisp-mode
  :ensure nil
  :hook ((emacs-lisp-mode . (lambda ()
                              (eldoc-mode 1)
                              (electric-pair-mode 1)))
         (emacs-lisp-mode . (lambda ()
                              (add-hook 'before-save-hook
                                        (lambda ()
                                          (when (eq major-mode 'emacs-lisp-mode)
                                            (indent-region (point-min) (point-max))))
                                        nil t))))

  :bind (:map emacs-lisp-mode-map
              ("C-c C-c" . eval-defun)
              ("C-c C-k" . eval-buffer)))

;; Rust
(use-package rust-mode
  :mode "\\.rs\\'")

;; Markdown
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (setq markdown-command "multimarkdown")
  (setq markdown-display-remote-images t))

;; Typst
(use-package typst-ts-mode
  :vc (:url "https://codeberg.org/meow_king/typst-ts-mode.git")
  :mode "\\.typ\\'"
  :config
  (keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu))

;; Bash/Shell
(add-hook 'sh-mode-hook
          (lambda ()
            (setq sh-basic-offset 2
                  sh-indentation 2)))

;; Python
(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq python-indent-offset 4)
  (setq python-shell-interpreter "python3"))

;; TypeScript
(use-package typescript-ts-mode
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :config
  (setq typescript-ts-mode-indent-offset 2))

;; Svelte
(use-package svelte-mode
  :mode "\\.svelte\\'"
  :config
  (setq svelte-basic-offset 2))

;; JSON
(use-package json-mode
  :mode "\\.json\\'")

;; Prettier
(use-package prettier-js
  :hook ((typescript-mode . prettier-js-mode)
         (svelte-mode . prettier-js-mode))
  :config
  (setq prettier-js-args '("--plugin" "prettier-plugin-svelte"
                           "--trailing-comma" "es5"
                           "--single-quote" "true"
                           "--print-width" "100"
                           "--tab-width" "2")))

;; Treesitter

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")
        (typst "https://github.com/uben0/tree-sitter-typst")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")))

;; Auto-install missing tree-sitter parsers

(defun rc/install-treesit-grammars ()
  "Install tree-sitter grammars if not already installed."
  (interactive)
  (let ((missing-grammars
         (seq-filter (lambda (lang)
                       (not (treesit-language-available-p lang)))
                     '(bash c cpp rust toml markdown json yaml typst python typescript tsx javascript))))
    (when missing-grammars
      (dolist (lang missing-grammars)
        (message "Installing tree-sitter grammar for %s..." lang)
        (treesit-install-language-grammar lang)))))

(when (and (treesit-available-p)
           (not (treesit-language-available-p 'rust)))
  (run-with-idle-timer 120 nil #'rc/install-treesit-grammars))

;; Keybindings

;; Disabled arrow keys for habit building
(bind-key* "<up>" 'ignore)
(bind-key* "<d1own>" 'ignore)
(bind-key* "<left>" 'ignore)
(bind-key* "<right>" 'ignore)

(global-set-key (kbd "C-c e r") #'eglot-rename)
(global-set-key (kbd "C-c e a") #'eglot-code-actions)
(global-set-key (kbd "C-c e e") #'flymake-goto-next-error)
(global-set-key (kbd "C-c e E") #'flymake-goto-next-error)

(global-set-key (kbd "C-c d c") #'compile)

(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)

(global-set-key (kbd "C-c n u") #'org-roam-ui-mode)

(global-set-key (kbd "C-x t t") 'tab-bar-new-tab)
(global-set-key (kbd "C-x t n") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "C-x t p") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "C-x t c") 'tab-bar-close-tab)
(global-set-key (kbd "C-x t r") 'tab-bar-rename-tab)

(defun rc/duplicate-line ()
  "Duplicate current line (stolen from tsoding)"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)

(defun rc/mark-line ()
  "Mark the current line."
  (interactive)
  (if (and (region-active-p)
           (eq last-command 'rc/mark-line))
      (forward-line 1)
    (beginning-of-line)
    (set-mark (point))
    (forward-line 1)))

(global-set-key (kbd "C-S-l") #'rc/mark-line)

(defun rc/consult-org-roam-search ()
  "Search org-roam directory using consult-ripgrep."
  (interactive)
  (consult-ripgrep org-roam-directory))

(global-set-key (kbd "C-c n s") #'rc/consult-org-roam-search)

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(global-set-key (kbd "C-c n I") #'org-roam-node-insert-immediate)

(defun rc/indent-right-or-region ()
  "Indent right — current line or region."
  (interactive)
  (let ((beg (if (use-region-p) (region-beginning) (line-beginning-position)))
        (end (if (use-region-p) (region-end)       (line-end-position))))
    (indent-rigidly beg end tab-width)
    (when (use-region-p)
      (setq deactivate-mark nil))))

(defun rc/indent-left-or-region ()
  "Indent left — current line or region."
  (interactive)
  (let ((beg (if (use-region-p) (region-beginning) (line-beginning-position)))
        (end (if (use-region-p) (region-end)       (line-end-position))))
    (indent-rigidly beg end (- tab-width))
    (when (use-region-p)
      (setq deactivate-mark nil))))

(global-set-key (kbd "C->") #'rc/indent-right-or-region)
(global-set-key (kbd "C-<") #'rc/indent-left-or-region)

;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cape consult corfu gruvbox-theme json-mode magit markdown-mode move-text
          multiple-cursors orderless org-cliplink org-roam-ui prettier-js
          rust-mode svelte-mode typst-ts-mode yasnippet))
 '(package-vc-selected-packages
   '((typst-ts-mode :url "https://codeberg.org/meow_king/typst-ts-mode.git"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
