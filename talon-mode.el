;;; talon-mode.el --- Major mode for editing Talon Voice scripts  -*- lexical-binding: t; -*-

;; Author: kelocoder
;; Created: 26 Nov 2024

;; Version: 0.0.1
;; Package-Requires: ((emacs "27.1"))

;; Keywords: talon languages
;; URL: https://github.com/kelocoder/talon-mode

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; * Overview                                               :README:
;;
;; talon-mode is a major mode for editing Talon Voice scripts.
;;
;; Features include:
;; 1. Syntax Highlighting
;; 2. Indentation Support
;; 3. Syntax Table Configuration
;; 4. Outline Minor Mode Default Settings

;; * Features                                               :README:
;;
;; ** Syntax Highlighting
;; Syntax highlighting is supported through configuration of `font-lock'
;; faces.
;;
;; The following faces are matched to the talon script elements listed:
;; - `font-lock-comment-face':
;;   - Comments
;; - `font-lock-builtin-face':
;;   - Built-in actions (ex. 'key', 'insert')
;;   - Context header identifiers (ex. 'app.name', 'os')
;; - `font-lock-preprocessor-face':
;;   - 'settings' and 'tags' identifiers
;; - `font-lock-function-name-face':
;;   - Rules
;;
;; ** Indentation Support
;; A straightforward indentation function is implemented.
;;
;; The following custom variables are provided:
;; - `tal-indent-offset'
;;
;; ** Syntax Table Configuration
;; Some characters in the `syntax-table' are modified to enable proper
;; parsing, movement, and syntax highlighting (features implemented by other
;; Emacs facilities).
;;
;; ** Outline Minor Mode Default Settings
;; Comment lines starting with '#- ', '#-- ', or '#--- ' are matched
;; as outline headings.
;;
;; #+begin_example
;;     Collapsing all headings will produce a result like this:
;;     #- Heading Level 1
;;     #-- Heading Level 2
;;     #--- Heading Level 3
;; #+end_example
;;
;; The following custom variables are provided:
;; - `tal-outline-regexp'

