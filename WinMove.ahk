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
        SendLevel, 1

        Send, #+{Right}
        ; SendInput, #+{Right}
        SendLevel, 0

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