(setq load-path(cons"~/.emacs.d/elisp/" load-path))
;;--------------------------------------------------------------------------------
;; 基本設定
;;--------------------------------------------------------------------------------
(custom-set-variables
 '(auto-save-default nil)          ; 自動保存しない
 '(auto-save-list-file-name nil)   ; 自動保存ファイルの名前を記録しない
 '(auto-save-list-file-prefix nil) ; 自動保存ファイルリストを初期化しない
 '(case-fold-search nil)           ; 大文字小文字を区別
; '(cua-mode t nil (cua-base))      ; Windowsキーバインド有効
 '(delete-auto-save-files t)       ; 自動保存ファイルを削除
 '(inhibit-startup-screen t)       ; スタートアップ画面を非表示
 '(make-backup-files nil)          ; バックアップファイルを作成しない
 '(scroll-bar-mode nil)            ; スクロールバーなし
 '(transient-mark-mode t)          ; アクティブなリージョンをハイライト
 '(menu-bar-mode nil)              ; メニューバー非表示
 '(tool-bar-mode nil)              ; ツールバー非表示
 '(indent-tabs-mode nil))          ; タブを空白で入力
;;--------------------------------------------------------------------------------
 
;;--------------------------------------------------------------------------------
;; 色設定
;;--------------------------------------------------------------------------------
(custom-set-faces '(default ((t (
  :foreground "white"      ; 前景色: 白
  :background "black"))))) ; 背景色: 黒
;;--------------------------------------------------------------------------------
 
;;--------------------------------------------------------------------------------
;; 透明度: 80%
;;--------------------------------------------------------------------------------
(add-to-list 'default-frame-alist '(alpha . 80))
;;--------------------------------------------------------------------------------
 
