;;; ----------------------------------------------------------------------------
;;; cairo.surface.lisp
;;;
;;; The documentation of the file is taken from the Cairo Reference Manual
;;; Version 1.16 and modified to document the Lisp binding to the Cairo
;;; library. See <http://cairographics.org>. The API documentation of the
;;; Lisp binding is available at <http://www.crategus.com/books/cl-cffi-gtk/>.
;;;
;;; Copyright (C) 2012 - 2023 Dieter Kaiser
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU Lesser General Public License for Lisp
;;; as published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version and with a preamble to
;;; the GNU Lesser General Public License that clarifies the terms for use
;;; with Lisp programs and is referred as the LLGPL.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU Lesser General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with this program and the preamble to the Gnu Lesser
;;; General Public License.  If not, see <http://www.gnu.org/licenses/>
;;; and <http://opensource.franz.com/preamble.html>.
;;; ----------------------------------------------------------------------------
;;;
;;; cairo_surface_t
;;;
;;;     Base class for surfaces
;;;
;;; Types and Values
;;;
;;;     CAIRO_HAS_MIME_SURFACE
;;;     CAIRO_MIME_TYPE_CCITT_FAX
;;;     CAIRO_MIME_TYPE_CCITT_FAX_PARAMS
;;;     CAIRO_MIME_TYPE_EPS
;;;     CAIRO_MIME_TYPE_EPS_PARAMS
;;;     CAIRO_MIME_TYPE_JBIG2
;;;     CAIRO_MIME_TYPE_JBIG2_GLOBAL
;;;     CAIRO_MIME_TYPE_JBIG2_GLOBAL_ID
;;;     CAIRO_MIME_TYPE_JP2
;;;     CAIRO_MIME_TYPE_JPEG
;;;     CAIRO_MIME_TYPE_PNG
;;;     CAIRO_MIME_TYPE_URI
;;;     CAIRO_MIME_TYPE_UNIQUE_ID
;;;
;;;     cairo_surface_t
;;;     cairo_content_t
;;;     cairo_surface_type_t
;;;
;;;     cairo_format_t                 <- cairo.image-surface.lisp
;;;
;;; Functions
;;;
;;;     cairo_surface_create_similar
;;;     cairo_surface_create_similar_image
;;;     cairo_surface_create_for_rectangle
;;;     cairo_surface_reference
;;;     cairo_surface_destroy
;;;     cairo_surface_status
;;;     cairo_surface_finish
;;;     cairo_surface_flush
;;;     cairo_surface_get_device
;;;     cairo_surface_get_font_options
;;;     cairo_surface_get_content
;;;     cairo_surface_mark_dirty
;;;     cairo_surface_mark_dirty_rectangle
;;;     cairo_surface_set_device_offset
;;;     cairo_surface_get_device_offset
;;;     cairo_surface_get_device_scale
;;;     cairo_surface_set_device_scale
;;;     cairo_surface_set_fallback_resolution
;;;     cairo_surface_get_fallback_resolution
;;;
;;;     cairo_surface_get_type
;;;     cairo_surface_get_reference_count
;;;     cairo_surface_set_user_data
;;;     cairo_surface_get_user_data
;;;     cairo_surface_copy_page
;;;     cairo_surface_show_page
;;;     cairo_surface_has_show_text_glyphs
;;;     cairo_surface_set_mime_data
;;;     cairo_surface_get_mime_data
;;;     cairo_surface_supports_mime_type
;;;     cairo_surface_map_to_image
;;;     cairo_surface_unmap_image
;;;
;;; Description
;;;
;;; cairo_surface_t is the abstract type representing all different drawing
;;; targets that cairo can render to. The actual drawings are performed using
;;; a Cairo context.
;;;
;;; A cairo surface is created by using backend-specific constructors,
;;; typically of the form cairo_backend_surface_create().
;;;
;;; Most surface types allow accessing the surface without using Cairo
;;; functions. If you do this, keep in mind that it is mandatory that you call
;;; cairo_surface_flush() before reading from or writing to the surface and
;;; that you must use cairo_surface_mark_dirty() after modifying it.
;;;
;;; Example 1. Directly modifying an image surface
;;;
;;; void
;;; modify_image_surface (cairo_surface_t *surface)
;;; {
;;;   unsigned char *data;
;;;   int width, height, stride;
;;;
;;;   // flush to ensure all writing to the image was done
;;;   cairo_surface_flush (surface);
;;;
;;;   // modify the image
;;;   data = cairo_image_surface_get_data (surface);
;;;   width = cairo_image_surface_get_width (surface);
;;;   height = cairo_image_surface_get_height (surface);
;;;   stride = cairo_image_surface_get_stride (surface);
;;;   modify_image_data (data, width, height, stride);
;;;
;;;   // mark the image dirty so Cairo clears its caches.
;;;   cairo_surface_mark_dirty (surface);
;;; }
;;;
;;; Note that for other surface types it might be necessary to acquire the
;;; surface's device first. See cairo_device_acquire() for a discussion of
;;; devices.
;;; ----------------------------------------------------------------------------

(in-package :cairo)

