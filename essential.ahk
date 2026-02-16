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