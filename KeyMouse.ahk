#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include, HideIcon.ahk

MouseSpeed := 5

MouseCurSpeed := 5
MouseFastSpeed := 20

MouseLeftDown := False

WaitForKeyRelease(keyToWaitFor) { ;from laserbeanAHK. But it's annoying to have submodules.
    Loop {
        if (!GetKeyState(keyToWaitFor, "P")) {
            break ; Exit the loop if the specified key is not pressed
        }
        Sleep, 10 ; Sleep for 10 milliseconds to reduce CPU usage
    }
}

MouseMoveRunning := True

!\::
    MouseMoveRunning := !MouseMoveRunning
    ToolTip, Mouse Running %MouseMoveRunning%

    WaitForKeyRelease("\")

    ToolTip
Return

~Alt & h::
    if (!MouseMoveRunning) {
        Send, !{h}
        Return
    }

    Gosub, CtrlDownLabel
    MouseMove, -MouseCurSpeed, 0, 1, R
Return

~Alt & l::
    if (!MouseMoveRunning) {
        Send, !{l}
        Return
    }
    Gosub, CtrlDownLabel
    MouseMove, MouseCurSpeed, 0, 1, R
Return

~Alt & j::
    if (!MouseMoveRunning) {
        Send, !{j}
        Return
    }
    Gosub, CtrlDownLabel
    MouseMove, 0, MouseCurSpeed, 1, R
Return

~Alt & k::
    if (!MouseMoveRunning) {
        Send, !{k}
        Return
    }
    Gosub, CtrlDownLabel
    MouseMove, 0, -MouseCurSpeed, 1, R
Return

; ; ~Alt & m::
; ;     if (!MouseLeftDown) {

; ;         Send, {Alt Up}
; ;         Send, {LAlt Up}
; ;         ; if ( not GetKeyState("LButton" , "P") )
; ;         Click down
; ;         ; return
; ;         MouseLeftDown := True
; ;     } else {
; ;         Click up
; ;         MouseLeftDown := False

; ;     }

; ; Return


; F2::
;     if ( not GetKeyState("RButton" , "P") )
;         Click down right
; return
; F2 Up::Click up right

; F1::
;     if ( not GetKeyState("LButton" , "P") )
;         Click down
; return
; F1 Up::Click up

CtrlDownLabel:
    if (GetKeyState("Ctrl", "P")) {
        MouseCurSpeed := MouseFastSpeed
        ; ToolTip, Faster
    } else {
        MouseCurSpeed := MouseSpeed
        ; ToolTip, Slow
    }

Return