;;; ----------------------------------------------------------------------------
;;; CAIRO_HAS_MIME_SURFACE
;;;
;;; #define CAIRO_HAS_MIME_SURFACE 1
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_CCITT_FAX
;;;
;;; #define CAIRO_MIME_TYPE_CCITT_FAX "image/g3fax"
;;;
;;; Group 3 or Group 4 CCITT facsimile encoding (International Telecommunication
;;; Union, Recommendations T.4 and T.6.)
;;;
;;; Since 1.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_CCITT_FAX_PARAMS
;;;
;;; #define CAIRO_MIME_TYPE_CCITT_FAX_PARAMS "application/x-cairo.ccitt.params"
;;;
;;; Decode parameters for Group 3 or Group 4 CCITT facsimile encoding. See
;;; CCITT Fax Images.
;;;
;;; Since 1.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_EPS
;;;
;;; #define CAIRO_MIME_TYPE_EPS "application/postscript"
;;;
;;; Encapsulated PostScript file. Encapsulated PostScript File Format
;;; Specification
;;;
;;; Since 1.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_EPS_PARAMS
;;;
;;; #define CAIRO_MIME_TYPE_EPS_PARAMS "application/x-cairo.eps.params"
;;;
;;; Embedding parameters Encapsulated PostScript data. See Embedding EPS files.
;;;
;;; Since 1.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_JBIG2
;;;
;;; #define CAIRO_MIME_TYPE_JBIG2 "application/x-cairo.jbig2"
;;;
;;; Joint Bi-level Image Experts Group image coding standard (ISO/IEC 11544).
;;;
;;; Since 1.14
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_JBIG2_GLOBAL
;;;
;;; #define CAIRO_MIME_TYPE_JBIG2_GLOBAL "application/x-cairo.jbig2-global"
;;;
;;; Joint Bi-level Image Experts Group image coding standard (ISO/IEC 11544)
;;; global segment.
;;;
;;; Since 1.14
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_JBIG2_GLOBAL_ID
;;;
;;; #define CAIRO_MIME_TYPE_JBIG2_GLOBAL_ID
;;;         "application/x-cairo.jbig2-global-id"
;;;
;;; An unique identifier shared by a JBIG2 global segment and all JBIG2 images
;;; that depend on the global segment.
;;;
;;; Since 1.14
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_JP2
;;;
;;; #define CAIRO_MIME_TYPE_JP2 "image/jp2"
;;;
;;; The Joint Photographic Experts Group (JPEG) 2000 image coding standard
;;; (ISO/IEC 15444-1).
;;;
;;; Since 1.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_JPEG
;;;
;;; #define CAIRO_MIME_TYPE_JPEG "image/jpeg"
;;;
;;; The Joint Photographic Experts Group (JPEG) image coding standard (ISO/IEC
;;; 10918-1).
;;;
;;; Since 1.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_PNG
;;;
;;; #define CAIRO_MIME_TYPE_PNG "image/png"
;;;
;;; The Portable Network Graphics image file format (ISO/IEC 15948).
;;;
;;; Since 1.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_URI
;;;
;;; #define CAIRO_MIME_TYPE_URI "text/x-uri"
;;;
;;; URI for an image file (unofficial MIME type).
;;;
;;; Since 1.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; CAIRO_MIME_TYPE_UNIQUE_ID
;;;
;;; #define CAIRO_MIME_TYPE_UNIQUE_ID "application/x-cairo.uuid"
;;;
;;; Unique identifier for a surface (cairo specific MIME type).
;;;
;;; Since 1.12
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_t
;;; ----------------------------------------------------------------------------

(defcstruct surface-t)

