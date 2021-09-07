(require 'evil)
(evil-mode 1)

(load-theme 'gruvbox t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(setq auto-mode-alist
      (append
        '(("\\.agda\\'" . agda2-mode)
          ("\\.lagda.md\\'" . agda2-mode))
        auto-mode-alist))
