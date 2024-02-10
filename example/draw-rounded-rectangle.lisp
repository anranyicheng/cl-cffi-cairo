(in-package :cairo-example)

(defun draw-rounded-rectangle (context width height)
  (let* ((size 256)
         (scale (/ (min width height) size))
         (tx (* 0.5 (- width (* scale size))))
         (ty (* 0.5 (- height (* scale size))))
         ;; Parmeters for the rounded rectangle
         (x 25.6) (y 25.6) (w 204.8) (h 204.8)
         (aspect 1.0)
         (radius (/ h 10 aspect))
         (deg (/ pi 180.0)))
    (cairo:save context)
    (cairo:translate context tx ty)
    (cairo:scale context scale scale)
    ;; Draw the rounded rectangle
    (cairo:new-sub-path context)
    (cairo:arc context (+ x w (- radius))
                       (+ y radius)
                       radius
                       (* deg -90)
                       (* deg 0))
    (cairo:arc context (+ x w (- radius))
                       (+ y h (- radius))
                       radius
                       (* deg 0)
                       (* deg 90))
    (cairo:arc context (+ x radius)
                       (+ y h (- radius))
                       radius
                       (* deg 90)
                       (* deg 180))
    (cairo:arc context (+ x radius)
                       (+ y radius)
                       radius
                       (* deg 180)
                       (* deg 270))
    (cairo:close-path context)
    (cairo:set-source-rgb context 0.5 0.5 1.0)
    (cairo:fill-preserve context)
    (cairo:set-source-rgba context 0.5 0.0 0.0 0.5)
    (setf (cairo:line-width context) 10)
    (cairo:stroke context)
    (cairo:restore context)))
