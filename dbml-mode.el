;;; dbml-mode.el --- Major mode for DBML -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Peter Badida

;; Author: Peter Badida <keyweeusr@gmail.com>
;; Keywords: convenience, dbml, language, markup, highlight
;; Version: 1.0.0
;; Package-Requires: ((emacs "24.1"))
;; Homepage: https://github.com/KeyWeeUsr/dbml-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; -

;;; Code:

(defgroup dbml
  nil
  "Customization group for `dbml-mode'."
  :group 'convenience
  :group 'external
  :group 'programming)

;;;###autoload
(define-derived-mode dbml-mode prog-mode "DBML"
  "Major mode for editing DBML diagram files."
  :group 'dbml

  (font-lock-set-defaults)

  ;; case-insensitive matching
  (setq-local font-lock-keywords-case-fold-search t)

  (font-lock-add-keywords
   ;; 'dbml-mode ;; TODO: keep to mode only!
   nil
   `(;; keywords
     (,(rx (or "project" "table" "tablegroup" "note" "ref" "enum"))
      0 'font-lock-keyword-face)))

  ;; NOTE: These MUST NOT set a face directly because it's weirdly
  ;; removed after post-self-insert-hook (or wherever...)
  ;; Use `font-lock-add-keywords' because it's keywords based on regex
  ;; i.e. "color-me-by-pattern" instead of it's original name
  (setq-local syntax-propertize-function
              (syntax-propertize-rules
               ;; multi-line string
               ;; TODO: Ensure syntax highlighting works inside on patterns
               ;; check js-mode-syntax-table in 25.1+
               ((rx (group "`")) (1 "\""))

               ;; single-line strings
               ((rx (or whitespace (literal ":"))
                    (group "'" (*? print) "'")
                    (not "'")) (1 "\""))

               ;; multi-line strings
               ((rx (or whitespace (literal ":"))
                    (group "'''" (*? (not "'")) "'''")
                    (not "'")) (1 "\""))))

  (let ((table (make-syntax-table)))
    ;; As per `Syntax-Flags' section
    ;; / as a comment: opener, opener second char, closer second char
    (modify-syntax-entry ?/ ". 124" table)
    ;; * as a comment: opener second char (alternative), closer first char
    (modify-syntax-entry ?* ". 23b" table)
    ;; newline as a comment ender (primary)
    (modify-syntax-entry ?\n ">" table)
    (set-syntax-table table)))

(provide 'dbml-mode)
;;; dbml-mode.el ends here