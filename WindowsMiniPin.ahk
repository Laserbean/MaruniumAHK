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

Loop {
    MouseGetPos, , , activeId, control
    
    for id, winData in pinned {
        ; Check if window still exists
        if (!WinExist("ahk_id " id)) {
            pinned.Delete(id)
            continue
        }
        
        WinGetTitle, title, ahk_id %id%
        
        if (activeId = id) {
            ; Mouse is over this window, expand it
            if (winData.isHidden) {
                WinMove, ahk_id %id%, , winData.origX, winData.origY, winData.origW, winData.origH
                winData.isHidden := False
                WinSet, Transparent, %TRANS_MAX%, ahk_id %id%
            }
        } else {
            ; Mouse is not over this window, minimize it
            if (!winData.isHidden) {
                WinGetPos, x, y, w, h, ahk_id %id%
                winData.origX := x
                winData.origY := y
                winData.origW := w
                winData.origH := h
            }
            
            if (!winData.isHidden) {
                WinMove, ahk_id %id%, , winData.origX, winData.origY, 20, 20
                WinSet, Transparent, %TRANS_MIN%, ahk_id %id%
                winData.isHidden := True
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
