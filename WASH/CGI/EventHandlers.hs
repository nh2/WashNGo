-- © 2002 Peter Thiemann
module WASH.CGI.EventHandlers where

import WASH.CGI.HTMLWrapper

--abort
onAbort :: Monad m => String -> WithHTML x m ()
onAbort = attr_SS "onabort"
-- ^The user aborts the loading of an image (for example by clicking a link or
-- clicking the Stop button). 

--blur
onBlur :: Monad m => String -> WithHTML x m ()
onBlur = attr_SS "onblur"
-- ^A form element loses focus or when a window or frame loses focus.

--change
onChange :: Monad m => String -> WithHTML x m ()
onChange = attr_SS "onchange"
-- ^A select, text, or textarea field loses focus and its value has been modified.

--click
onClick :: Monad m => String -> WithHTML x m ()
onClick = attr_SS "onclick"
-- ^An object on a form is clicked.

--dblclick
onDblClick :: Monad m => String -> WithHTML x m ()
onDblClick = attr_SS "ondblclick"
-- ^The user double-clicks a form element or a link.

--dragdrop
onDragDrop :: Monad m => String -> WithHTML x m ()
onDragDrop = attr_SS "ondragdrop"
-- ^The user drops an object onto the browser window, such as dropping a file on
-- the browser window. 

--error
onError :: Monad m => String -> WithHTML x m ()
onError = attr_SS "onerror"
-- ^The loading of a document or image causes an error.

--focus
onFocus :: Monad m => String -> WithHTML x m ()
onFocus = attr_SS "onfocus"
-- ^A window, frame, or frameset receives focus or when a form element receives
-- input focus. 

--keydown
onKeyDown :: Monad m => String -> WithHTML x m ()
onKeyDown = attr_SS "onkeydown"
-- ^The user depresses a key.

--keypress
onKeyPress :: Monad m => String -> WithHTML x m ()
onKeyPress = attr_SS "onkeypress"
-- ^The user presses or holds down a key.

--keyup
onKeyUp :: Monad m => String -> WithHTML x m ()
onKeyUp = attr_SS "onkeyup"
-- ^The user releases a key.

--load
onLoad :: Monad m => String -> WithHTML x m ()
onLoad = attr_SS "onload"
-- ^The browser finishes loading a window or all of the frames within a FRAMESET tag.

--mousedown
onMouseDown :: Monad m => String -> WithHTML x m ()
onMouseDown = attr_SS "onmousedown"
-- ^The user depresses a mouse button.

--mousemove
onMouseMove :: Monad m => String -> WithHTML x m ()
onMouseMove = attr_SS "onmousemove"
-- ^The user moves the cursor.

--mouseout
onMouseOut :: Monad m => String -> WithHTML x m ()
onMouseOut = attr_SS "onmouseout"
-- ^The cursor leaves an area (client-side image map) or link from inside that
-- area or link. 

--mouseover
onMouseOver :: Monad m => String -> WithHTML x m ()
onMouseOver = attr_SS "onmouseover"
-- ^The cursor moves over an object or area from outside that object or area.

--mouseup
onMouseUp :: Monad m => String -> WithHTML x m ()
onMouseUp = attr_SS "onmouseup"
-- ^The user releases a mouse button.

--move
onMove :: Monad m => String -> WithHTML x m ()
onMove = attr_SS "onmove"
-- ^The user or script moves a window or frame.

--reset
onReset :: Monad m => String -> WithHTML x m ()
onReset = attr_SS "onreset"
-- ^The user resets a form (clicks a Reset button).

--resize
onResize :: Monad m => String -> WithHTML x m ()
onResize = attr_SS "onresize"
-- ^The user or script resizes a window or frame.

--select
onSelect :: Monad m => String -> WithHTML x m ()
onSelect = attr_SS "onselect"
-- ^The user selects some of the text within a text or textarea field.

--submit
onSubmit :: Monad m => String -> WithHTML x m ()
onSubmit = attr_SS "onsubmit"
-- ^The user submits a form. Event handler must return true to continue
-- submission. Returning false concels submission.

--unload
onUnload :: Monad m => String -> WithHTML x m ()
onUnload = attr_SS "onunload"
-- ^The user exits a document.

-- specialized event handlers
-- |Redirect result of form submission to specific target. Attach to submission
-- button. 
toTarget :: Monad m => String -> WithHTML x m ()
toTarget t = onClick ("this.form.target='" ++ t ++ "'; this.form.submit(); return true")
