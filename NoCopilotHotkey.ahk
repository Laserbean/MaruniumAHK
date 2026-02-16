#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

; #InputLevel, 1
#^!Shift::
#^+Alt::
#!+Ctrl::
^!+LWin::
^!+RWin::

    Send {Blind}{vk07}

return