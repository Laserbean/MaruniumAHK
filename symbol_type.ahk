#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance force

#Include, HideIcon.ahk


;;;;;;;;Zooming in eclispe start
; Ctrl + MouseWheel zooming in Eclipse Editor.
; Requires Tarlog plugins (https://code.google.com/p/tarlog-plugins/).
#IfWinActive ahk_class SWT_Window0
    ^WheelUp:: Send ^{NumpadAdd}
    ^WheelDown:: Send ^{NumpadSub}

    ;;;;;;;;zooming in eclispe end
#IfWinActive

; ;;;;;;;;other stuff start
; SC133::KeyHistory
; Return
; ;;;;;;;; other stuff end

;;;;;;;;Horizontal scrolling start

; ; #IfWinNotActive ahk_class XLMAIN or #IfWinNotActive ahk_class Vegas.Class.Frame
; ;     {
; ;         +WheelUp::
; ;             SetScrollLockState, On
; ;             send {Left}
; ;             SetScrollLockState, Off
; ;         Return
; ;         +WheelDown::
; ;             SetScrollLockState, On
; ;             send {Right}
; ;             SetScrollLockState, Off
; ;         Return
; ;     }
; ; #IfWinActive
; ; ; Everything except Excel.
; ; #IfWinActive ahk_class XLMAIN 

; ;     +WheelUp:: ; Scroll left.
; ;         ControlGetFocus, fcontrol, A
; ;         Loop 1 ; <-- Increase this value to scroll faster.
; ;             SendMessage, 0x114, 0, 0, %fcontrol%, A ; 0x114 is WM_HSCROLL and the 0 after it is SB_LINELEFT.
; ;     return

; ;     +WheelDown:: ; Scroll right.
; ;         ControlGetFocus, fcontrol, A
; ;         Loop 1 ; <-- Increase this value to scroll faster.
; ;             SendMessage, 0x114, 1, 0, %fcontrol%, A ; 0x114 is WM_HSCROLL and the 1 after it is SB_LINERIGHT.
; ;     return
; ;     ;;;;;;;;;Horizontal scrolling end

; ; #IfWinActive

;#region Mouse remap start

^XButton1::
    send, ^{Del}
return

^XButton2::
    send, ^{Bs}
return

XButton1::
    Send {Blind}{del DownR}
    fish = 0
    while GetKeyState("XButton1", "P") = 1
    {
        if fish <= 100000 ;was 250000
        {
            fish += 1
            sleep, 0.1 ;was 0.1
        }
        else
        {
            send {del down}
            sleep, 4
        }

    }
    ;msgbox, tittle, %fish%
    send {del up}
return

XButton2::
    Send {Blind}{bs DownR}
    fish = 0
    while GetKeyState("XButton2", "P") = 1
    {
        if fish <= 100000 ;was 250000
        {
            fish += 1
            sleep, 0.1 ;was 0.1
        }
        else
        {
            send {bs down}
            sleep, 4
        }

    }
    ;msgbox, tittle, %fish%
    send {bs up}
Return

;;#endregion Mouse remap end

;#region Symbols start

:*:.integrate.::∫
return

:*:.udot.::u̇
return

:*:.uddot.::ü
return

:*:.therefore.::∴
Return

:*:plusminus::±
Return

:*:=~::≈
Return

:*:.ohms.::Ω
Return

:*:..v.::✓
Return
:*:.v.::✔
Return

:*:.micro.::µ
Return

:*:.x.:: ×
Return

:*:dgs::
    sleep, 10
    send {bs}
    send °
Return

:*: .sqr.::²
Return

:*:.sqrt.::√
Return

:*:.alpha.::α
Return
:*:..Alpha.::A 
Return
:*:..Beta.::B
Return
:*:.beta.::β
Return
:*:..Gamma.::Γ
Return
:*:.gamma.::γ
Return
:*:..Delta.::Δ
Return
:*:.delta.::δ
Return
:*:..Epsilon.::E
Return
:*:.epsilon.::ε 
Return
:*:..Zeta.::Z
Return
:*:.zeta.::ζ
Return
:*:..Eta.::H
Return
:*:.eta.::η
Return
:*:..Theta.::Θ
Return
:*:.theta.::θ
Return
:*:..Iota.::I 
Return
:*:.iota.::ι
Return
:*:..Kappa.::K
Return
:*:.kappa.::κ
Return
:*:..Lambda.::Λ
Return
:*:.lambda.::λ
Return
:*:..Mu.::M
Return
:*:.mu.::µ 
Return
:*:..Nu.::N
Return
:*:.nu.::ν
Return
:*:..Xi.::Ξ
Return
:*:.xi.::ξ
Return
:*:..Pi.::Π
Return
:*:.pi.::π
Return
:*:..Rho.::P
Return
:*:.rho.::ρ
Return
:*:..Sigma.::Σ
Return
:*:.sigma.::σ
Return
:*:.sigma2.::ς 
Return
:*:..Tau.::T 
Return
:*:.tau.::τ
Return
:*:..Upsilon.::Υ 
Return
:*:.upsilon.::υ
Return
:*:..Phi.::Φ 
Return
:*:.phi.::φ
Return
:*:..Chi.::X 
Return
:*:.chi.::χ
Return
:*:..Psi.::Ψ 
Return
:*:.psi.::ψ
Return
:*:..Omega.::Ω
Return
:*:.ohms.::Ω
Return
:*:.omega.::ω
Return

:*:lennyface::( ͡° ͜ʖ ͡°) 
Return

:*:.zws.::​
Return

;#endregion Symbols end