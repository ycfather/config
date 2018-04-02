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

;;set font family 
;;(set-default-font "monokai-14")

(require 'package)
    (add-to-list 'package-archives
                 '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; (load-theme 'monokai t)
(load-theme 'atom-one-dark t)
;; (load-theme 'solarized-light t)

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
            (local-set-key (kbd "C-c C-f") 'gofmt)
            (local-set-key (kbd "C-c C-k") 'godoc)
            (setq tab-width 4)
            (setq indent-tabs-mode nil)))

(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

;; (add-hook 'go-mode-hook 'company-mode)
;; (add-hook 'go-mode-hook
;;          (lambda ()
;;            (set (make-local-variable 'company-backends) '(company-go))
;;            (company-mode)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (solarized-theme atom-one-dark-theme auto-complete go-autocomplete auctex lua-mode python-mode protobuf-mode yasnippet json-mode vue-html-mode vue-mode nginx-mode go-mode monokai-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
