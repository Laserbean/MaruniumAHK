#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

; WinMove, , , curwinx, curwiny , 800, 1000

#Include, HideIcon.ahk

; Array to store pinned windows
; Key: window ID, Value: object with {title, origX, origY, origW, origH, isHidden}
pinned := {}

TRANS_MIN := 50
TRANS_MAX := 255
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
Loop {
    MouseGetPos, curx, cury , activeId, control

    for curid, winData in pinned {
        ; Check if window still exists
        if (!WinExist("ahk_id " curid)) {
            pinned.Delete(curid)
            continue
        }

        ; WinGetTitle, title, ahk_id %activeId%

        if (activeId = curid) {
            ; Mouse is over this window, expand it
            if (winData.isHidden) {
                WinMove, ahk_id %curid%, , winData.origX, winData.origY, winData.origW, winData.origH
                winData.isHidden := False
                WinSet, Transparent, %TRANS_MAX%, ahk_id %curid%
            } else {
                WinGetPos, x, y, w, h, ahk_id %curid%
                winData.origX := x
                winData.origY := y
                winData.origW := w
                winData.origH := h
            }
        } else {
            ; Mouse is not over this window, minimize it
            if (!winData.isHidden) {
                ; ToolTip, origin , winData.origX, winData.origY, 1
                ; ToolTip, origin2 , winData.origX + winData.origW, winData.origY + winData.origH, 2
                if (curx < winData.origX || curx > winData.origX + winData.origW || cury < winData.origY || cury > winData.origY + winData.origH) {
                    WinMove, ahk_id %curid%, , winData.origX, winData.origY, 20, 20
                    WinSet, Transparent, %TRANS_MIN%, ahk_id %curid%
                    winData.isHidden := True
                } else {

                }
            }
        }
    }

    Sleep, 30
}

^#!p::
    WaitForKeyRelease("Ctrl")
    MouseGetPos, , , id, control

    if (pinned.HasKey(id)) {
        ; Window already pinned, unpin it
        WinGetTitle, title, ahk_id %id%
        pinned[id].isHidden := False
        WinMove, ahk_id %id%, , pinned[id].origX, pinned[id].origY, pinned[id].origW, pinned[id].origH
        WinSet, Transparent, %TRANS_MAX%, ahk_id %id%
        ToolTip
        pinned.Delete(id)
    } else {
        ; Pin this window
        WinGetTitle, title, ahk_id %id%
        WinGetPos, origX, origY, origW, origH, ahk_id %id%

        pinned[id] := {}
        pinned[id].title := title
        pinned[id].origX := origX
        pinned[id].origY := origY
        pinned[id].origW := origW
        pinned[id].origH := origH
        pinned[id].isHidden := True

        WinMove, ahk_id %id%, , origX, origY, 20, 20
        WinSet, Transparent, %TRANS_MIN%, ahk_id %id%
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
