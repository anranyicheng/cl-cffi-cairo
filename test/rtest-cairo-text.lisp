(in-package :cairo-test)

(def-suite cairo-text :in cairo-suite)
(in-suite cairo-text)

;;; --- Types and Values -------------------------------------------------------

;;;     cairo_glyph_t
;;;     cairo_font_slant_t
;;;     cairo_font_weight_t
;;;     cairo_text_cluster_t
;;;     cairo_text_cluster_flags_t

;;; --- Functions --------------------------------------------------------------

;;;     cairo:with-toy-font-face

#-windows
(test cairo-with-toy-font-face.1
  (cairo:with-toy-font-face (face "" :normal :normal)
    (is (string= "" (cairo:toy-font-face-family face)))
    (is (eq :normal (cairo:toy-font-face-slant face)))
    (is (eq :normal (cairo:toy-font-face-weight face))))
  (cairo:with-toy-font-face (face "Sans" :normal :normal)
    (is (string= "Sans" (cairo:toy-font-face-family face)))
    (is (eq :normal (cairo:toy-font-face-slant face)))
    (is (eq :normal (cairo:toy-font-face-weight face)))))

#+windows
(test cairo-with-toy-font-face.1
  (cairo:with-toy-font-face (face "" :normal :normal)
    (is (string= "Arial" (cairo:toy-font-face-family face)))
    (is (eq :normal (cairo:toy-font-face-slant face)))
    (is (eq :normal (cairo:toy-font-face-weight face))))
  (cairo:with-toy-font-face (face "Sans" :normal :normal)
    (is (string= "Sans" (cairo:toy-font-face-family face)))
    (is (eq :normal (cairo:toy-font-face-slant face)))
    (is (eq :normal (cairo:toy-font-face-weight face)))))

#-windows
(test with-toy-font-face.2
  (cairo:with-toy-font-face (face "" :italic :bold)
    (is (string= "" (cairo:toy-font-face-family face)))
    (is (eq :italic (cairo:toy-font-face-slant face)))
    (is (eq :bold (cairo:toy-font-face-weight face)))))

#+windows
(test with-toy-font-face.2
  (cairo:with-toy-font-face (face "" :italic :bold)
    (is (string= "Arial" (cairo:toy-font-face-family face)))
    (is (eq :italic (cairo:toy-font-face-slant face)))
    (is (eq :bold (cairo:toy-font-face-weight face)))))

;;;     cairo_select_font_face

(test cairo-select-font-face
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    (is-false (cairo:select-font-face context "Courier" :weight :bold))
    (is (cffi:pointerp (cairo:font-face context)))
    (is (eq :success (cairo:font-face-status (cairo:font-face context))))
    (is (eq :toy (cairo:font-face-type (cairo:font-face context))))
    (let ((options (cairo:font-options context)))
      (is (cffi:pointerp options))
      (is (eq :default (cairo:font-options-antialias options)))
      (is (eq :default (cairo:font-options-subpixel-order options)))
      (is (eq :default (cairo:font-options-hint-style options)))
      (is (eq :default (cairo:font-options-hint-metrics options)))
      (is-false (cairo:font-options-variations options)))))

;;;     cairo_set_font_size

;;;     cairo_set_font_matrix
;;;     cairo_get_font_matrix

;;;     cairo_set_font_options
;;;     cairo_get_font_options

(test cairo-font-options
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    (let ((options (cairo:font-options context)))
      (is (cffi:pointerp options))
      (is (eq :default (cairo:font-options-antialias options)))
      (is (eq :default (cairo:font-options-subpixel-order options)))
      (is (eq :default (cairo:font-options-hint-style options)))
      (is (eq :default (cairo:font-options-hint-metrics options)))
      (is-false (cairo:font-options-variations options)))))

;;;     cairo_set_font_face
;;;     cairo_get_font_face

;;;     cairo_set_scaled_font
;;;     cairo_get_scaled_font

;;;     cairo_show_text

(test cairo-show-text
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    (is-false (cairo:show-text context ""))
    (is-false (cairo:show-text context "Ägypten"))
    (is-false (cairo:show-text context nil))
    (is-false (cairo:show-text context (cffi:null-pointer)))))

;;;     cairo_show_glyphs

