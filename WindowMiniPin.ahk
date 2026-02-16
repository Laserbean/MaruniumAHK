#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

; WinMove, , , curwinx, curwiny , 800, 1000

#Include, HideIcon.ahk

curwintitle := ""
curid := ""

Width := 0
Height := 0

ishidden := False

TRANS_MIN := 50
TRANS_MAX := 255

Loop {
    if (curwintitle != "") {
        MouseGetPos, , , id, control
        WinGetTitle, title, ahk_id %id%
        ; WinGetClass, class, ahk_id %id%
        ; ToolTip, ahk_id %id%`n ahk_class %class%`n %title%`n Control: %control%

        if (title = curwintitle) {
            ; ToolTip, ahk_id %id%`n ahk_class %class%`n %title%`n Control: %control%
            if (ishidden) {
                WinMove, %curwintitle%, , curwinx, curwiny , %Width%, %Height%
                ishidden := False
                ; ToolTip, %periodon%
                WinSet, Transparent, %TRANS_MAX%, ahk_id %curid%
            } else {
                WinGetPos, curwinx, curwiny , Width, Height, ahk_id %curid%
            }

        } else {
            WinMove, %curwintitle%, , curwinx, curwiny , 20, 20

            WinSet, Transparent, %TRANS_MIN%, ahk_id %curid%

            ishidden := True

        }

    }
    ; ToolTip, %curwintitle%
    Sleep, 30
}

^#!p::
    WaitForKeyRelease("Ctrl")
    if (curwintitle = "") {
        MouseGetPos, , , curid, control
        WinGetPos, curwinx, curwiny , Width, Height, ahk_id %curid%

        WinGetTitle, curwintitle, ahk_id %curid%

        ishidden := True

        ; WinGetTitle, curwintitle
        ; ToolTip, %curwintitle%

        ; WinGetClass, curclass, ahk_id %curid%

    } else {
        ToolTip
        WinMove, curwintitle, , curwinx, curwiny , Width, Height
        curwintitle := ""
        ishidden := False

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
