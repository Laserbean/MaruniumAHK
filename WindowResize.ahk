#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

; Modified by Laserbean

; Easy Window Dragging -- KDE style (requires XP/2k/NT) -- by Jonny
; https://www.autohotkey.com
; This script makes it much easier to move or resize a window: 1) Hold down
; the ALT key and LEFT-click anywhere inside a window to drag it to a new
; location; 2) Hold down ALT and RIGHT-click-drag anywhere inside a window
; to easily resize it; 3) Press ALT twice, but before releasing it the second
; time, left-click to minimize the window under the mouse cursor, right-click
; to maximize it, or middle-click to close it.

; This script was inspired by and built on many like it
; in the forum. Thanks go out to ck, thinkstorm, Chris,
; and aurelian for a job well done.

; Change history:
; November 07, 2006: Optimized resizing code in !RButton, courtesy of bluedawn.
; February 05, 2006: Fixed double-alt (the ~Alt hotkey) to work with latest versions of AHK.

; The Double-Alt modifier is activated by pressing
; Alt twice, much like a double-click. Hold the second
; press down until you click.
;
; The shortcuts:
;  Alt + Left Button  : Drag to move a window.
;  Alt + Right Button : Drag to resize a window.
;  Double-Alt + Left Button   : Minimize a window.
;  Double-Alt + Right Button  : Maximize/Restore a window.
;  Double-Alt + Middle Button : Close a window.
;
; You can optionally release Alt after the first
; click rather than holding it down the whole time.

If (A_AhkVersion < "1.0.39.00")
{
    MsgBox,20,,This script may not work properly with your version of AutoHotkey. Continue?
    IfMsgBox,No
        ExitApp
}

; This is the setting that runs smoothest on my
; system. Depending on your video card and cpu
; power, you may want to raise or lower this value.
SetWinDelay,2

CoordMode,Mouse
return

#LButton::
    ; ; If DoubleAlt
    ; ; {
    ; ;     MouseGetPos,,,KDE_id
    ; ;     ; This message is mostly equivalent to WinMinimize,
    ; ;     ; but it avoids a bug with PSPad.
    ; ;     PostMessage,0x112,0xf020,,,ahk_id %KDE_id%
    ; ;     DoubleAlt := false
    ; ;     return
    ; ; }

    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.

    SysGet, X1, 76
    SysGet, Y1, 77
    SysGet, Width, 78
    SysGet, Height, 79

    CoordMode, Mouse, Screen

    CoordMode, ToolTip, Screen

    MouseGetPos,KDE_X1,KDE_Y1,KDE_id
    WinGet, KDE_Win, MinMax, ahk_id %KDE_id%

    If (A_TimeSincePriorHotkey<400) and (A_TimeSincePriorHotkey<>-1) {
        ; ; WinGetTitle, WinTitle, ahk_id %KDE_id%
        ; WinMaximize,  ahk_id %KDE_id%
        ; ; ControlSend, Control, #{up} , WinTitle
        WinGet, state, MinMax, ahk_id %KDE_id%

        if (state = 1) {
            ; Already maximized → restore to normal
            WinRestore, ahk_id %KDE_id%
        } else {
            ; Not maximized → maximize it
            WinMaximize, ahk_id %KDE_id%
        }
    }

    If KDE_Win
        return
    ; Get the initial window position.
    WinGetPos, KDE_WinX1, KDE_WinY1, win_width, win_height,ahk_id %KDE_id%

    win_width := win_width - 30
    win_height := win_height - 30

    Loop
    {
        GetKeyState,KDE_Button,LButton,P ; Break if button has been released.
        If KDE_Button = U
            break
        MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
        KDE_WinY2 := (KDE_WinY1 + KDE_Y2)

        WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.

        ; sposX := xpos + _x0
        ; sposY := ypos + _y0

        ; sposx2 := xpos + _x1
        ; sposy2 := ypos + _y1

        ; ; ; ; lineColour := "0xFF0000" ; Red color
        ; ; ; ToolTip, % KDE_WinX2 " " KDE_WinY2 " "  win_width " "  win_height
        ; ; ; if
        ; ; xval := 5 + KDE_WinX2
        ; ; yval := 5 + KDE_WinY2

        ; ; ; if (xval >= 0) {
        ; ; ;     if (yval >= o) {
        ; ; ;         ToolTip, % " a " xval " " yval, xval, yval, 1
        ; ; ;     }
        ; ; ;     if (yval + win_height <= Height) {
        ; ; ;         ToolTip, % " c ", xval, yval + win_height, 3
        ; ; ;     }
        ; ; ; }
        ; ; ; if (xval + win_width <= Width) {
        ; ; ;     if (yval >= o) {
        ; ; ;         ToolTip, % " b ", xval + win_width, yval, 2
        ; ; ;     }
        ; ; ;     if (yval + win_height <= Height) {
        ; ; ;         ToolTip, % " d ", xval + win_width, yval + win_height, 4
        ; ; ;     }
        ; ; ; }
        ; ; ToolTip, % " ", xval, yval, 1
        ; ; ToolTip, % " ", xval, yval + win_height, 3
        ; ; ToolTip, % " ", xval + win_width, yval, 2
        ; ; ToolTip, % " ", xval + win_width, yval + win_height, 4

        ; DrawRectangle2(lineColour, KDE_WinX2, KDE_WinY2, win_width, win_height, 100)
    }
    ToolTip, , , , 1
    ToolTip, , , , 2
    ToolTip, , , , 3
    ToolTip, , , , 4
    ; Gui, Destroy

    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.

