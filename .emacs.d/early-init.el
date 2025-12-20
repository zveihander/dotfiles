(setq package-enable-at-startup nil)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(add-to-list 'default-frame-alist
             '(font . "MonoLisa-12"))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq read-process-output-max (* 1024 1024))

(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors nil
        native-comp-warning-on-missing-source nil)

  (setq native-comp-deferred-compilation t))

(setq site-run-file nil)

(setq inhibit-compacting-font-caches t)
