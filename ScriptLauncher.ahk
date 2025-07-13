#NoEnv
#SingleInstance Force
#Persistent
SetWorkingDir %A_ScriptDir%

; Define your scripts here
iniFile := A_ScriptDir "\ScriptLauncher.ini"
; scriptPidDict := {}
scriptDisplayNames := []  ; Parallel to `scripts`
scripts := [ "WindowResize.ahk", "WinMove.ahk", "create_text_file.ahk", "shortcut_parent.ahk", "essential.ahk", "text_replacement.ahk", "ExcelScript.ahk", "symbol_type.ahk", "CapsLockKeyNav.ahk" ]
; scripts := []
scriptPidDict := {}  ; To store script name -> PID

I_Icon = icon.ico
Menu, Tray, Icon, %I_Icon%   ;Changes menu tray icon

; Create the submenu first
Menu, LaunchMenu, Add  ; Creates the empty submenu

; Set up tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Launch Script..., ShowScriptMenu
Menu, Tray, Add, Launch All Scripts..., LaunchScripts
Menu, Tray, Add, Running Scripts, ShowRunningMenu
Menu, Tray, Add, Edit Script List..., EditScriptList
Menu, Tray, Add, Manage Scripts..., ShowScriptManager

Menu, Tray, Add, Close All, CloseAllScripts
Menu, Tray, Add, Reload, ReloadLabel
Menu, Tray, Add, Exit Launcher, ExitAppLabel

Menu, Tray, Default, Launch Script...
Menu, Tray, Click, 1
Menu, Tray, Tip, Script Launcher

; OnExit, CloseAllScripts

LoadScripts()
; Gosub, LaunchScripts
return

ReloadLabel:
    Gosub, CloseAllScripts
    Reload
Return

ExitAppLabel:
    Gosub, CloseAllScripts
ExitApp
Return

ShowScriptMenu:
    Menu, LaunchMenu, DeleteAll
    for index, script in scripts
    {
        Menu, LaunchMenu, Add, %script%, LaunchScriptFromMenu
    }
    Menu, LaunchMenu, Show
return

LaunchScripts:
    for index, script in scripts
        LaunchScript(script)
Return

LaunchScriptFromMenu:
    script := A_ThisMenuItem
    LaunchScript(script)
return

LaunchScript(script) {
    global scriptPidDict, scriptDisplayNames, scripts
    if (scriptPidDict.HasKey(script))
    {
        MsgBox, 48, Already Running, "%script%" is already running.
        return
    }
    ; Find the script path that matches the display name
    scriptpath := script
    for i, displayName in scriptDisplayNames
    {
        if (displayName = script)
        {
            scriptpath := scripts[i]
            break
        }
    }
    if (scriptpath = "")
        scriptpath := script  ; fallback if not found (maybe called directly with path)

    SplitPath, scriptpath, , , ext
    if (ext = "ahk")
        Run, %A_AhkPath% "%scriptpath%" noIcon, , Hide, newPID
    else
        Run, %script%, , Hide, newPID

    if ErrorLevel
    {
        MsgBox, 16, Error, Failed to run "%script%"
        return
    }
    scriptPidDict[script] := newPID
}

ShowRunningMenu:
    Gui, RunningScripts:New, , Running Scripts
    Gui, RunningScripts:Font, s10
    row := 0
    for script, pid in scriptPidDict
    {
        if ProcessExist(pid) {
            row++
            yPos := row * 30
            yBtn := yPos - 2
            Gui, RunningScripts:Add, Text, x10 y%yPos% w300 vScriptText%row%, %script% (PID: %pid%)
            Gui, RunningScripts:Add, Button, x320 y%yBtn% w60 gStopScriptRM vStopBtn%row%, Stop
            ; GuiControl,, StopBtn%row%, %script%  ; Store script name in button's text
            GuiControl,, StopBtn%row%, Stop  ; Store script name in button's text
        }
    }
    if (row = 0)
        Gui, RunningScripts:Add, Text, x10 y10, No scripts are currently running.
    Gui, RunningScripts:Show, AutoSize Center
return

StopScriptRM:
    GuiControlGet, btn, RunningScripts:, %A_GuiControl%
    script := btn
    if (scriptPidDict.HasKey(script) && ProcessExist(scriptPidDict[script])) {
        StopScript(script)
        Gui, RunningScripts:Destroy
        Gosub, ShowRunningMenu
    }
return

StopScript(script) {
    global scriptPidDict
    if (scriptPidDict.HasKey(script)) {
        Process, Close, % scriptPidDict[script]
        scriptPidDict.Delete(script)
    }
}

CloseAllScripts:
    for script, pid in scriptPidDict
    {
        if ProcessExist(pid)
            Process, Close, %pid%
    }
    scriptPidDict := {}  ; Clear dictionary
    Tooltip, Closed all scripts
    Sleep, 300
    Tooltip
    ; MsgBox, 64, Closed, All running scripts have been closed.
return

