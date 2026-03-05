#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include, HideIcon.ahk

;#region============================EXTRA STUFF===================================

; XButton1::
;     Send, {Delete}
; Return

; XButton2::
;     Send, {BackSpace}
; Return

; ^XButton1::
;     Send, ^{Delete}
; Return

; ^XButton2::
;     Send, ^{BackSpace}
; Return

; ^+XButton1::
;     Send, ^+{Delete}
; Return

; ^+XButton2::
;     Send, ^+{BackSpace}
; Return

^+Space::
    WinGetTitle, activeWindow, A
    if IsWindowAlwaysOnTop(activeWindow) {
        notificationMessage := "The window """ . activeWindow . """ is now always on top."
        notificationIcon := 16 + 1 ; No notification sound (16) + Info icon (1)
    }
    else {
        notificationMessage := "The window """ . activeWindow . """ is no longer always on top."
        notificationIcon := 16 + 2 ; No notification sound (16) + Warning icon (2)
    }
    Winset, Alwaysontop, , A
    TrayTip, Always-on-top, %notificationMessage%, , %notificationIcon%
    Sleep 1000 ; Let it display for 3 seconds.
    HideTrayTip()

    IsWindowAlwaysOnTop(windowTitle) {
        WinGet, windowStyle, ExStyle, %windowTitle%
        isWindowAlwaysOnTop := if (windowStyle & 0x8) ? false : true ; 0x8 is WS_EX_TOPMOST.
        return isWindowAlwaysOnTop
    }

    HideTrayTip() {
        TrayTip ; Attempt to hide it the normal way.
        if SubStr(A_OSVersion,1,3) = "10." {
            Menu Tray, NoIcon
            Sleep 200 ; It may be necessary to adjust this sleep.
            Menu Tray, Icon
        }
    }
Return

^#Space::

    ; WinGetTitle, activeWindow, A
    ; if IsWindowOnAllDesktops(activeWindow) {
    ;     notificationMessage := "The window """ . activeWindow . """ is now on every desktop."
    ;     notificationIcon := 16 + 1 ; No notification sound (16) + Info icon (1)
    ; }
    ; else {
    ;     notificationMessage := "The window """ . activeWindow . """ is no longer on every desktop."
    ;     notificationIcon := 16 + 2 ; No notification sound (16) + Warning icon (2)
    ; }

    ; IsWindowOnAllDesktops(windowTitle) {
    ;     WinGet, ExStyle, ExStyle, %windowTitle%
    ;     returnval := if ((ExStyle & 0x800080)) ? false : true ; 0x8 is WS_EX_TOPMOST
    ;         return returnval
    ; }

    WinGet, ExStyle, ExStyle, A ; "A" means the active window
    If !(ExStyle & 0x800080) ; visible on all desktops.
        WinSet, ExStyle, 0x800080, A
    else
        WinSet, ExStyle, -0x800080, A

; TrayTip, Always-on-top, %notificationMessage%, , %notificationIcon%
; Sleep 1000 ; Let it display for 3 seconds.
Return

; ;Shift + Windows + Up (maximize a window across all displays) https://stackoverflow.com/a/9830200/470749
; +#Up::
;     WinGetActiveTitle, Title
;     WinRestore, %Title%
;     SysGet, X1, 76
;     SysGet, Y1, 77
;     SysGet, Width, 78
;     SysGet, Height, 79
;     WinMove, %Title%,, X1-5, Y1-3, Width +20, Height
; return

#^WheelDown::
    ;activate taskbar before
    WinActivate, ahk_class Shell_TrayWnd
    ; WinWaitActive, ahk_class Shell_TrayWnd
    ; DllCall(SwitchDesktop, "ptr", IVirtualDesktopManagerInternal, "UPtr", IVirtualDesktop, "UInt")
    ; DllCall(SwitchDesktop, "ptr", IVirtualDesktopManagerInternal, "UPtr", IVirtualDesktop, "UInt")
    Send, #^{Right}

    WinMinimize, ahk_class Shell_TrayWnd
Return

#^WheelUp::
    WinActivate, ahk_class Shell_TrayWnd
    ; WinWaitActive, ahk_class Shell_TrayWnd
    ; DllCall(SwitchDesktop, "ptr", IVirtualDesktopManagerInternal, "UPtr", IVirtualDesktop, "UInt")
    ; DllCall(SwitchDesktop, "ptr", IVirtualDesktopManagerInternal, "UPtr", IVirtualDesktop, "UInt")
    Send, #^{Left}

    WinMinimize, ahk_class Shell_TrayWnd
Return

#+WheelDown::
    Send, #+{Right}
Return

#+WheelUp::
    Send, #+{Left}
Return

#IfWinActive ahk_class CabinetWClass

    +F2::
        KeyWait, Shift, U

        timer := 24000

        Send, !{Up}
        Sleep, 100
        Send, {F2}

        Sleep, 300

        ; KeyWait, Enter, D

        Loop, {
            MouseGetPos, curmousex, curmousey, curmousewindow ;, OutputVarControl, 1|2|3]
            ControlGetFocus focused

            if (focused = "Edit1") {
                if (timer > 16000) {
                    ToolTip, Renaming., curmousex + 32, curmousey + 16

                } else if (timer > 8000) {
                    ToolTip, Renaming.., curmousex + 32, curmousey + 16

                } else {
                    ToolTip, Renaming..., curmousex + 32, curmousey + 16
                }
                Timer := Timer -1
                if (Timer <= 0) {
                    Timer := 24000
                }

            } else {
                ToolTip
                Send, {Enter}

                Break
            }
        }

        ; Sleep, 100
    Return

#IfWinActive

; #IfWinActive ahk_exe Explorer.exe
;     $.::
;         ControlGetFocus focused
;         if (focused = "Edit1") {
;             Send .
;         } else {
;             EnvGet LocalAppData, LOCALAPPDATA
;             Run % LocalAppData "\Programs\Microsoft VS Code\bin\code"
;         }
;     return
; #IfWinActive

;#endregion

; ~^+t::
;     ToolTip, "Ctrl Shift T"

;     Sleep, 1000
;     ToolTip

; Return

; ~#Space::
;     Sleep, 300
;     Send, !{``}

; Return