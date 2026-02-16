#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include HideIcon.ahk

timer := 0
CapslockVirtualState := 0

HotkeyPressed := false

MouseCurSpeed := 5

MouseSpeed := 20
MouseFastSpeed := 100
MouseSlowSpeed := 5

MouseLeftDown := False

MouseMoveRunning := False

SetTimer, CheckCapsLock, 50 ; check every 50ms
return

CheckCapsLock:

    if GetKeyState("CapsLock", "P")
    {
        ; ToolTip, Test %timer%
        timer += 1
    }
    else
    {
        if (timer > 2 )  ; If the key was held for more than 500ms
        {
            if (HotkeyPressed) {
                SetCapsLockState, %CapslockVirtualState%
                HotkeyPressed := False
            } else {
                CapslockVirtualState := !CapslockVirtualState
                SetCapsLockState, %CapslockVirtualState%
            }
            timer := 0
            ; ToolTip
        } else if (timer != 0)
        {
            CapslockVirtualState := !CapslockVirtualState
            SetCapsLockState, %CapslockVirtualState%
            timer := 0
            ; ToolTip
        }

        currentCapsLockState := GetKeyState("CapsLock", "T")
        if (currentCapsLockState != CapslockVirtualState) {
            CapslockVirtualState := currentCapsLockState
        }
    }

return

CapsLock & \::
    MouseMoveRunning := !MouseMoveRunning
    ToolTip, Mouse Running %MouseMoveRunning%

    WaitForKeyRelease("\")

    ToolTip
Return

CapsLock & h::
    if (!MouseMoveRunning) {
        Send {Left}
        Gosub, CheckCapsLabel
    }
    else {
        Gosub, SpeedCheckLabel
        MouseMove, -MouseCurSpeed, 0, 1, R
    }
Return

CapsLock & j::
    if (!MouseMoveRunning) {
        Send {Down}
        Gosub, CheckCapsLabel
    }
    else {
        Gosub, SpeedCheckLabel
        MouseMove, 0, MouseCurSpeed, 1, R
    }
Return

CapsLock & k::
    if (!MouseMoveRunning) {
        Send {Up}
        Gosub, CheckCapsLabel
    }
    else {
        Gosub, SpeedCheckLabel
        MouseMove, 0, -MouseCurSpeed, 1, R
    }
Return

CapsLock & l::
    if (!MouseMoveRunning) {
        Send {Right}
        Gosub, CheckCapsLabel
    }
    else {
        Gosub, SpeedCheckLabel
        MouseMove, MouseCurSpeed, 0, 1, R
    }
Return

CapsLock & i::
    Send {PgUp}
    Gosub, CheckCapsLabel
Return

CapsLock & o::
    Send {PgDn}
    Gosub, CheckCapsLabel
Return
CapsLock & u::
    Send {Home}
    Gosub, CheckCapsLabel
Return
CapsLock & p::
    Send {End}
    Gosub, CheckCapsLabel
Return
Capslock & `;::
    Send {End}
    Gosub, CheckCapsLabel
Return
CapsLock & w::
    Send ^{Right}
    Gosub, CheckCapsLabel
Return
CapsLock & b::
    Send ^{Left}
    Gosub, CheckCapsLabel
Return

CapsLock & Space::
    if ( not GetKeyState("LButton" , "P") )
        Click down
    Gosub, CheckCapsLabel
Return

~Space Up::
    if (GetKeyState("LButton" , "P") )
        Click up
Return

; ; CapsLock & Space::
; ;     if (!MouseLeftDown) {
; ;         ; if ( not GetKeyState("LButton" , "P") )
; ;         Click down
; ;         ; return
; ;         MouseLeftDown := True
; ;     } else {
; ;         Click up
; ;         MouseLeftDown := False

; ;     }
; ; Return

CheckCapsLabel:
    HotkeyPressed := True
Return

SpeedCheckLabel:
    if (GetKeyState("Ctrl", "P")) {
        MouseCurSpeed := MouseFastSpeed
        ; ToolTip, Faster
    } else if(GetKeyState("Shift", "P")){
        MouseCurSpeed := MouseSlowSpeed

    } else {
        MouseCurSpeed := MouseSpeed
        ; ToolTip, Slow
    }

Return

WaitForKeyRelease(keyToWaitFor) { ;from laserbeanAHK. But it's annoying to have submodules.
    Loop {
        if (!GetKeyState(keyToWaitFor, "P")) {
            break ; Exit the loop if the specified key is not pressed
        }
        Sleep, 10 ; Sleep for 10 milliseconds to reduce CPU usage
    }
}