;;--------------------------------------------------------------------------------
;; タイトルバー: バッファ名 - emacs@コンピュータ名
;;--------------------------------------------------------------------------------
(setq-default frame-title-format (format "%%b - emacs@%s" (system-name)))
;;--------------------------------------------------------------------------------
;;----------------------行番号-------------------------------------------------
(require 'linum)
(global-linum-mode)
;;-----------------------------------------------------------------------------

;;---------------------PHPモード-----------------------------------------------
(autoload 'php-mode "php-mode")
(require 'php-mode)
;;----------------------------------------------------------------------------

;;----------------------Auto complete-----------------------------------------
(require 'auto-complete)
;;(require 'auto-complete-config)    ; 必須ではないですが一応
(global-auto-complete-mode t)
;;常にAuto completeを補完候補に
(add-to-list 'ac-sources 'ac-source-yasnippet)
;;-----------------------------------------------------------------------------

;;---------------------Snippet-------------------------------------------------
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")

;;-------------------fly make--------------------------------------------------

(require 'flymake)

;; GUIの警告は表示しない
(setq flymake-gui-warnings-enabled nil)

;; 全てのファイルで flymakeを有効化
(add-hook 'find-file-hook 'flymake-find-file-hook)

;; M-p/M-n で警告/エラー行の移動
(global-set-key "\M-p" 'flymake-goto-prev-error)
(global-set-key "\M-n" 'flymake-goto-next-error)

;; 警告エラー行の表示
(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)

;; popup.el を使って tip として表示
(defun my-flymake-display-err-popup.el-for-current-line ()
  "Display a menu with errors/warnings for current line if it has errors and/or warnings."
  (interactive)
  (let* ((line-no            (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (menu-data          (flymake-make-err-menu-data line-no line-err-info-list)))
    (if menu-data
      (popup-tip (mapconcat '(lambda (e) (nth 0 e))
                            (nth 1 menu-data)
                            "\n")))
    ))
(defun flymake-simple-generic-init (cmd &optional opts)
  (let* ((temp-file  (flymake-init-create-temp-buffer-copy
                      'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list cmd (append opts (list local-file)))))

;; Makefile が無くてもC/C++のチェック
(defun flymake-simple-make-or-generic-init (cmd &optional opts)
  (if (file-exists-p "Makefile")
      (flymake-simple-make-init)
    (flymake-simple-generic-init cmd opts)))

(defun flymake-c-init ()
  (flymake-simple-make-or-generic-init
   "gcc" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))

(defun flymake-cc-init ()
  (flymake-simple-make-or-generic-init
   "g++" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))

(push '("\\.[cC]\\'" flymake-c-init) flymake-allowed-file-name-masks)
(push '("\\.\\(?:cc\|cpp\|CC\|CPP\\)\\'" flymake-cc-init) flymake-allowed-file-name-masks)

;;---------powerline----------------------------------------------------------
;; powerline.el --- fancy statusline
;; Name: Emacs Powerline
;; Author: Nicolas Rougier
;; Version: 1.0
;; Keywords: statusline
;;
;; Commentary:
;; This package simply provides a minor mode for fancifying the status line.

(defun arrow-right-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
\".	c %s\",
\" 	c %s\",
\".           \",
\"..          \",
\"...         \",
\"....        \",
\".....       \",
\"......      \",
\".......     \",
\"........    \",
\".........   \",
\".........   \",
\"........    \",
\".......     \",
\"......      \",
\".....       \",
\"....        \",
\"...         \",
\"..          \",
\".           \"};"  color1 color2))

(defun arrow-left-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
\".	c %s\",
\" 	c %s\",
\"           .\",
\"          ..\",
\"         ...\",
\"        ....\",
\"       .....\",
\"      ......\",
\"     .......\",
\"    ........\",
\"   .........\",
\"   .........\",
\"    ........\",
\"     .......\",
\"      ......\",
\"       .....\",
\"        ....\",
\"         ...\",
\"          ..\",
\"           .\"};"  color2 color1))


(defconst color1 "#666666")
(defconst color2 "#999999")

(defvar arrow-right-0 (create-image (arrow-right-xpm "None" color1) 'xpm t :ascent 'center))
(defvar arrow-right-1 (create-image (arrow-right-xpm color1 color2) 'xpm t :ascent 'center))
(defvar arrow-right-2 (create-image (arrow-right-xpm color2 "None") 'xpm t :ascent 'center))
(defvar arrow-left-1  (create-image (arrow-left-xpm color2 color1) 'xpm t :ascent 'center))
(defvar arrow-left-2  (create-image (arrow-left-xpm "None" color2) 'xpm t :ascent 'center))

(setq-default mode-line-format
 (list  '(:eval (concat (propertize " %b " 'face 'mode-line-color-1)
                        (propertize " " 'display arrow-right-1)))
        '(:eval (concat (propertize " %m " 'face 'mode-line-color-2)
                        (propertize " " 'display arrow-right-2)))

        ;; Justify right by filling with spaces to right fringe - 16
        ;; (16 should be computed rahter than hardcoded)
        '(:eval (propertize " " 'display '((space :align-to (- right-fringe 17)))))

        '(:eval (concat (propertize " " 'display arrow-left-2)
                        (propertize " %p " 'face 'mode-line-color-2)))
        '(:eval (concat (propertize " " 'display arrow-left-1)
                        (propertize "%4l:%2c  " 'face 'mode-line-color-1)))
)) 

(make-face 'mode-line-color-1)
(set-face-attribute 'mode-line-color-1 nil
                    :foreground "#fffacd"
                    ;;:foreground "#ffffff"
                    ;; :background "#171717")
                    :background "#666666")

(make-face 'mode-line-color-2)
(set-face-attribute 'mode-line-color-2 nil
                    :foreground "#fffacd"
                    ;; :background "#171717")
                    :background "#999999")

(set-face-attribute 'mode-line nil
                    :foreground "#fffacd"
                    :background "#171717"
                    :box nil)
(set-face-attribute 'mode-line-inactive nil
                    :foreground "#fffacd"
                    :background "#171717")
;;------------------------------------------------------------------------------


;;---------------------------------------------------------------------------
;;  webmode.elの読み込み
;;---------------------------------------------------------------------------

(require 'web-mode)

;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2))
(add-hook 'web-mode-hook 'web-mode-hook)
