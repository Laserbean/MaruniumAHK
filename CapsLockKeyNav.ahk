#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%


timer := 0
CapslockVirtualState := 0

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
            ; ToolTip, Test1
            ; CapslockVirtualState := CapslockVirtualState
            SetCapsLockState, %CapslockVirtualState%
            timer := 0
            ; ToolTip
        } else if (timer != 0)
        {
            ; ToolTip, Test2 %timer%
            CapslockVirtualState := !CapslockVirtualState
            SetCapsLockState, %CapslockVirtualState%
            timer := 0
            ; ToolTip
        }
    }
return


CapsLock & h:: Send {Left}
CapsLock & j:: Send {Down}
CapsLock & k:: Send {Up}
CapsLock & l:: Send {Right}
CapsLock & i:: Send {PgUp}
CapsLock & o:: Send {PgDn}
CapsLock & u:: Send {Home}
CapsLock & p:: Send {End}
Capslock & `;:: Send {End}

