;;;; Use the Cairo library to create a simple SVG file.

(in-package :cairo-example)

(defun demo-svg-file ()
  (let* (;; Create a SVG surface and a Cairo context.
         (surface (cairo:svg-surface-create (sys-path "svgfile.svg") 400 300))
         (cr (cairo:create surface)))
    ;; Clear surface
    (cairo:set-source-rgb cr 1.0 1.0 1.0)
    (cairo:paint cr)
    ;; Draw in blue ink.
    (cairo:set-source-rgba cr 0 0 1.0 1.0)
    ;; Choose a font type and set its size.
    (cairo:select-font-face cr "Sans")
    (cairo:set-font-size cr 20.0)
    ;; Move to a position within the image and draw the text.
    (cairo:move-to cr 20.0 70.0)
    (cairo:show-text cr "Cario drawing to a SVG surface.")
    ;; Clean the resources.
    (cairo:surface-destroy surface)
    (cairo:destroy cr)))

;;; 2022-12-20