return

; ; IsOutOfScreen() {
; ;     SysGet, X1, 76
; ;     SysGet, Y1, 77
; ;     SysGet, Width, 78
; ;     SysGet, Height, 79
; ; }

+#RButton::
#RButton::
    ; If DoubleAlt
    ; {
    ;     MouseGetPos,,,KDE_id
    ;     ; Toggle between maximized and restored state.
    ;     WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
    ;     If KDE_Win
    ;         WinRestore,ahk_id %KDE_id%
    ;     Else
    ;         WinMaximize,ahk_id %KDE_id%
    ;     DoubleAlt := false
    ;     return
    ; }
    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos,KDE_X1,KDE_Y1,KDE_id

    init_x := KDE_X1
    init_y := KDE_Y1

    WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
    If KDE_Win
        return
    ; Get the initial window position and size.
    WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
    ; Define the window region the mouse is currently in.
    ; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
    If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
        KDE_WinLeft := 1
    Else
        KDE_WinLeft := -1
    If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
        KDE_WinUp := 1
    Else
        KDE_WinUp := -1
    Loop
    {
        GetKeyState,KDE_Button,RButton,P ; Break if button has been released.
        If KDE_Button = U
            break
        MouseGetPos, KDE_X2, KDE_Y2 ; Get the current mouse position.

        if (GetKeyState("LShift", "P") ){
            ; ToolTip, TEST %KDE_X2% %KDE_Y2% %init_x% %init_y%

            if (Abs(KDE_X2 - init_x) < Abs(KDE_Y2 - init_y)) {
                KDE_X2 := init_x
            }
            else {
                KDE_Y2 := init_y
            }
        }
        
        ; Get the current window position and size.
        WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        ; Then, act according to the defined region.
        WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
            , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
            , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
            , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
        KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
        KDE_Y1 := (KDE_Y2 + KDE_Y1)
    }
return

; "Alt + MButton" may be simpler, but I
; like an extra measure of security for
; an operation like this.

; ~!MButton::
^#!MButton::
    ; If DoubleAlt
    ; {
    MouseGetPos,,,KDE_id
    WinClose,ahk_id %KDE_id%
; DoubleAlt := false
; return
; }
return

; ; This detects "double-clicks" of the alt key.
; ~Alt::
;     DoubleAlt := A_PriorHotkey = "~Alt" AND A_TimeSincePriorHotkey < 400
;     Sleep 0
;     KeyWait Alt  ; This prevents the keyboard's auto-repeat feature from interfering.
; return