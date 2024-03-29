;;; init.el --- Emacs Configuration of Eric Haberstroh

;; Copyright (C) 2018 Eric Haberstroh

;; Author: Eric Haberstroh <gpg@erixpage.de>
;; Created: 2018-07-18
;; Keywords: configuration dotemacs
;; Homepage: https://github.com/pille1842/dotemacs

;; This program is free software: you can redistribute it and/or modify
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

;; This is my Emacs configuration file. There are many like it,
;; but this is mine.

;; This is actually just a simple init script that sets up the bare
;; minimum. The rest of the configuration is loaded from config.org,
;; which is turned into config.el by using Orgmode's Babel-Tangle
;; functionality.

;;; Code:

;; Temporarily increase the memory threshold after which the Garbage
;; Collector begins its work. This will be restored to the original
;; setting at the end of this file.
(setq eh/original-gc-cons-threshold gc-cons-threshold)
(setq gc-cons-threshold 400000000)

;; Turn off the mouse interface early in startup to avoid its
;; momentary display. Keep the menu bar.
(dolist (mode '(tool-bar-mode scroll-bar-mode tooltip-mode))
  (funcall mode -1))

;; Don't display the splash screen or any text in the initial scratch
;; buffer.
(setq inhibit-startup-message t)
(setq initial-scratch-message
      (concat ";; Welcome to Emacs "
              emacs-version
              " on "
              system-name
              ".\n\n"))

;; Set up package.el.
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; Bootstrap use-package.el.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; Now load the actual configuration file.
(org-babel-load-file (concat user-emacs-directory "config.org"))

;; Some settings which are private in nature, such as those for email
;; and IRC, can be kept in another file called private.el which is not
;; under version control. Load this file if it exists.
(defvar private-file
  (concat user-emacs-directory "private.el")
  "A file containing private settings. If it exists, it will be
loaded at startup.

The default location is ~/.emacs.d/private.el.")

(when (file-exists-p private-file)
  (load private-file))

;; Now decrease the garbage collection threshold to the original setting.
(setq gc-cons-threshold eh/original-gc-cons-threshold)
(makunbound 'eh/original-gc-cons-threshold)

;;; init.el ends here
