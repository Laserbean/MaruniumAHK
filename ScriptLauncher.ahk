;==================================================
; Script Launcher v1.2 - Cleaned and Debugged
;==================================================
#NoEnv
#SingleInstance Force
#Persistent
SetWorkingDir %A_ScriptDir%

;==================================================
; [ CONFIGURATION ]
;==================================================
iniFile := A_ScriptDir "\ScriptLauncher1.ini"
scripts := []             ; Full paths to scripts
scriptDisplayNames := []  ; Display names (filenames)
scriptsRunning := []      ; Auto-launch flags ("True"/"False")
scriptPidDict := {}       ; scriptDisplayName -> PID

I_Icon = icon.ico

;==================================================
; [ TRAY MENU SETUP ]
;==================================================
Menu, Tray, Icon, %I_Icon%
Menu, LaunchMenu, Add
Menu, Tray, NoStandard
Menu, Tray, Add, Manage Scripts..., ShowScriptManager
Menu, Tray, Add, Launch Script..., ShowScriptMenu
Menu, Tray, Add, Launch All Scripts..., LaunchScripts
Menu, Tray, Add, Close All, CloseAllScripts
Menu, Tray, Add, Reload, ReloadLabel
Menu, Tray, Add, Exit Launcher, ExitAppLabel
Menu, Tray, Default, Manage Scripts...
Menu, Tray, Click, 1
Menu, Tray, Tip, Script Launcher

;==================================================
; [ INITIALIZATION ]
;==================================================
LoadScripts()
Gosub, RunActivatedScripts
return

;==================================================
; [ TRAY MENU LABELS ]
;==================================================
ReloadLabel:
    Gosub, CloseAllScripts
    Reload
Return

ExitAppLabel:
    ; Save current running scripts for next launch
    for script, pid in scriptPidDict
        if ProcessExist(pid)
            for index, displayName in scriptDisplayNames
                if (displayName = script)
                    scriptsRunning[index] := "True"
    SaveScripts()
    ; Now close all scripts without overwriting the save
    for script, pid in scriptPidDict
        if ProcessExist(pid)
            Process, Close, %pid%
    scriptPidDict := {}
    Tooltip, Closed all scripts
    Sleep, 300
    Tooltip
ExitApp
Return

ShowScriptMenu:
    Menu, LaunchMenu, DeleteAll
    for index, script in scriptDisplayNames
        Menu, LaunchMenu, Add, %script%, LaunchScriptFromMenu
    Menu, LaunchMenu, Show
return

;==================================================
; [ SCRIPT LAUNCHING ]
;==================================================
RunActivatedScripts:
    for index, script in scriptDisplayNames
        if (scriptsRunning[index] = "True")
            LaunchScript(script)
Return

LaunchScripts:
    for index, script in scriptDisplayNames
        LaunchScript(script)
Return

LaunchScriptFromMenu:
    script := A_ThisMenuItem
    LaunchScript(script)
return

LaunchScript(script) {
    global scriptPidDict, scriptDisplayNames, scripts, scriptsRunning
    if (scriptPidDict.HasKey(script))
    {
        MsgBox, 48, Already Running, "%script%" is already running.
        return
    }
    ; Find the full path for the script
    scriptpath := ""
    for i, displayName in scriptDisplayNames
        if (displayName = script)
            scriptpath := scripts[i]
    if (scriptpath = "")
    {
        MsgBox, 16, Error, Script "%script%" not found in list.
        return
    }

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

    ; Update scriptsRunning
    for index, curscript in scriptDisplayNames
        if (curscript = script)
            scriptsRunning[index] := "True"

    SaveScripts()
}

;==================================================
; [ RUNNING SCRIPTS GUI ]
;==================================================
ShowRunningMenu:
    global scriptList
    scriptList := []
    Gui, RunningScripts:New, , Running Scripts
    Gui, RunningScripts:Font, s10
    row := 0
    for script, pid in scriptPidDict
    {
        if ProcessExist(pid) {
            row++
            scriptList[row] := script
            yPos := row * 30
            yBtn := yPos - 2
            Gui, RunningScripts:Add, Text, x10 y%yPos% w300, %script% (PID: %pid%)
            Gui, RunningScripts:Add, Button, x320 y%yBtn% w60 gStopScriptRM, Stop
        }
    }
    if (row = 0)
        Gui, RunningScripts:Add, Text, x10 y10, No scripts are currently running.
    Gui, RunningScripts:Show, AutoSize Center
return

StopScriptRM:
    btnNum := SubStr(A_GuiControl, 8)  ; Extract number from "StopBtnX"
    script := scriptList[btnNum]
    if (scriptPidDict.HasKey(script) && ProcessExist(scriptPidDict[script])) {
        StopScript(script)
        Gui, RunningScripts:Destroy
        Gosub, ShowRunningMenu
    }
return

StopScript(script) {
    global scriptPidDict, scriptDisplayNames, scriptsRunning
    if (scriptPidDict.HasKey(script)) {
        Process, Close, % scriptPidDict[script]
        scriptPidDict.Delete(script)
        ; Update scriptsRunning
        for index, curscript in scriptDisplayNames
            if (curscript = script)
                scriptsRunning[index] := "False"
    }
    SaveScripts()
}

