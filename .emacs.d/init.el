;; emacsのメジャーバージョンは26.1


;; フレームの設定                              
(setq initial-frame-alist                      
      (append (list                            
;;               '(alpha . (95 5))             
;;               '(width . 120)                
;;               '(height . 70)                
               '(width . 120)                   
               '(height . 56)                  
               '(top . 0)                     
               '(left . 0))                    
              initial-frame-alist))            
(setq default-frame-alist initial-frame-alist) 

;; 閉じ括弧の自動挿入
(electric-pair-mode 1)

;;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)


;; load-pathを追加する関数を定義

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; emacsサーバー
(require 'server)
(unless (server-running-p)
  (server-start))

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; インデントにタブ文字を利用する
(setq-default indent-tabs-mode nil)
;; 特定のモードの場合はインデントにタブ文字を利用しない
(add-hook 'emacs-lisp-mode-hook (function (lambda () (setq indent-tabs-mode nil))))
(add-hook 'org-mode-hook (function (lambda () (setq indent-tabs-mode nil))))

;; インデントを 4 に設定
(setq c-basic-offset 4)
(setq js-indent-level 2)
(setq php-indent-level 2)
(setq cperl-indent-level 4)
(setq cperl-continued-statement-offset 4)
(setq sh-basic-offset 2)
(setq sh-indentation 2)
(setq cperl-close-paren-offset -4)
(setq cperl-indent-region-fix-constructs 1)
(setq cperl-indent-parens-as-block t)
(setq sgml-basic-offset 4)
(setq ruby-indent-tabs-mode nil)
(setq ruby-indent-size 2)
(setq ruby-indent-level 2)
(setq coffee-tab-width 2)

;; タブ幅を 4 に設定
(setq tab-width 4)
(setq-default tab-width 4)
;; (setq tab-stop-list (let ((stops '(4)))
;;                       (while (< (car stops) 120)
;;                         (setq stops (cons (+ 4 (car stops)) stops)))
;;                       (nreverse stops)))

;; Mac の文字コードの設定
(set-language-environment "Japanese")
(require 'ucs-normalize)
;; (prefer-coding-system 'utf-8-hfs)
;; (setq file-name-coding-system 'utf-8-hfs)
;; (setq locale-coding-system 'utf-8-hfs)
;; utf-8-hfs の濁点付カナがapacheで認識出来なかった為以下で対応
(prefer-coding-system 'utf-8-unix)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-unix)

;;;; 半角と全角を1:2に
;;(setq face-font-rescale-alist
;;      '((".*Menlo.*" . 1.0)
;;        (".*Hiragino_Mincho_ProN" . 1.2)
;;        ;; (".*nfmotoyacedar-bold.*" . 1.2)
;;        ;; (".*nfmotoyacedar-medinum.*" . 1.2)
;;        ("-cdac$" . 1.3)))

;; フォントの設定
(if (window-system)
    (progn
      (set-face-attribute 'default nil
                          :family "Ricty"
                          :height 140)
      (set-fontset-font
       nil 'japanese-jisx0208
       (font-spec :family "Ricty"))
      (set-fontset-font
       nil 'katakana-jisx0201
       (font-spec :family "Ricty"))
      )
  )



;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)
;; tool-bar を非表示。コンソールでは不要
(tool-bar-mode 0)
;; scroll-bar を非表示。コンソールでは不要
 (scroll-bar-mode 0)
;; menu-bar を非表示
;; (menu-bar-mode 0)

;; メニューバーにファイルパスを表示する
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

(set-face-attribute 'show-paren-match nil
      :background 'unspecified
      :underline "turquoise")

;; 行番号を表示する
(global-linum-mode t)

;; カーソルの位置を表示する
(line-number-mode t)
(column-number-mode t)

;; バッファ名をディレクトリ名に変更
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; uniquify でバッファ名を変更しないものを正規表現で指定
(setq uniquify-ignore-buffers-re "*[^*]+*")
;; ファイル名が重複してない場合も常にディレクトリ名を表示するよう指定
(setq uniquify-min-dir-content 1)

;; Mac の command キーと Alt キーを入れ換える
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; C-m に newline-and-indent を割り当てる。初期値は newline
;; (define-key global-map (kbd "C-m") 'newline-and-indent)

;; "M-k" でカレントバッファを閉じる。初期値は kill-sentence
(define-key global-map (kbd "M-k") 'kill-this-buffer)

;; "C-t" でウィンドウを切り替える。初期値は transpose-chars
(define-key global-map (kbd "C-t") 'other-window)

;; "C-sC-w" でカーソル下の単語を検索
(defun isearch-forward-with-heading ()
  "Search the word your cursor looking at."
  (interactive)
  (command-execute 'backward-word)
  (command-execute 'isearch-forward))
(global-set-key "\C-s" 'isearch-forward-with-heading)

;; trampにてps1をカスタマイズしてるサーバに接続する為の設定
(setq tramp-shell-prompt-pattern "\\(?:^\\|\^M\\)[^#$%>\n]*#?[]#$%>] *\\(\e\\[[0-9;]*[a-zA-Z] *\\)* *")

;; trampにて履歴ファイルを保存しない
(setq tramp-histfile-override "/dev/null")

;; themesディレクトリを追加
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; theme

(load-theme 'iceberg t)
(enable-theme 'iceberg)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay nil)
 '(package-selected-packages
   (quote
    (visual-regexp-steroids pcre2el scratch-log avy easy-repeat shackle anzu markdown-mode robe company undo-tree undohist moccur-edit color-moccur inf-ruby rbenv ruby-block ruby-electric ruby-mode helm php-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ドラッグドロップでファイルを開く
(define-key global-map [ns-drag-file] 'ns-find-file)
(setq ns-pop-up-frames nil)


;; scratchバッファの制御
(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    ;; "*scratch*" を作成して buffer-list に放り込む
    (set-buffer (get-buffer-create "*scratch*"))
    (funcall initial-major-mode)
    (erase-buffer)
    (when (and initial-scratch-message (not inhibit-startup-message))
      (insert initial-scratch-message))
    (or arg (progn (setq arg 0)
                   (switch-to-buffer "*scratch*")))
    (cond ((= arg 0) (message "*scratch* is cleared up."))
          ((= arg 1) (message "another *scratch* is created")))))
(add-hook 'kill-buffer-query-functions
          ;; *scratch* バッファで kill-buffer したら内容を消去するだけにする
          (lambda ()
            (if (string= "*scratch*" (buffer-name))
                (progn (my-make-scratch 0) nil)
              t)))
(add-hook 'after-save-hook
          ;; *scratch* バッファの内容を保存したら *scratch* バッファを新しく作る
          (lambda ()
            (unless (member (get-buffer "*scratch*") (buffer-list))
              (my-make-scratch 1))))

;; commentの設定
(defconst comment-styles
  '((plain	. (nil nil nil nil))
    (indent	. (nil nil nil t))
    (indent-or-triple
     . (nil nil nil multi-char))
    (aligned	. (nil t nil t))
    (multi-line	. (t nil nil t))
    (extra-line	. (t nil t t))
    (box	. (nil t t t))
    (box-multi	. (t t t t)))
  "Comment region styles of the form (STYLE . (MULTI ALIGN EXTRA INDENT)).
STYLE should be a mnemonic symbol.
MULTI specifies that comments are allowed to span multiple lines.
ALIGN specifies that the `comment-end' markers should be aligned.
EXTRA specifies that an extra line should be used before and after the
  region to comment (to put the `comment-end' and `comment-start').
INDENT specifies that the `comment-start' markers should not be put at the
  left margin but at the current indentation of the region to comment.
If INDENT is `multi-char', that means indent multi-character
  comment starters, but not one-character comment starters.")
;; comment-style (indent, multi-line, box)
(setq comment-style 'box)

;; yankのシステムへのコピー
(cond (window-system (setq x-select-enable-clipboard t)))

;; ¥の代わりにバックスラッシュを入力する
(define-key global-map [?¥] [?\\])
;;(define-key html-mode-map [?¥] [?\\])
(define-key isearch-mode-map [?¥] '(lambda () (interactive)(isearch-process-search-char ?\\)))

(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/opt/local/bin")

;; リージョン内の行数と文字数をモードラインに表示する
(defun count-lines-and-chars()
  (if mark-active
      (format "(%dlines, %dchars) "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ""))

;; default-mode-line-formatがなくなったので修正が必要
;;(add-to-list 'default-mode-line-format
;;             '(:eval (count-lines-and-chars)))

;; paren-mode 対応するカッコを強調して表示する
(setq show-paren-delay 0) ;;表示までの秒数
(show-paren-mode t)
;; parenのスタイル expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;; フェイスを変更する
;; (set-face-background 'show-paren-match-face nil)
;; (set-face-underline-p 'show-paren-match-face "darkgreen")

;; 更新されたファイルを自動的に読み込みなおｓ
(global-auto-revert-mode t)

;; ファイルが#! から始まる場合、+xを付けて保存する
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-modeのフックをセット
;; カーソル位置にあるElisp関数や変数の情報をエコーエリアに表示させる
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)


;; ----------------------------------------以下拡張周りの設定--------------------------------------------


(require 'package) ; package.elを有効化
;; パッケージリポジトリにMarmaladeとMelpaを追加
(add-to-list 'package-archives
	     '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)


;;php-mode
(require 'php-mode)
;; PHPにて特定のインデントを変更
(add-hook 'php-mode-hook
          (lambda ()
            (c-set-offset 'substatement-open 0)
            ))

;; helm
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode t)

(helm-mode 1)

;;重くなるのでhelm-for-filesだけハイライトを無効化する
(defadvice helm-for-files
  (around helm-for-files-no-highlight activate)
  "No highlight when using helm-for-files."
  (let ((helm-mp-highlight-delay nil))
    ad-do-it))

;; helm-M-x
(global-set-key (kbd "M-x") 'helm-M-x)
;; fuzzy matching of helm-M-x
(setq helm-M-x-fuzzy-match t) ;; optional
;; helm-show-kill-ring 履歴管理
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-;") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)

;; 使いにくいのでコメントアウト
(global-set-key (kbd "C-x C-o") 'helm-find-files)
;; helm-occur
(global-set-key (kbd "C-c o") 'helm-occur)


;; settings about ruby
(setenv "RBENV_ROOT" "~/.anyenv/envs/rbenv")
(require 'rbenv)
(global-rbenv-mode)

;; rbenvパス設定
(setenv "PATH" (concat (expand-file-name "~/.anyenv/envs/rbenv/shims/ruby") (getenv "PATH")))


(require 'ruby-block)
(ruby-block-mode t)

; ruby-block-delay を0.50 → 0に設定
(defcustom ruby-block-delay 0
  "*Time in seconds to delay before showing a matching paren."
  :type  'number
  :group 'ruby-block)

;; ruby-mode等
(add-to-list 'load-path "~/.emacs.d/elisp/ruby-mode")
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
;;(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;;ruby-electric.el
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; set ruby-mode indent
(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)


;; 入力されるキーシーケンスを入れ換える
;; ?\C-?はDELのキーシーケンス
(keyboard-translate ?\C-h ?\C-?)
;; C-h
;;(global-set-key (kbd "C-h") 'delete-backward-char)
;; 別のキーバインドにヘルプを割り当てる
(global-set-key (kbd "C-x ?") 'help-command)


;;; リージョンを削除できるように
(delete-selection-mode t)

;; color-mooccurの設定 occur-by-moccurはカレントバッファを検索する
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレク折検索の時に除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$"))


;; 検索したものを一気に置換できるmoccur-editに関する設定
(require 'moccur-edit nil t)

;;moccur-editについて
;; 現環境ではmoccurによる検索を実行したあとに*Moccur*バッファ上でrを押すとmoccur-editモードになる
;; C-x kで変更が破棄できる

;; moccur-edit-finish-editと同時にファイルを保存する
(defadvice moccur-edit-change-file
    (after save-after-moccur-edit-buffer activate)
  (save-buffer))


;; undohist
(when (require 'undohist nil t)
  (undohist-initialize))

;; undotree
(when (require 'undo-tree nil t)
  ;; C-'にリドゥを割り当てる
  ;; (define-key global-map (kbd "C-'") 'undo-tree-redo)
  ;; 通常はC-x uでundo-tree-visualize
  ;; 戻りたいポイントでqで抜けられる
  ;; tで樹形図を時間表示と切り替える
  (global-undo-tree-mode))


;; settings about company
(require 'company)
(global-company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t ) ;; 候補の一番下でさらに下に行こうとすると一番上に戻る
(setq company-auto-expand t)
(setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
(setq company-idle-delay 0) ; 遅延なしにすぐ表示
(setq company-minimum-prefix-length 1) ; 何文字打つと補完動作を行うか設定
(setq completion-ignore-case t)
(setq company-dabbrev-downcase nil)
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)
(define-key company-active-map (kbd "C-s") 'company-filter-candidates) ;; C-sで絞り込む


;; 補完機能
;; robe-modeの有効化とcompanyとの連携
(add-hook 'ruby-mode-hook 'robe-mode)
(autoload 'robe-mode "robe" "Code navigation, documentation lookup and completion for Ruby" t nil)
(eval-after-load 'company
  '(push 'company-robe company-backends))

(add-hook 'ruby-mode-hook (lambda()
      (company-mode)
      (global-set-key (kbd "C-M-i") 'company-complete)
      (define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
      (define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete) ;; 各種メジャーモードでも C-M-iで company-modeの補完を使う
      ))

;; markdownの環境を作っておく
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; anzu
(when (require 'anzu)
  (global-anzu-mode +1))

;; shackle
(when (require 'shackle)
  (setq shackle-rules
        '(
          (compilation-mode :align below :ratio 0.3)
          ("*Help*" :align right)
          ("*Completions*" :align below :ratio 0.3)
          ("\*helm" :regexp t :align below :ratio 0.3)
          ;; 上部に表示
          ("foo" :align above)
          ;; 別フレームで表示
          ("bar" :frame t)
          ;; 同じウィンドウで表示
          ("baz" :same t)
          ;; ポップアップで表示
          ("hoge" :popup t)
          ;; 選択する
          ("abc" :select t)
          ))

  (shackle-mode 1)
  (setq shackle-lighter "")

  ;;; C-zで直前のウィンドウ構成に戻す
  ;(winner-mode 1)
  ;(global-set-key (kbd "C-z") 'winner-undo)

  ;;;; test
  ;; (display-buffer (get-buffer-create "*compilation*"))
  ;; (display-buffer (get-buffer-create "*Help*"))
  ;; (display-buffer (get-buffer-create "foo"))
  ;; (display-buffer (get-buffer-create "bar"))
  ;; (display-buffer (get-buffer-create "baz"))
  ;; (display-buffer (get-buffer-create "hoge"))
  ;; (display-buffer (get-buffer-create "abc"))
  )

;; ls dired support.
(setq dired-use-ls-dired nil)
;; Reveal in Finder
(defun my-dired-do-reveal (&optional arg)
  "Reveal the marked files in Finder.
If no files are marked or a specific numeric prefix arg is given,
the next ARG files are used.  Just \\[universal-argument] means the current file."
  (interactive "P")
  (let ((files (dired-get-marked-files nil arg))
        (script
         (concat
          "on run argv\n"
          "    set itemArray to {}\n"
          "    repeat with i in argv\n"
          "        set itemArray to itemArray & (i as POSIX file as Unicode text)\n"
          "    end repeat\n"
          "    tell application \"Finder\"\n"
          "        activate\n"
          "        reveal itemArray\n"
          "    end tell\n"
          "end run\n")))
    (apply 'start-process "osascript-reveal" nil "osascript" "-e" script files)))
(eval-after-load "dired"
  '(define-key dired-mode-map "\M-r" 'my-dired-do-reveal)) ; move-to-window-line


(when (require 'avy nil t)
  (define-key global-map (kbd "M-g g") 'avy-goto-line)
  (define-key global-map (kbd "M-g M-g") 'avy-goto-line))

(when (require 'easy-repeat nil t)
  (easy-repeat-mode))

;; (install-elisp "https://raw.github.com/wakaran/scratch-log/4798f1170ea4ec17bb4f61e4b84e3f1bcec9ad18/scratch-log.el")
(when (require 'scratch-log nil t)
  (setq sl-scratch-log-file "~/.emacs.d/.scratch-log")
  (setq sl-prev-scratch-string-file "~/.emacs.d/.scratch-log-prev")
  ;; nil なら emacs 起動時に，最後に終了したときの スクラッチバッファの内容を復元しない。初期値は t です。
  (setq sl-restore-scratch-p t)
  ;;nil なら スクラッチバッファを削除できるままにする。初期値は t です。
  (setq sl-prohibit-kill-scratch-buffer-p nil)
  )

(when (require 'pcre2el)
  (add-hook 'prog-mode-hook 'rxt-mode)
  (setq reb-re-syntax 'pcre)
  )

(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)


(when (require 'visual-regexp-steroids)
  ;; (setq vr/engine 'python) ;python regexpならばこれ
  (setq vr/engine 'pcre2el) ;elispでPCREから変換
  (global-set-key (kbd "M-%") 'vr/query-replace)
  ;; multiple-cursorsを使っているならこれで
  (global-set-key (kbd "C-c m") 'vr/mc-mark)
  ;; 普段の正規表現isearchにも使いたいならこれを
  (global-set-key (kbd "C-M-r") 'vr/isearch-backward)
  (global-set-key (kbd "C-M-s") 'vr/isearch-forward)
  )
