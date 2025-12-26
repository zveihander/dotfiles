(setq package-enable-at-startup nil)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(undecorated . t) default-frame-alist)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(push '(font . "MonoLisa-12") default-frame-alist)

(setq gc-cons-threshold most-positive-fixnum)

(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq read-process-output-max (* 4 1024 1024))

(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors nil
        native-comp-warning-on-missing-source nil)

  (setq native-comp-deferred-compilation t))

(setq inhibit-compacting-font-caches t)

(setq inhibit-redisplay t)
(add-hook 'emacs-startup-hook (lambda () (setq inhibit-redisplay nil)))

(setq bidi-inhibit-bpa t)
(setq-default bidi-paragraph-direction 'left-to-right)