EditScriptList:
    ; Join script paths with linebreaks for editing
    text := ""
    for i, s in scripts
        text .= s "`n"
    StringTrimRight, text, text, 1  ; Remove final newline

    ; InputBox, newList, Edit Script Paths, One file per line.`nThese can be .ahk or .exe paths., , 500, 400, , , , , %text%
    ; If InputBox is not multiline, use an Edit GUI instead:
    ; Comment out the above InputBox and use the following:

    Gui, EditScriptList:New, , Edit Script Paths
    Gui, EditScriptList:Add, Edit, vScriptEdit w480 h300, %text%
    Gui, EditScriptList:Add, Button, gSaveEditScriptList x10 y320 w100, Save
    Gui, EditScriptList:Add, Button, gCancelEditScriptList x120 y320 w100, Cancel
    Gui, EditScriptList:Show, w500 h360 Center
; Gui, EditScriptList:+Resize

return

SaveEditScriptList:
    GuiControlGet, newList, EditScriptList:, ScriptEdit
    Gui, EditScriptList:Destroy
    goto AfterEditScriptList
return

CancelEditScriptList:
    Gui, EditScriptList:Destroy
return

AfterEditScriptList:
    if (ErrorLevel)
        return  ; Cancelled

    StringSplit, lines, newList, `n
    scripts := []  ; Clear and rebuild
    Loop, %lines0%
    {
        line := Trim(lines%A_Index%)
        if (line != "")
            scripts.Push(line)
    }
    SaveScripts()
return

ShowScriptManager:
    Gui, ScriptManager:New, , Script List Manager
    Gui, ScriptManager:Add, ListBox, vScriptList w400 h200

    ReloadScriptList()

    Gui, ScriptManager:Add, Button, gAddScript, Add
    Gui, ScriptManager:Add, Button, gRemoveScript x+10, Remove
    Gui, ScriptManager:Add, Button, gRunScript x+10, Run
    Gui, ScriptManager:Add, Button, gStopScript x+10, Stop
    Gui, ScriptManager:Add, Button, gSaveScriptList x+10, Save
    Gui, ScriptManager:Add, Button, gCancelScriptManager x+10, Cancel
    ; Gui, ScriptManager:Add, Button, gDebugLabel x+10, Debug
    Gui, ScriptManager:Show
return

; DebugLabel:
;     Loop % scriptDisplayNames.Length(){
;         ToolTip,  % scriptDisplayNames[A_Index]
;         Sleep, 1000
;         ToolTip
;     }
; Return

GetSelectedScript:
    GuiControlGet, selected, , ScriptList
    if (selected = "")
        return

    selectedIsRunning := InStr(selected, "[x]") > 0
    if(InStr(selected, "[ ]") > 0 || InStr(selected, "[x]") > 0) {
        StringTrimLeft, selected, selected, 4
    }
Return

AddScript:
    FileSelectFile, filePath, 3,, Select script to add, AHK Scripts (*.ahk; *.exe)
    if (filePath = "")
        return
    scripts.Push(filePath)
    SplitPath, filePath, fileName
    scriptDisplayNames.Push(fileName)
    ReloadScriptList()
return

RemoveScript:
    Gosub, GetSelectedScript
    if (selectedIsRunning) {
        MsgBox, , Error, Stop Script before removing, 5
        Return
    }
    Loop % scriptDisplayNames.Length()
    {
        if (scriptDisplayNames[A_Index] = selected) {
            StopScript(selected)

            scripts.RemoveAt(A_Index)
            scriptDisplayNames.RemoveAt(A_Index)
            break
        }
    }
    ReloadScriptList()
return

RunScript:
    Gosub, GetSelectedScript

    LaunchScript(selected)
    ReloadScriptList()

Return

StopScript:
    Gosub, GetSelectedScript
    StopScript(selected)
    ReloadScriptList()
Return

ReloadScriptList() {
    global scripts, scriptDisplayNames, scriptPidDict
    GuiControl,, ScriptList, |
    Loop % scriptDisplayNames.Length(){
        isrunningstring := "[ ] "
        if (scriptPidDict.HasKey(scriptDisplayNames[A_Index])) {
            isrunningstring := "[x] "
        }
        displaystring := % scriptDisplayNames[A_Index]
        displaystring = %isrunningstring%%displaystring%
        GuiControl,, ScriptList, %displaystring%
        ; GuiControl,, ScriptList, % scriptDisplayNames[A_Index]
    }

}

SaveScriptList:
    SaveScripts()
    Gui, ScriptManager:Destroy
return

CancelScriptManager:
    Gui, ScriptManager:Destroy
    LoadScripts()

return

ProcessExist(PID)
{
    Process, Exist, %PID%
    return ErrorLevel
}

LoadScripts() {
    global scripts, scriptDisplayNames, iniFile
    scriptDisplayNames := []

    if !FileExist(iniFile)
    {
        FileAppend,, %iniFile%
        ; SaveScripts()
        return
    }
    scripts := []

    index := 1
    Loop {
        IniRead, scriptPath, %iniFile%, Scripts, Script%index%,
        if (scriptPath = "" || scriptPath = "ERROR")
            break
        if (ErrorLevel)
            break
        if FileExist(scriptPath) {
            scripts.Push(scriptPath)
            SplitPath, scriptPath, fileName
            scriptDisplayNames.Push(fileName)
        }
        index++
    }
}

SaveScripts() {
    global scripts, iniFile

    ; Clear the [Scripts] section
    IniDelete, %iniFile%, Scripts

    ; Write each script path
    Loop % scripts.Length()
        IniWrite, % scripts[A_Index], %iniFile%, Scripts, Script%A_Index%
}

