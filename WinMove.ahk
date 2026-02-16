#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include, HideIcon.ahk

!+Left::
!+Right::
!+WheelDown::
!+WheelUp::

    ; F2::
    ; Get active window
    WinGet, winID, ID, A
    WinGetPos, winX, winY, winW, winH, ahk_id %winID%

    WinGet, state, MinMax, ahk_id %winID%

    if (state = 1) {

        ; BlockInput, On
        SendLevel, 1

        ; SendInput, {Ctrl up}#+{Right}
        SendInput, {Alt up}{Ctrl up}#+{Right}
        Sleep, 100
        ; BlockInput, Off
        SendLevel, 0

        WaitForKeyRelease(Alt)

        ; ; ; ; Get monitor info (requires SysGet)
        ; ; ; SysGet, monCount, MonitorCount

        ; ; ; activeWinCenterX := (winX + winW) / 2
        ; ; ; activeWinCenterY := (winY + winH) / 2

        ; ; ; Loop, %monCount%
        ; ; ; {
        ; ; ;     SysGet, currentMonitor, Monitor, A_Index ; Get the bounds of the current monitor in the loop

        ; ; ;     ; Check if the active window's center falls within the current monitor's bounds
        ; ; ;     if (activeWinCenterX >= currentMonitorLeft) && (activeWinCenterX <= currentMonitorRight)
        ; ; ;         && (activeWinCenterY >= currentMonitorTop) && (activeWinCenterY <= currentMonitorBottom)
        ; ; ;     {
        ; ; ;         ; Found the monitor! You can now use 'currentMonitorLeft', 'currentMonitorTop', etc.
        ; ; ;         ; MsgBox, The active window is on Monitor %A_Index%.`nCoordinates: Left=%currentMonitorLeft%, Top=%currentMonitorTop%, Right=%currentMonitorRight%, Bottom=%currentMonitorBottom%

        ; ; ;         winMonitor := A_Index
        ; ; ;         break ; Exit the loop once the monitor is found

        ; ; ;     }
        ; ; ; }

        ; ; ; ; Determine next monitor (wrap around if needed)
        ; ; ; nextMonitor := winMonitor + 1
        ; ; ; if (nextMonitor > monCount)
        ; ; ;     nextMonitor := 1

        ; ; ; ; Get next monitor's coordinates
        ; ; ; SysGet, nextMon, Monitor, %nextMonitor%
        ; ; ; nextMonL := nextMonLeft

        ; ; ; ; Move window to same position relative to next monitor
        ; ; ; relX :=   winX- nextMonL/2
        ; ; ; WinMove, ahk_id %winID%, , relX + 50, winY, winW, winH

        Return
    }

    ; Get monitor info (requires SysGet)
    SysGet, monCount, MonitorCount

    ; For example, we’re moving from monitor 1 to monitor 2
    SysGet, mon1, Monitor, 1
    SysGet, mon2, Monitor, 2

    ; Which monitor is the window currently on?
    if (winX >= mon1Left && winX < mon1Right) {
        ; Mirror to monitor 2
        srcLeft := mon1Left
        srcRight := mon1Right
        dstLeft := mon2Left
        dstRight := mon2Right
    } else {
        ; Mirror to monitor 1
        srcLeft := mon2Left
        srcRight := mon2Right
        dstLeft := mon1Left
        dstRight := mon1Right
    }

    ; Calculate distance from source monitor’s left edge
    distFromLeft := winX - srcLeft

    ; New left position on dest monitor, mirrored
    newX := dstLeft + (dstRight - dstLeft) - distFromLeft - winW

    ; Keep Y the same (or adjust if you want)
    WinMove, ahk_id %winID%, , newX, winY

Return

^#+Left::
    n := VD.getCurrentDesktopNum()
    if n = 1
    {
        Return
    }
    n -= 1
    VD.MoveWindowToDesktopNum("A",n), VD.goToDesktopNum(n)
Return

^#+Right::
    n := VD.getCurrentDesktopNum()
    if n = % VD.getCount()
    {
        Return
    }
    n += 1
    VD.MoveWindowToDesktopNum("A",n), VD.goToDesktopNum(n)
Return

;Shift + Windows + Up (maximize a window across all displays) https://stackoverflow.com/a/9830200/470749
+#Up::
    WinGetActiveTitle, Title
    WinRestore, %Title%
    SysGet, X1, 76
    SysGet, Y1, 77
    SysGet, Width, 78
    SysGet, Height, 79
    WinMove, %Title%,, X1-5, Y1-3, Width +20, Height
return

WaitForKeyRelease(keyToWaitFor) {
    Loop {
        if (!GetKeyState(keyToWaitFor, "P")) {
            break ; Exit the loop if the specified key is not pressed
        }
        Sleep, 10 ; Sleep for 10 milliseconds to reduce CPU usage
    }
}