(test cairo-show-glyphs.1
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    (let* ((glyphs '((35 10 30) (36 30 30) (37 50 30)))
           (num-glyphs (length glyphs)))
      (cffi:with-foreign-object (glyphs-ptr '(:struct cairo:glyph-t) num-glyphs)
        (loop for count from 0 below num-glyphs
              for glyph in glyphs
              for glyph-ptr = (cffi:mem-aptr glyphs-ptr
                                             '(:struct cairo:glyph-t)
                                             count)
              do (setf (cffi:foreign-slot-value glyph-ptr
                                                '(:struct cairo:glyph-t)
                                                'cairo::index)
                       (first glyph)
                       (cffi:foreign-slot-value glyph-ptr
                                           '(:struct cairo:glyph-t)
                                           'cairo::x)
                       (coerce (second glyph) 'double-float)
                       (cffi:foreign-slot-value glyph-ptr
                                           '(:struct cairo:glyph-t)
                                           'cairo::y)
                       (coerce (third glyph) 'double-float)))
        ;; Clear surface
        (cairo:set-source-rgb context 1.0 1.0 1.0)
        (cairo:paint context)
        ;; Draw in black ink.
        (cairo:set-source-rgba context 0.0 0.0 0.0 1.0)
        ;; Choose a font type and set its size.
        (cairo:select-font-face context "Sans")
        (cairo:set-font-size context 18.0)
        ;; Show the array of glyphs
        (cairo::%show-glyphs context glyphs-ptr num-glyphs)
        ;; Create and save the PNG image.
        (cairo:surface-write-to-png (cairo:target context)
                                    (sys-path "out/image1.png"))))))

(test cairo-show-glyphs.2
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    (let ((glyphs '((35 10 30) (36 30 30) (37 50 30))))
      ;; Clear surface
      (cairo:set-source-rgb context 1.0 1.0 1.0)
      (cairo:paint context)
      ;; Draw in black ink.
      (cairo:set-source-rgba context 0.0 0.0 0.0 1.0)
      ;; Choose a font type and set its size.
      (cairo:select-font-face context "Sans")
      (cairo:set-font-size context 18.0)
      ;; Show the list of glyphs
      (cairo:show-glyphs context glyphs)
      ;; Create and save the PNG image.
      (cairo:surface-write-to-png (cairo:target context)
                                  (sys-path "out/image2.png")))))

;;;     cairo_show_text_glyphs

;;;     cairo_font_extents

(test cairo-font-extents
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    ;; Set a font and a font size
    (cairo:select-font-face context "Sans")
    (cairo:set-font-size context 18)
    (multiple-value-bind (ascent descent height max-x-advance max-y-advance)
        (cairo:font-extents context)
      ;; Check the values
      (is (typep ascent 'double-float))
      (is (typep descent 'double-float))
      (is (typep height 'double-float))
      (is (typep max-x-advance 'double-float))
      (is (typep max-y-advance 'double-float)))))

#+crategus
(test cairo-font-extents
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    ;; Set a font and a font size
    (cairo:select-font-face context "Sans")
    (cairo:set-font-size context 18)
    (multiple-value-bind (ascent descent height max-x-advance max-y-advance)
        (cairo:font-extents context)
      ;; Check the values
      (is (approx-equal 20.0 ascent))
      (is (approx-equal  6.0 descent))
      (is (approx-equal 25.0 height))
      (is (approx-equal 51.0 max-x-advance))
      (is (approx-equal  0.0 max-y-advance)))))

#+windows
(test cairo-font-extents
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    ;; Set a font and a font size
    (cairo:select-font-face context "Sans")
    (cairo:set-font-size context 18)
    (multiple-value-bind (ascent descent height max-x-advance max-y-advance)
        (cairo:font-extents context)
      ;; Check the values
      (is (approx-equal  17.0 ascent))
      (is (approx-equal   4.0 descent))
      (is (approx-equal  21.0 height))
      (is (approx-equal 252.0 max-x-advance))
      (is (approx-equal   0.0 max-y-advance)))))

;;;     cairo_text_extents

#-windows
(test cairo-text-extents
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    ;; Set a font and a font size
    (cairo:select-font-face context "Sans")
    (cairo:set-font-size context 18)
    (multiple-value-bind (x-bearing y-bearing width height x-advance y-advance)
        (cairo:text-extents context "Crategus")
      ;; Check the returned values
      (is (approx-equal   1.0 x-bearing))
      (is (approx-equal -13.0 y-bearing))
      (is (approx-equal  79.0 width))
      (is (approx-equal  17.0 height))
      (is (approx-equal  80.0 x-advance))
      (is (approx-equal   0.0 y-advance)))))

#+windows
(test cairo-text-extents
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    ;; Set a font and a font size
    (cairo:select-font-face context "Sans")
    (cairo:set-font-size context 18)
    (multiple-value-bind (x-bearing y-bearing width height x-advance y-advance)
        (cairo:text-extents context "Crategus")
      ;; Check the returned values
      (is (approx-equal  -0.1 x-bearing))
      (is (approx-equal -13.0 y-bearing))
      (is (approx-equal  79.0 width))
      (is (approx-equal  18.9 height))
      (is (approx-equal  80.0 x-advance))
      (is (approx-equal   0.0 y-advance)))))

;;;     cairo_glyph_extents

#-windows
(test cairo-glyph-extents
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    ;; Set a font and a font size
    (cairo:select-font-face context "Sans")
    (cairo:set-font-size context 18)
    (multiple-value-bind (x-bearing y-bearing width height x-advance y-advance)
        (cairo:glyph-extents context '((36 10 20)))
    ;; Check the returned values
    (is (approx-equal  -0.0 x-bearing))
    (is (approx-equal -13.0 y-bearing))
    (is (approx-equal  13.0 width))
    (is (approx-equal  13.0 height))
    (is (approx-equal  12.0 x-advance))
    (is (approx-equal   0.0 y-advance)))))

#+windows
(test cairo-glyph-extents
  (cairo:with-context-for-image-surface (context :rgb24 400 300)
    ;; Set a font and a font size
    (cairo:select-font-face context "Sans")
    (cairo:set-font-size context 18)
    (multiple-value-bind (x-bearing y-bearing width height x-advance y-advance)
        (cairo:glyph-extents context '((36 10 20)))
    ;; Check the returned values
    (is (approx-equal  -1.0 x-bearing))
    (is (approx-equal -13.0 y-bearing))
    (is (approx-equal  13.0 width))
    (is (approx-equal  14.9 height))
    (is (approx-equal  12.0 x-advance))
    (is (approx-equal   0.0 y-advance)))))

;;;     cairo_toy_font_face_create
;;;     cairo_toy_font_face_get_family
;;;     cairo_toy_font_face_get_slant
;;;     cairo_toy_font_face_get_weight

(test cairo-toy-font-face-create
  (cairo:with-toy-font-face (face "Sans" :italic :bold)
    (is (string= "Sans" (cairo:toy-font-face-family face)))
    (is (eq :italic (cairo:toy-font-face-slant face)))
    (is (eq :bold (cairo:toy-font-face-weight face)))))

;;;     cairo_glyph_allocate
;;;     cairo_glyph_free
;;;     cairo_text_cluster_allocate
;;;     cairo_text_cluster_free

;;; 2024-1-12
