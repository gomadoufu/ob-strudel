;;; ob-strudel.el --- org-babel functions for strudel evaluation  -*- lexical-binding: t; -*-
(require 'ob)
(require 'strudel)

(defun org-babel-execute:strudel (body params)
  "Execute a block of Strudel code with org-babel.
BODY is the code block content, PARAMS are the header arguments."
  (unless strudel-websocket-server
    (strudel-start))
  ;; with-temp-buffer ではなく名前付き永続バッファを使う。
  ;; with-temp-buffer はフォーム終了後即 kill されるため WebSocket 送信が失敗する。
  (let ((buf (get-buffer-create " *ob-strudel*")))
    (with-current-buffer buf
      (erase-buffer)
      (insert body)
      (strudel-run)))
  ;; Strudel の出力はブラウザ側のため nil を返す
  "Code sent to Strudel")

(add-to-list 'org-babel-load-languages '(strudel . t))
(provide 'ob-strudel)
;;; ob-strudel.el ends here
