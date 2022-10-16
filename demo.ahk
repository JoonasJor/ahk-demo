#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%


^1:: Run, firefox.exe https://www.oamk.fi/

^2:: open_notepad()

::datenow::
date_now()

open_notepad(){
    Run, notepad.exe
    Sleep, 100   
    Send, Hello
}

date_now(){
    FormatTime, Date1, , LongDate
    Send, %Date1%
}