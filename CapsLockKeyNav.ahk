#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include HideIcon.ahk

timer := 0
CapslockVirtualState := 0

HotkeyPressed := false

SetTimer, CheckCapsLock, 50 ; check every 50ms
return

CheckCapsLock:

    ; if GetKeyState("CapsLock", "P")
    ; {
    ;     ; ToolTip, Test %timer%
    ;     timer += 1
    ; }
    ; else
    ; {
    ;     if (timer > 2 )  ; If the key was held for more than 500ms
    ;     {
    ;         ; ToolTip, Test1
    ;         ; CapslockVirtualState := CapslockVirtualState
    ;         SetCapsLockState, %CapslockVirtualState%
    ;         timer := 0
    ;         ; ToolTip
    ;     } else if (timer != 0)
    ;     {
    ;         ; ToolTip, Test2 %timer%
    ;         CapslockVirtualState := !CapslockVirtualState
    ;         SetCapsLockState, %CapslockVirtualState%
    ;         timer := 0
    ;         ; ToolTip
    ;     }
    ;     ; Check if CapsLock state has changed externally
    ;     currentCapsLockState := GetKeyState("CapsLock", "T")
    ;     if (currentCapsLockState != CapslockVirtualState) {
    ;         CapslockVirtualState := currentCapsLockState
    ;     }
    ; }

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

CapsLock & h::
    Send {Left}
    Gosub, CheckCapsLabel
Return
CapsLock & j::
    Send {Down}
    Gosub, CheckCapsLabel
Return
CapsLock & k::
    Send {Up}
    Gosub, CheckCapsLabel
Return
CapsLock & l::
    Send {Right}
    Gosub, CheckCapsLabel
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

CheckCapsLabel:
    HotkeyPressed := True
Return
