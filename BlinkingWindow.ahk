#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Include, HideIcon.ahk

TRANS_MIN := 5
TRANS_MAX := 255

PERIOD := 700
PWM := 0.5

IsRunning := False
WasRunning := False
WindowID = ""

Loop {
    if (IsRunning) {
        if !WinExist("ahk_id " WindowID) {
            ; ToolTip, Window closed!
            IsRunning := False
            continue
        }

        ; ToolTip, %periodoff%
        WinSet, Transparent, %TRANS_MIN%, ahk_id %WindowID%
        Sleep, %periodoff%

        ; ToolTip, %periodon%
        WinSet, Transparent, %TRANS_MAX%, ahk_id %WindowID%

        Sleep, %periodon%

        WasRunning := True

    }
    else if (WasRunning){
        WasRunning := False
        WinSet, Transparent, 255, ahk_id %WindowID%
        ToolTip
    }
}

^#b::
^#MButton::
    IsRunning := !IsRunning

    if(!IsRunning) {
        Return
    }
    MouseGetPos, KDE_X1, KDE_Y1, WindowID

    ; WinGet,KDE_Win, MinMax, ahk_id %WindowID%
    ; WinGetPos, KDE_WinX1, KDE_WinY1, KDE_WinW, KDE_WinH, ahk_id %WindowID%

    periodoff := PERIOD * PWM
    periodon := PERIOD * (1 - PWM)

    WinGet, CUR_TRANSPARENT, Transparent, ahk_id %WindowID%

    if (CUR_TRANSPARENT = "") {
        CUR_TRANSPARENT := 255
    }

; KDE_X1 -= CUR_TRANSPARENT

Return

~^#Left::
~^#Right::
    if(IsRunning) {
        IsRunning := !IsRunning
        WinSet, Transparent, %TRANS_MAX%, ahk_id %WindowID%
        Return
    }
Return