#+liber-documentation
(setf (liber:alias-for-symbol 'surface-t)
      "CStruct"
      (liber:symbol-documentation 'surface-t)
 "@version{#2020-12-16}
  @begin{short}
    A @sym{cairo:surface-t} structure represents an image, either as the
    destination of a drawing operation or as source when drawing onto another
    surface.
  @end{short}
  To draw to a @sym{cairo:surface-t} structure, create a Cairo context with the
  surface as the target, using the @fun{cairo:create} function.

  There are different subtypes of a @sym{cairo:surface-t} structure for
  different drawing backends. For example, the
  @fun{cairo:image-surface-create} function creates a bitmap image in memory.
  The type of a surface can be queried with the @fun{cairo:surface-type}
  function.

  The initial contents of a surface after creation depend upon the manner of
  its creation. If Cairo creates the surface and backing storage for the user,
  it will be initially cleared; for example, the
  @fun{cairo:image-surface-create} and @fun{cairo:surface-create-similar}
  functions. Alternatively, if the user passes in a reference to some backing
  storage and asks Cairo to wrap that in a @sym{cairo:surface-t} structure,
  then the contents are not modified; for example, the
  @fun{cairo:image-surface-create-for-data} function.

  Memory management of a @sym{cairo:surface-t} structure is done with the
  @fun{cairo:surface-reference} and @fun{cairo:surface-destroy} functions.
  @see-function{cairo:create}
  @see-function{cairo:image-surface-create}
  @see-function{cairo:surface-create-similar}
  @see-function{cairo:surface-type}
  @see-function{cairo:image-surface-create-for-data}
  @see-function{cairo:surface-reference}
  @see-function{cairo:surface-destroy}")

(export 'surface-t)

;;; ----------------------------------------------------------------------------
;;; enum cairo_content_t
;;; ----------------------------------------------------------------------------

(defcenum content-t
  (:color #x1000)
  (:alpha #x2000)
  (:color-alpha #x3000))

#+liber-documentation
(setf (liber:alias-for-symbol 'content-t)
      "CEnum"
      (liber:symbol-documentation 'content-t)
 "@version{#2021-5-13}
  @begin{short}
    The @sym{cairo:content-t} enumeration is used to describe the content that
    a surface will contain, whether color information, alpha information
    (translucence vs. opacity), or both.
  @end{short}

  Note: The large values here are designed to keep @sym{cairo:content-t} values
  distinct from @symbol{cairo:format-t} values so that the implementation can
  detect the error if users confuse the two types.
  @begin{pre}
(defcenum content-t
  (:color #x1000)
  (:alpha #x2000)
  (:color-alpha #x3000))
  @end{pre}
  @begin[code]{table}
    @entry[:color]{The surface will hold color content only.}
    @entry[:alpha]{The surface will hold alpha content only.}
    @entry[:color-alpha]{The surface will hold color and alpha content.}
  @end{table}
  @see-symbol{cairo:format-t}")

(export 'content-t)

;;; ----------------------------------------------------------------------------
;;; enum cairo_surface_type_t
;;; ----------------------------------------------------------------------------

(defcenum surface-type-t
  :image
  :pdf
  :ps
  :xlib
  :xcb
  :glitz
  :quartz
  :win32
  :beos
  :directfb
  :svg
  :os2
  :win32-printing
  :quartz-image
  :script
  :qt
  :recording
  :vg
  :gl
  :drm
  :tee
  :xml
  :skia
  :subsurface
  :cogl)

#+liber-documentation
(setf (liber:alias-for-symbol 'surface-type-t)
      "CEnum"
      (liber:symbol-documentation 'surface-type-t)
 "@version{#2020-12-16}
  @begin{short}
    The @sym{cairo:surface-type-t} enumeration is used to describe the type of
    a given surface.
  @end{short}
  The surface types are also known as \"backends\" or \"surface backends\"
  within Cairo.

  The type of a surface is determined by the function used to create it, which
  will generally be of the form @code{cairo:type-surface-create}, though see
  the @fun{cairo:surface-create-similar} function as well.

  The surface type can be queried with the @fun{cairo:surface-type} function.

  The various @symbol{cairo:surface-t} functions can be used with surfaces of
  any type, but some backends also provide type-specific functions that must
  only be called with a surface of the appropriate type. These functions have
  names that begin with @code{cairo:type-surface} such as the
  @fun{cairo:image-surface-width} function.

  The behavior of calling a type-specific function with a surface of the wrong
  type is undefined.

  New entries may be added in future versions.
  @begin{pre}
(defcenum surface-type-t
  :image
  :pdf
  :ps
  :xlib
  :xcb
  :glitz
  :quartz
  :win32
  :beos
  :directfb
  :svg
  :os2
  :win32-printing
  :quartz-image
  :script
  :qt
  :recording
  :vg
  :gl
  :drm
  :tee
  :xml
  :skia
  :subsurface
  :cogl)
  @end{pre}
  @begin[code]{table}
    @entry[:image]{The surface is of type image.}
    @entry[:pdf]{The surface is of type pdf.}
    @entry[:ps]{The surface is of type ps.}
    @entry[:xlib]{The surface is of type xlib.}
    @entry[:xcb]{The surface is of type xcb.}
    @entry[:glitz]{The surface is of type glitz.}
    @entry[:quartz]{The surface is of type quartz.}
    @entry[:win32]{The surface is of type win32.}
    @entry[:beos]{The surface is of type beos.}
    @entry[:directfb]{The surface is of type directfb.}
    @entry[:svg]{The surface is of type svg.}
    @entry[:os2]{The surface is of type os2.}
    @entry[:win32-printing]{The surface is a win32 printing surface.}
    @entry[:quartz-image]{The surface is of type quartz_image.}
    @entry[:script]{The surface is of type script.}
    @entry[:qt]{The surface is of type Qt.}
    @entry[:recording]{The surface is of type recording.}
    @entry[:vg]{The surface is a OpenVG surface.}
    @entry[:gl]{The surface is of type OpenGL.}
    @entry[:drm]{The surface is of type Direct Render Manager.}
    @entry[:tee]{The surface is of type 'tee' (a multiplexing surface).}
    @entry[:xml]{The surface is of type XML (for debugging).}
    @entry[:skia]{The surface is of type Skia.}
    @entry[:subsurface]{The surface is a subsurface created with the
      @fun{cairo:surface-create-for-rectangle} function.}
    @entry[:cogl]{This surface is of type Cogl.}
  @end{table}
  @see-symbol{cairo:surface-t}
  @see-function{cairo:surface-create-similar}
  @see-function{cairo:surface-type}
  @see-function{cairo:image-surface-width}
  @see-function{cairo:surface-create-for-rectangle}")

(export 'surface-type-t)

;;; ----------------------------------------------------------------------------
;;; enum cairo_format_t
;;; ----------------------------------------------------------------------------

(defcenum format-t
  (:invalid -1)
  (:argb32 0)
  (:rgb24 1)
  (:a8 2)
  (:a1 3)
  (:rgb16-565 4)
  (:rgb30 5))

#+liber-documentation
(setf (liber:alias-for-symbol 'format-t)
      "CEnum"
      (liber:symbol-documentation 'format-t)
 "@version{#2020-12-16}
  @begin{short}
    The @sym{cairo:format-t} enumeration is used to identify the memory format
    of image data.
  @end{short}
  New entries may be added in future versions.
  @begin{pre}
(defcenum format-t
  (:invalid -1)
  (:argb32 0)
  (:rgb24 1)
  (:a8 2)
  (:a1 3)
  (:rgb16-565 4)
  (:rgb30 5))
  @end{pre}
  @begin[code]{table}
    @entry[:invalid]{No such format exists or is supported.}
    @entry[:argb32]{Each pixel is a 32-bit quantity, with alpha in the upper
      8 bits, then red, then green, then blue. The 32-bit quantities are stored
      native-endian. Pre-multiplied alpha is used. That is, 50 % transparent
      red is 0x80800000, not 0x80ff0000.}
    @entry[:rgb24]{Each pixel is a 32-bit quantity, with the upper 8 bits
      unused. Red, Green, and Blue are stored in the remaining 24 bits in that
      order.}
    @entry[:a8]{Each pixel is a 8-bit quantity holding an alpha value.}
    @entry[:a1]{Each pixel is a 1-bit quantity holding an alpha value. Pixels
      are packed together into 32-bit quantities. The ordering of the bits
      matches the endianess of the platform. On a big-endian machine, the first
      pixel is in the uppermost bit, on a little-endian machine the first pixel
      is in the least-significant bit.}
    @entry[:rgb16-565]{Each pixel is a 16-bit quantity with red in the upper 5
      bits, then green in the middle 6 bits, and blue in the lower 5 bits.}
    @entry[:rgb30]{Like @code{:rgb24} but with 10 bpc.}
  @end{table}
  @see-symbol{cairo:surface-t}")

(export 'format-t)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_create_similar ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_create_similar" surface-create-similar)
    (:pointer (:struct surface-t))
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[other]{an existing @symbol{cairo:surface-t} instance used to select
    the backend of the new surface}
  @argument[content]{a value of the @symbol{cairo:content-t} enumeration for
    the content for the new surface}
  @argument[width]{an integer with the width of the new surface,
    (in device-space units)}
  @argument[height]{an integer with the height of the new surface
    (in device-space units)}
  @begin{return}
    A pointer to the newly allocated surface. The caller owns the surface
    and should call the @fun{cairo:surface-destroy} function when done with it.
    This function always returns a valid pointer, but it will return a pointer
    to a \"nil\" surface if other is already in an error state or any other
    error occurs.
  @end{return}
  @begin{short}
    Create a new surface that is as compatible as possible with an existing
    surface.
  @end{short}
  For example the new surface will have the same fallback resolution and font
  options as @arg{other}. Generally, the new surface will also use the same
  backend as other, unless that is not possible for some reason. The type of
  the returned surface may be examined with the @fun{cairo:surface-type}
  function.

  Initially the surface contents are all 0; transparent if contents have
  transparency, black otherwise.

  Use the @fun{cairo:surface-create-similar-image} function if you need an
  image surface which can be painted quickly to the target surface.
  @see-symbol{cairo:surface-t}
  @see-symbol{cairo:content-t}
  @see-function{cairo:surface-destroy}
  @see-function{cairo:surface-create-similar-image}"
  (other (:pointer (:struct surface-t)))
  (content content-t)
  (width :int)
  (height :int))

(export 'surface-create-similar)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_create_similar_image ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_create_similar_image"
           surface-create-similar-image) (:pointer (:struct surface-t))
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[other]{an existing @symbol{cairo:surface-t} instance used to select
    the preference of the new surface}
  @argument[format]{a @symbol{cairo:format-t} value for the new surface}
  @argument[width]{an integer with the width of the new surface, in
    device-space units}
  @argument[height]{an integer with the height of the new surface, in
    device-space units}
  @begin{return}
    A pointer to the newly allocated image surface. The caller owns the
    surface and should call the @fun{cairo:surface-destroy} function when done
    with it. This function always returns a valid pointer, but it will return a
    pointer to a \"nil\" surface if other is already in an error state or any
    other error occurs.
  @end{return}
  @begin{short}
    Create a new image surface that is as compatible as possible for uploading
    to and the use in conjunction with an existing surface.
  @end{short}
  However, this surface can still be used like any normal image surface.

  Initially the surface contents are all 0, transparent if contents have
  transparency, black otherwise.

  Use the @fun{cairo:surface-create-similar} if you do not need an image
  surface.
  @see-symbol{cairo:surface-t}
  @see-symbol{cairo:format-t}
  @see-function{cairo:surface-destroy}
  @see-function{cairo:surface-create-similar}"
  (other (:pointer (:struct surface-t)))
  (format format-t)
  (width :int)
  (height :int))

(export 'surface-create-similar-image)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_create_for_rectangle ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_create_for_rectangle" surface-create-for-rectangle)
    (:pointer (:struct surface-t))
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[target]{an existing @symbol{cairo:surface-t} instance for which
    the sub-surface will point to}
  @argument[x]{a double float x-origin of the sub-surface from the top-left
    of the target surface, in device-space units}
  @argument[y]{a double float y-origin of the sub-surface from the top-left
    of the target surface, in device-space units}
  @argument[width]{a double float with the width of the sub-surface,
    in device-space units}
  @argument[height]{a double float with the height of the sub-surface,
    in device-space units}
  @begin{return}
    A pointer to the newly allocated surface. The caller owns the surface
    and should call the @fun{cairo:surface-destroy} when done with it.
    This function always returns a valid pointer, but it will return a pointer
    to a \"nil\" surface if other is already in an error state or any other
    error occurs.
  @end{return}
  @begin{short}
    Create a new surface that is a rectangle within the target surface.
  @end{short}
  All operations drawn to this surface are then clipped and translated onto
  the target surface. Nothing drawn via this sub-surface outside of its bounds
  is drawn onto the target surface, making this a useful method for passing
  constrained child surfaces to library routines that draw directly onto the
  parent surface, i.e. with no further backend allocations, double buffering
  or copies.
  @begin[Note]{dictionary}
    The semantics of subsurfaces have not been finalized yet unless the
    rectangle is in full device units, is contained within the extents of the
    target surface, and the target or subsurface's device transforms are not
    changed.
  @end{dictionary}
  @see-symbol{cairo:surface-t}
  @see-function{cairo:surface-destroy}"
  (target (:pointer (:struct surface-t)))
  (x :double)
  (y :double)
  (width :double)
  (height :double))

(export 'surface-create-for-rectangle)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_reference ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_reference" surface-reference)
    (:pointer (:struct surface-t))
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @return{The referenced @symbol{cairo:surface-t} instance.}
  @begin{short}
    Increases the reference count on @arg{surface} by one.
  @end{short}
  This prevents @arg{surface} from being destroyed until a matching call to
  the @fun{cairo:surface-destroy} function is made.

  The number of references to a @symbol{cairo:surface-t} instance can be get
  using the @fun{cairo:surface-reference-count} function.
  @see-symbol{cairo:surface-t}
  @see-function{cairo:surface-destroy}
  @see-function{cairo:surface-reference-count}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-reference)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_destroy ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_destroy" surface-destroy) :void
 #+liber-documentation
 "@version{2023-2-3}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @begin{short}
    Decreases the reference count on @arg{surface} by one.
  @end{short}
  If the result is zero, then @arg{surface} and all associated resources are
  freed. See the @fun{cairo:surface-reference} function.
  @see-symbol{cairo:surface-t}
  @see-function{cairo:surface-reference}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-destroy)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_status ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_status" surface-status) status-t
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @begin{return}
    @code{:success}, @code{:null-pointer}, @code{:no-memory},
    @code{:read-error}, @code{:invalid-content}, @code{:invalid-format}, or
    @code{:invalid-visual}.
  @end{return}
  @begin{short}
    Checks whether an error has previously occurred for this surface.
  @end{short}
  @see-symbol{cairo:surface-t}
  @see-symbol{cairo:status-t}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-status)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_finish ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_finish" surface-finish) :void
 #+liber-documentation
 "@version{#2020-12-21}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @begin{short}
    This function finishes the surface and drops all references to external
    resources.
  @end{short}
  For example, for the Xlib backend it means that Cairo will no longer access
  the drawable, which can be freed. After calling the @fun{cairo:surface-finish}
  function the only valid operations on a surface are getting and setting user,
  referencing and destroying, and flushing and finishing it. Further drawing to
  the surface will not affect the surface but will instead trigger a
  @code{:surface-finished} error.

  When the last call to the @fun{cairo:surface-destroy} function decreases the
  reference count to zero, Cairo will call the @fun{cairo:surface-finish}
  function if it has not been called already, before freeing the resources
  associated with the surface.
  @see-symbol{cairo:surface-t}
  @see-function{cairo:surface-finish}
  @see-function{cairo:surface-destroy}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-finish)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_flush ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_flush" surface-flush) :void
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @begin{short}
    Do any pending drawing for the surface and also restore any temporary
    modifications Cairo has made to the surface's state.
  @end{short}
  This function must be called before switching from drawing on the surface
  with Cairo to drawing on it directly with native APIs. If the surface does not
  support direct access, then this function does nothing.
  @see-symbol{cairo:surface-t}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-flush)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_device ()
;;;
;;; cairo_device_t * cairo_surface_get_device (cairo_surface_t *surface);
;;;
;;; This function returns the device for a surface. See cairo_device_t.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; Returns :
;;;     The device for surface or NULL if the surface does not have an
;;;     associated device.
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_get_device" surface-device)
    (:pointer (:struct device-t))
  (surface (:pointer (:struct surface-t))))

(export 'surface-device)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_font_options ()
;;;
;;; void cairo_surface_get_font_options (cairo_surface_t *surface,
;;;                                      cairo_font_options_t *options);
;;;
;;; Retrieves the default font rendering options for the surface. This allows
;;; display surfaces to report the correct subpixel order for rendering on them,
;;; print surfaces to disable hinting of metrics and so forth. The result can
;;; then be used with cairo_scaled_font_create().
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; options :
;;;     a cairo_font_options_t object into which to store the retrieved options.
;;;     All existing values are overwritten
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_get_font_options" surface-font-options) :void
  (surface (:pointer (:struct surface-t)))
  (options (:pointer (:struct font-options-t))))

(export 'surface-font-options)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_content ()
;;;
;;; cairo_content_t cairo_surface_get_content (cairo_surface_t *surface);
;;;
;;; This function returns the content type of surface which indicates whether
;;; the surface contains color and/or alpha information. See cairo_content_t.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; Returns :
;;;     The content type of surface.
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_get_content" surface-content) content-t
  (surface (:pointer (:struct surface-t))))

(export 'surface-content)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_mark_dirty ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_mark_dirty" surface-mark-dirty) :void
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @begin{short}
    Tells Cairo that drawing has been done to surface using means other than
    Cairo, and that Cairo should reread any cached areas.
  @end{short}
  Note that you must call the @fun{cairo:surface-flush} function before doing
  such drawing.
  @see-symbol{cairo:surface-t}
  @see-function{cairo:surface-flush}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-mark-dirty)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_mark_dirty_rectangle ()
;;;
;;; void cairo_surface_mark_dirty_rectangle (cairo_surface_t *surface,
;;;                                          int x,
;;;                                          int y,
;;;                                          int width,
;;;                                          int height);
;;;
;;; Like cairo_surface_mark_dirty(), but drawing has been done only to the
;;; specified rectangle, so that cairo can retain cached contents for other
;;; parts of the surface.
;;;
;;; Any cached clip set on the surface will be reset by this function, to make
;;; sure that future cairo calls have the clip set that they expect.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; x :
;;;     X coordinate of dirty rectangle
;;;
;;; y :
;;;     Y coordinate of dirty rectangle
;;;
;;; width :
;;;     width of dirty rectangle
;;;
;;; height :
;;;     height of dirty rectangle
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_mark_dirty_rectangle" surface-mark-dirty-rectangle)
    :void
  (surface (:pointer (:struct surface-t)))
  (x :int)
  (y :int)
  (width :int)
  (height :int))

(export 'surface-mark-dirty-rectangle)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_set_device_offset ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_set_device_offset" surface-set-device-offset) :void
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @argument[x-offset]{a double float offset in the x direction, in device units}
  @argument[y-offset]{a double float offset in the y direction, in device units}
  @begin{short}
    Sets an offset that is added to the device coordinates determined by the
    CTM when drawing to surface.
  @end{short}
  One use case for this function is when we want to create a
  @symbol{cairo:surface-t} instance that redirects drawing for a portion of an
  onscreen surface to an offscreen surface in a way that is completely invisible
  to the user of the Cairo API. Setting a transformation via the
  @fun{cairo:translate} function is not sufficient to do this, since functions
  like the @fun{cairo:device-to-user} function will expose the hidden offset.

  Note that the offset affects drawing to the surface as well as using the
  surface in a source pattern.
  @see-symbol{cairo:surface-t}
  @see-function{cairo:translate}
  @see-function{cairo:device-to-user}"
  (surface (:pointer (:struct surface-t)))
  (x-offset :double)
  (y-offset :double))

(export 'surface-set-device-offset)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_device_offset ()
;;;
;;; void cairo_surface_get_device_offset (cairo_surface_t *surface,
;;;                                       double *x_offset,
;;;                                       double *y_offset);
;;;
;;; This function returns the previous device offset set by
;;; cairo_surface_set_device_offset().
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; x_offset :
;;;     the offset in the X direction, in device units
;;;
;;; y_offset :
;;;     the offset in the Y direction, in device units
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_get_device_offset" %surface-get-device-offset) :void
  (surface (:pointer (:struct surface-t)))
  (x-offset (:pointer :double))
  (y-offset (:pointer :double)))

(defun surface-get-device-offset (surface)
  (with-foreign-objects ((x-offset :double) (y-offset :double))
    (%surface-get-device-offset surface x-offset y-offset)
    (values (cffi:mem-ref x-offset :double)
            (cffi:mem-ref y-offset :double))))

(export 'surface-get-device-offset)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_device_scale ()
;;;
;;; void
;;; cairo_surface_get_device_scale (cairo_surface_t *surface,
;;;                                 double *x_scale,
;;;                                 double *y_scale);
;;;
;;; This function returns the previous device offset set by
;;; cairo_surface_set_device_scale().
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; x_scale :
;;;     the scale in the X direction, in device units
;;;
;;; y_scale :
;;;     the scale in the Y direction, in device units
;;;
;;; Since 1.14
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_set_device_scale ()
;;;
;;; void
;;; cairo_surface_set_device_scale (cairo_surface_t *surface,
;;;                                 double x_scale,
;;;                                 double y_scale);
;;;
;;; Sets a scale that is multiplied to the device coordinates determined by the
;;; CTM when drawing to surface . One common use for this is to render to very
;;; high resolution display devices at a scale factor, so that code that assumes
;;; 1 pixel will be a certain size will still work. Setting a transformation via
;;; cairo_translate() isn't sufficient to do this, since functions like
;;; cairo_device_to_user() will expose the hidden scale.
;;;
;;; Note that the scale affects drawing to the surface as well as using the
;;; surface in a source pattern.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; x_scale :
;;;     a scale factor in the X direction
;;;
;;; y_scale :
;;;     a scale factor in the Y direction
;;;
;;; Since 1.14
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_set_fallback_resolution ()
;;;
;;; void cairo_surface_set_fallback_resolution (cairo_surface_t *surface,
;;;                                             double x_pixels_per_inch,
;;;                                             double y_pixels_per_inch);
;;;
;;; Set the horizontal and vertical resolution for image fallbacks.
;;;
;;; When certain operations aren't supported natively by a backend, cairo will
;;; fallback by rendering operations to an image and then overlaying that image
;;; onto the output. For backends that are natively vector-oriented, this
;;; function can be used to set the resolution used for these image fallbacks,
;;; (larger values will result in more detailed images, but also larger file
;;; sizes).
;;;
;;; Some examples of natively vector-oriented backends are the ps, pdf, and svg
;;; backends.
;;;
;;; For backends that are natively raster-oriented, image fallbacks are still
;;; possible, but they are always performed at the native device resolution. So
;;; this function has no effect on those backends.
;;;
;;; Note: The fallback resolution only takes effect at the time of completing a
;;; page (with cairo_show_page() or cairo_copy_page()) so there is currently no
;;; way to have more than one fallback resolution in effect on a single page.
;;;
;;; The default fallback resoultion is 300 pixels per inch in both dimensions.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; x_pixels_per_inch :
;;;     horizontal setting for pixels per inch
;;;
;;; y_pixels_per_inch :
;;;     vertical setting for pixels per inch
;;;
;;; Since 1.2
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_fallback_resolution ()
;;;
;;; void cairo_surface_get_fallback_resolution (cairo_surface_t *surface,
;;;                                             double *x_pixels_per_inch,
;;;                                             double *y_pixels_per_inch);
;;;
;;; This function returns the previous fallback resolution set by
;;; cairo_surface_set_fallback_resolution(), or default fallback resolution if
;;; never set.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; x_pixels_per_inch :
;;;     horizontal pixels per inch
;;;
;;; y_pixels_per_inch :
;;;     vertical pixels per inch
;;;
;;; Since 1.8
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_type ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_get_type" surface-type) surface-type-t
 #+liber-documentation
 "@version{2023-2-3}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @return{A value of the @symbol{cairo:surface-type-t} enumeration.}
  @begin{short}
    This function returns the type of the backend used to create the surface.
  @end{short}
  See the @symbol{cairo:surface-type-t} enumeration for available types.
  @see-symbol{cairo:surface-t}
  @see-symbol{cairo:surface-type-t}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-type)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_reference_count () -> surface-reference-count
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_get_reference_count" surface-reference-count) :uint
 #+liber-documentation
 "@version{#2020-12-16}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @begin{return}
    The current reference count of @arg{surface}. If the instance is a
    @code{nil} instance, 0 will be returned.
  @end{return}
  @begin{short}
    Returns the current reference count of @arg{surface}.
  @end{short}
  @see-symbol{cairo:surface-t}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-reference-count)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_set_user_data ()
;;;
;;; cairo_status_t cairo_surface_set_user_data
;;;                                           (cairo_surface_t *surface,
;;;                                            const cairo_user_data_key_t *key,
;;;                                            void *user_data,
;;;                                            cairo_destroy_func_t destroy);
;;;
;;; Attach user data to surface. To remove user data from a surface, call this
;;; function with the key that was used to set it and NULL for data.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; key :
;;;     the address of a cairo_user_data_key_t to attach the user data to
;;;
;;; user_data :
;;;     the user data to attach to the surface
;;;
;;; destroy :
;;;     a cairo_destroy_func_t which will be called when the surface is
;;;     destroyed or when new user data is attached using the same key.
;;;
;;; Returns :
;;;     CAIRO_STATUS_SUCCESS or CAIRO_STATUS_NO_MEMORY if a slot could not be
;;;     allocated for the user data.
;;;
;;; Since 1.0
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_user_data ()
;;;
;;; void * cairo_surface_get_user_data (cairo_surface_t *surface,
;;;                                     const cairo_user_data_key_t *key);
;;;
;;; Return user data previously attached to surface using the specified key. If
;;; no user data has been attached with the given key this function returns
;;; NULL.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; key :
;;;     the address of the cairo_user_data_key_t the user data was attached to
;;;
;;; Returns :
;;;     the user data previously attached or NULL.
;;;
;;; Since 1.0
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_copy_page ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_copy_page" surface-copy-page) :void
 #+liber-documentation
 "@version{#2020-12-23}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @begin{short}
    Emits the current page for backends that support multiple pages, but does
    not clear it, so that the contents of the current page will be retained for
    the next page.
  @end{short}
  Use the @fun{cairo:surface-show-page} function if you want to get an empty
  page after the emission.

  There is a convenience function for this that takes a @symbol{cairo:context-t}
  context, namely the @fun{cairo:copy-page} function.
  @see-symbol{cairo:surface-t}
  @see-symbol{cairo:context-t}
  @see-function{cairo:surface-show-page}
  @see-function{cairo:copy-page}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-copy-page)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_show_page ()
;;; ----------------------------------------------------------------------------

(defcfun ("cairo_surface_show_page" surface-show-page) :void
 #+liber-documentation
 "@version{#2020-12-23}
  @argument[surface]{a @symbol{cairo:surface-t} instance}
  @begin{short}
    Emits and clears the current page for backends that support multiple pages.
  @end{short}
  Use the function @fun{cairo:surface-copy-page} if you do not want to clear
  the page.

  There is a convenience function that takes a @symbol{cairo:context-t} context,
  namely the @fun{cairo:show-page} function.
  @see-symbol{cairo:surface-t}
  @see-function{cairo:surface-copy-page}
  @see-function{cairo:show-page}"
  (surface (:pointer (:struct surface-t))))

(export 'surface-show-page)

;;; ----------------------------------------------------------------------------
;;; cairo_surface_has_show_text_glyphs ()
;;;
;;; cairo_bool_t cairo_surface_has_show_text_glyphs (cairo_surface_t *surface);
;;;
;;; Returns whether the surface supports sophisticated cairo_show_text_glyphs()
;;; operations. That is, whether it actually uses the provided text and cluster
;;; data to a cairo_show_text_glyphs() call.
;;;
;;; Note: Even if this function returns FALSE, a cairo_show_text_glyphs()
;;; operation targeted at surface will still succeed. It just will act like a
;;; cairo_show_glyphs() operation. Users can use this function to avoid
;;; computing UTF-8 text and cluster mapping if the target surface does not use
;;; it.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; Returns :
;;;     TRUE if surface supports cairo_show_text_glyphs(), FALSE otherwise
;;;
;;; Since 1.8
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_set_mime_data ()
;;;
;;; cairo_status_t cairo_surface_set_mime_data (cairo_surface_t *surface,
;;;                                             const char *mime_type,
;;;                                             const unsigned char *data,
;;;                                             unsigned long  length,
;;;                                             cairo_destroy_func_t destroy,
;;;                                             void *closure);
;;;
;;; Attach an image in the format mime_type to surface. To remove the data from
;;; a surface, call this function with same mime type and NULL for data.
;;;
;;; The attached image (or filename) data can later be used by backends which
;;; support it (currently: PDF, PS, SVG and Win32 Printing surfaces) to emit
;;; this data instead of making a snapshot of the surface. This approach tends
;;; to be faster and requires less memory and disk space.
;;;
;;; The recognized MIME types are the following: CAIRO_MIME_TYPE_JPEG,
;;; CAIRO_MIME_TYPE_PNG, CAIRO_MIME_TYPE_JP2, CAIRO_MIME_TYPE_URI.
;;;
;;; See corresponding backend surface docs for details about which MIME types
;;; it can handle. Caution: the associated MIME data will be discarded if you
;;; draw on the surface afterwards. Use this function with care.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; mime_type :
;;;     the MIME type of the image data
;;;
;;; data :
;;;     the image data to attach to the surface
;;;
;;; length :
;;;     the length of the image data
;;;
;;; destroy :
;;;     a cairo_destroy_func_t which will be called when the surface is
;;;     destroyed or when new image data is attached using the same mime type.
;;;
;;; closure :
;;;     the data to be passed to the destroy notifier
;;;
;;; Returns :
;;;     CAIRO_STATUS_SUCCESS or CAIRO_STATUS_NO_MEMORY if a slot could not be
;;;     allocated for the user data.
;;;
;;; Since 1.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_get_mime_data ()
;;;
;;; void cairo_surface_get_mime_data (cairo_surface_t *surface,
;;;                                   const char *mime_type,
;;;                                   const unsigned char **data,
;;;                                   unsigned long *length);
;;;
;;; Return mime data previously attached to surface using the specified mime
;;; type. If no data has been attached with the given mime type, data is set
;;; NULL.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; mime_type :
;;;     the mime type of the image data
;;;
;;; data :
;;;     the image data to attached to the surface
;;;
;;; length :
;;;     the length of the image data
;;;
;;; Since 1.10
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_supports_mime_type ()
;;;
;;; cairo_bool_t cairo_surface_supports_mime_type (cairo_surface_t *surface,
;;;                                                const char *mime_type);
;;;
;;; Return whether surface supports mime_type.
;;;
;;; surface :
;;;     a cairo_surface_t
;;;
;;; mime_type :
;;;     the mime type
;;;
;;; Returns :
;;;     TRUE if surface supports mime_type, FALSE otherwise
;;;
;;; Since 1.12
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_map_to_image ()
;;;
;;; cairo_surface_t * cairo_surface_map_to_image
;;;                                      (cairo_surface_t *surface,
;;;                                       const cairo_rectangle_int_t *extents);
;;;
;;; Returns an image surface that is the most efficient mechanism for modifying
;;; the backing store of the target surface. The region retrieved may be limited
;;; to the extents or NULL for the whole surface
;;;
;;; Note, the use of the original surface as a target or source whilst it is
;;; mapped is undefined. The result of mapping the surface multiple times is
;;; undefined. Calling cairo_surface_destroy() or cairo_surface_finish() on the
;;; resulting image surface results in undefined behavior.
;;;
;;; surface :
;;;     an existing surface used to extract the image from
;;;
;;; extents :
;;;     limit the extraction to an rectangular region
;;;
;;; Returns :
;;;     a pointer to the newly allocated image surface. The caller must use
;;;     cairo_surface_unmap_image() to destroy this image surface. This function
;;;     always returns a valid pointer, but it will return a pointer to a "nil"
;;;     surface if other is already in an error state or any other error occurs.
;;;
;;; Since 1.12
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; cairo_surface_unmap_image ()
;;;
;;; void cairo_surface_unmap_image (cairo_surface_t *surface,
;;;                                 cairo_surface_t *image);
;;;
;;; Unmaps the image surface as returned from #cairo_surface_map_to_image().
;;;
;;; The content of the image will be uploaded to the target surface. Afterwards,
;;; the image is destroyed.
;;;
;;; Using an image surface which wasn't returned by cairo_surface_map_to_image()
;;; results in undefined behavior.
;;;
;;; surface :
;;;     the surface passed to cairo_surface_map_to_image().
;;;
;;; image :
;;;     the currently mapped image
;;;
;;; Since 1.12
;;; ----------------------------------------------------------------------------

;;; --- End of file cairo.surface.lisp -----------------------------------------
