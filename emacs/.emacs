(setq column-number-mode t)
(setq make-backup-files nil)

(setq require-final-newline t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;; (setq tab-width 4 indent-tabs-mode nil)
(setq c-basic-offset 4)
(setq default-tab-width 4)

(global-linum-mode 1)
(setq linum-format "%4d \u2502 ")

(require 'package)
    (add-to-list 'package-archives
                 '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(elpy-enable)

;;(load-theme 'solarized-dark t)
(load-theme 'monokai t)
;;(load-theme 'material t)

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
            (local-set-key (kbd "C-c C-f") 'gofmt)
            (local-set-key (kbd "C-c C-k") 'godoc)
            (setq tab-width 4)
            (setq indent-tabs-mode nil)))

(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends) '(company-go))
            (company-mode)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (async git-commit magit-popup with-editor magit find-file-in-project highlight-indentation ivy pyvenv s yasnippet elpy json-snatcher json-mode json-reformat protobuf-mode markdown-mode company dash nginx-mode yaml-mode company-go go-mode solarized-theme monokai-theme molokai-theme lua-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