;; * Installation                                           :README:
;;
;; talon-mode is currently not managed by any package repository.
;;
;; To install it:
;; 1. Copy this file into your emacs site-lisp dir or somewhere in your 'load-path'.
;; 2. Add the following code to your Emacs init file:
;; #+begin_example
;;     (require 'talon-mode)
;; #+end_example

;; * Usage                                                  :README:
;;
;; Opening any file with the ".talon" extension will automatically enable
;; talon-mode.

;;; Code:

;; * talon-mode code                                        :code:

;;; General

(defgroup talon-mode nil
  "Support for the Talon Voice scripting language"
  :group 'languages
  :prefix "tal-")

(defcustom tal-mode-hook nil
  "Hook run when entering Talon mode."
  :type 'hook
  :group 'talon-mode)

(defcustom tal-indent-offset 4
  "Amount of offset per level of indentation."
  :type 'integer
  :group 'talon-mode)


;;; Syntax Table Configuration

(defvar tal-mode-syntax-table
  (let ((syntax-table (make-syntax-table)))
    (modify-syntax-entry ?_ "_" syntax-table)   ; symbol constituent
    (modify-syntax-entry ?^ "_" syntax-table)   ; "
    (modify-syntax-entry ?$ "_" syntax-table)   ; "
    (modify-syntax-entry ?. "." syntax-table)   ; punctuation character
    (modify-syntax-entry ?| "." syntax-table)   ; "
    (modify-syntax-entry ?# "<" syntax-table)   ; comment starter
    (modify-syntax-entry ?\n ">" syntax-table)  ; comment ender
    (modify-syntax-entry ?\< "(>" syntax-table) ; open paren character
    (modify-syntax-entry ?\> ")<" syntax-table) ; closed paren character
    syntax-table)
  "Syntax table for `talon-mode'.")


;;; Syntax Highlighting Definitions

(defconst tal-blank-line-regexp
  "^\\\s*$"
  "Regexp matching a line containing only whitespace.")

(defconst tal-comment-regexp
  ;; Matches:
  ;; any number of tabs or spaces then
  ;; one or more '#' characters then
  ;; zero or more characters then
  ;; ends with a new line
  "[ \t]*#.*[\n]"
  "Regexp matching a talon comment.")

(defconst tal-builtin-actions-regexp
  (regexp-opt
   '("insert" "key"
     "mouse_click" "mouse_drag" "mouse_move" "mouse_release" "mouse_scroll"
     "mouse_x" "mouse_y"
     "print" "repeat" "sleep")
   'symbols)
  "Regexp matching a talon built-in action.")

(defconst tal-context-header-separator-regexp
  "^\\\s*-\\\s*$"
  "Regexp matching the separator line which marks the end of a Talon
Voice script Context Header section."
  )

(defconst tal-context-header-identifiers-regexp
  (concat
   "^"
   (regexp-opt
    '("app" "app.exe" "app.name" "code.language" "hostname" "mode" "os"
      "tag" "title")
    'symbols)
   ":")
  "Regexp matching a talon context header identifier.")

(defconst tal-settings-and-tags-regexp
  ;; Matches:
  ;; starts with the word 'settings' or the word 'tags' then
  ;; these three symbols, in order, '(' ')' ':' then
  ;; zero or more whitespace characters
  "^\\(settings\\|tags\\)():"
  "Regexp matching talon settings or tags identifier.")

(defconst tal-rule-regexp
  ;; Matches:
  ;; zero or one '^' symbols then
  ;; one or more characters that are considered valid in a talon rule then
  ;; zero or one '$' symbols then
  ;; one ':' symbol then
  ;; ends with one or more whitespace characters
  "^\\([\\^]?[][A-Za-z0-9\\| \\(\\)\\._<>+*]+[\\$]?\\):[ \t\n]+"
  "Regexp matching a talon voice rule.")

(defvar tal-font-lock-keywords
  `((,tal-comment-regexp . font-lock-comment-face)
    (,tal-context-header-identifiers-regexp . ( 1 font-lock-builtin-face))
    (,tal-settings-and-tags-regexp . ( 1 font-lock-preprocessor-face))
    (,tal-rule-regexp . ( 1 font-lock-function-name-face) )
    (,tal-builtin-actions-regexp . font-lock-builtin-face)
    )
  )


;;; Indentation Support

(defun tal-compute-indentation ()
  "Calculate indentation for the current line.

Lines are indented to 0 or 1 level of indentation.

Lines are classified into the following types and indented to the
level listed:
- Comment                   - 0
- Context Header Identifier - 0
- Context Header Separator  - 0
- Rule (and Settings/Tags)  - 0
- Body                      - 1
- Blank                     - it depends*

* For blank lines, if the previous line is a comment, context
  header identifier or separator line, or a blank, indent level
  is 0, otherwise, it indent level is 1.
"
  ;; default to 1 level of indentation
  (let ((indent tal-indent-offset)) 
    (save-excursion
      (beginning-of-line)
      ;; if current line is a rule, comment, context header identifier or
      ;; separator line, or settings/tags line
      (if (or (looking-at tal-rule-regexp)
	      (looking-at tal-comment-regexp)
	      (looking-at tal-context-header-identifiers-regexp)
	      (looking-at tal-context-header-separator-regexp)
	      (looking-at tal-settings-and-tags-regexp)
	      )
	  (setq indent 0)
	;; else
	;; if it's a blank line (not a body line)
	(when (looking-at tal-blank-line-regexp)
	  (forward-line -1)
	  ;; if previous line is a comment, context header identifier or
	  ;; separator line, or blank
	  (when (or (looking-at tal-comment-regexp)
		    (looking-at tal-context-header-identifiers-regexp)
		    (looking-at tal-context-header-separator-regexp)
		    (looking-at tal-blank-line-regexp))
	    (setq indent 0)
	    ))))
    indent))

(defun tal-indent-line ()
  "Indent the current line."
  (interactive "*")
  (let ((indent (tal-compute-indentation)))
    (indent-line-to indent)
    ;; move cursor to the beginning of the first indent
    (beginning-of-line)
    (forward-char indent)
    ))


;;; Outline Minor Mode Default Settings

(defcustom tal-outline-regexp
  "\\(^#- \\|^#-- \\|^#--- \\)"
  "Regexp to use for Outline Minor Mode headings.

Regular expression that defaults to matching comment lines
starting with '#- ' , '#-- ', or ' #--- ' as outline headings.
Note that there is a space which trails the dashes.  Dashes are
used so the result is not visually distracting.

#- Heading Level 1
#-- Heading Level 2
#--- Heading Level 3
"
  :type 'regexp
  :group 'talon-mode)


;;; Major Mode Definition

;;;###autoload
(define-derived-mode talon-mode
  prog-mode  ; derive from prog-mode so we can utilize stuff like ligatures
  "Talon"
  "Major mode for editing Talon Voice scripts."
  :syntax-table tal-mode-syntax-table
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "^[ \t]*#+[ \t]*")
  (setq-local indent-line-function 'tal-indent-line)
  (setq-local font-lock-defaults '(tal-font-lock-keywords))
  (setq-local outline-regexp tal-outline-regexp))


;;;###autoload
(add-to-list 'auto-mode-alist '("\\.talon\\'" . talon-mode))


(provide 'talon-mode)

;;; talon-mode.el ends here
