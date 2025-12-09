;;; ob-strudel.el --- org-babel functions for strudel evaluation  -*- lexical-binding: t; -*-


(require 'ob)
(require 'strudel)

(defun org-babel-execute:strudel (body params)
  "Execute a block of Strudel code with org-babel.
BODY is the code block content, PARAMS are the header arguments."
  ;; WebSocketサーバーが起動していない場合は起動
  (unless strudel-websocket-server
    (strudel-start))
  
  ;; 一時バッファでコードを実行
  (with-temp-buffer
    ;; JavaScriptモードを有効化（strudelはJavaScriptベース）
    (when (fboundp 'rjsx-mode)
      (rjsx-mode))
    ;; strudel-modeを有効化
    (strudel-mode 1)
    ;; ソースブロックの内容を挿入
    (insert body)
    ;; strudelに送信
    (strudel-run))
  
  ;; org-babelは結果を返すことを期待するが、
  ;; strudelはブラウザ側で実行されるので結果は返せない
  "Code sent to Strudel")

;; strudelをorg-babel言語リストに追加
(add-to-list 'org-babel-load-languages '(strudel . t))

(provide 'ob-strudel)

;;; ob-strudel.el ends here