CloseAllScripts:
    global scriptDisplayNames, scriptsRunning
    for script, pid in scriptPidDict
        if ProcessExist(pid)
            Process, Close, %pid%
    scriptPidDict := {}
    Loop % scriptDisplayNames.Length()
        scriptsRunning[A_Index] := "False"
    SaveScripts()
    Tooltip, Closed all scripts
    Sleep, 300
    Tooltip
return

;==================================================
; [ SCRIPT LIST EDIT GUI ]
;==================================================
EditScriptList:
    text := ""
    for i, s in scripts
        text .= s "`n"
    StringTrimRight, text, text, 1

    Gui, EditScriptList:New, , Edit Script Paths
    Gui, EditScriptList:Add, Edit, vScriptEdit w480 h300, %text%
    Gui, EditScriptList:Add, Button, gSaveEditScriptList x10 y320 w100, Save
    Gui, EditScriptList:Add, Button, gCancelEditScriptList x120 y320 w100, Cancel
    Gui, EditScriptList:Show, w500 h360 Center
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
        return
    StringSplit, lines, newList, `n
    scripts := []
    scriptDisplayNames := []
    scriptsRunning := []
    Loop, %lines0%
    {
        line := Trim(lines%A_Index%)
        if (line != "") {
            scripts.Push(line)
            SplitPath, line, fileName
            scriptDisplayNames.Push(fileName)
            scriptsRunning.Push("False")
        }
    }
    SaveScripts()
return

;==================================================
; [ SCRIPT MANAGER GUI ]
;==================================================
ShowScriptManager:
    Gui, ScriptManager:New, , Script List Manager
    Gui, ScriptManager:Add, ListBox, vScriptList w400 h200
    Gui, ScriptManager:Add, Button, gAddScript, Add
    Gui, ScriptManager:Add, Button, gRemoveScript x+5, Remove
    Gui, ScriptManager:Add, Button, gRunScript x+5, Run
    Gui, ScriptManager:Add, Button, gStopScriptSM x+5, Stop
    Gui, ScriptManager:Add, Button, gRunAllScriptManager x+5, Run All
    Gui, ScriptManager:Add, Button, gCloseAllScriptManager x+5, Stop All
    Gui, ScriptManager:Add, Button, gSaveScriptList x+20, Save
    Gui, ScriptManager:Add, Button, gCancelScriptManager x+5, Cancel
    Gui, ScriptManager:Show
    ReloadScriptList()
return

GetSelectedScript:
    GuiControlGet, selected, , ScriptList
    if (selected = "")
        return
    selectedIsRunning := InStr(selected, "[x]") > 0
    if (InStr(selected, "[ ]") > 0 || InStr(selected, "[x]") > 0) {
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
    scriptsRunning.Push("False")
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
            scriptsRunning.RemoveAt(A_Index)
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

StopScriptSM:
    Gosub, GetSelectedScript
    StopScript(selected)
    ReloadScriptList()
Return

ReloadScriptList() {
    global scriptDisplayNames, scriptPidDict
    GuiControl,, ScriptList, |

    Loop % scriptDisplayNames.Length(){
        isrunningstring := "[ ] "
        script := scriptDisplayNames[A_Index]
        for scriptt, pid in scriptPidDict {
            if (scriptt = script) {
                isrunningstring := "[x] "
                break
            }
        }
        displaystring := script
        displaystring = %isrunningstring%%displaystring%
        GuiControl,, ScriptList, %displaystring%
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

RunAllScriptManager:
    Gosub, LaunchScripts
    ReloadScriptList()
Return

CloseAllScriptManager:
    Gosub, CloseAllScripts
    ReloadScriptList()
return

;==================================================
; [ UTILITY FUNCTIONS ]
;==================================================
ProcessExist(PID)
{
    Process, Exist, %PID%
    return ErrorLevel
}

LoadScripts() {
    global scripts, scriptsRunning, scriptDisplayNames, iniFile
    scriptDisplayNames := []
    scripts := []
    scriptsRunning := []
    if !FileExist(iniFile)
    {
        ; Default scripts if no INI
        defaultScripts := ["WindowResize.ahk", "WinMove.ahk", "create_text_file.ahk", "shortcut_parent.ahk", "essential.ahk", "text_replacement.ahk", "ExcelScript.ahk", "symbol_type.ahk", "CapsLockKeyNav.ahk"]
        for index, script in defaultScripts
        {
            scriptPath := A_ScriptDir "\" script
            if FileExist(scriptPath) {
                scripts.Push(scriptPath)
                scriptDisplayNames.Push(script)
                scriptsRunning.Push("False")
            }
        }
        return
    }
    index := 1
    Loop {
        IniRead, scriptPath, %iniFile%, Scripts, Script%index%,
        if (scriptPath = "" || scriptPath = "ERROR")
            break
        if FileExist(scriptPath) {
            scripts.Push(scriptPath)
            SplitPath, scriptPath, fileName
            scriptDisplayNames.Push(fileName)
            IniRead, running, %iniFile%, Running, Script%index%, False
            scriptsRunning.Push(running)
        }
        index++
    }
}

SaveScripts() {
    global scripts, scriptsRunning, iniFile
    IniDelete, %iniFile%, Scripts
    IniDelete, %iniFile%, Running
    Loop % scripts.Length() {
        IniWrite, % scripts[A_Index], %iniFile%, Scripts, Script%A_Index%
        IniWrite, % scriptsRunning[A_Index], %iniFile%, Running, Script%A_Index%
    }
}

;==================================================
; [ END OF SCRIPT ]
;==================================================

