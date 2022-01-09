#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

I_Icon = .\window-restore-white.png
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%
Menu, Tray, Tip, AHK Toggle window on top with ctrl+alt+space

^!SPACE::  ; Appends " - AlwaysOnTop" to windows when they are AlwaysOnTop
WinGetActiveTitle, t
WinGet, ExStyle, ExStyle, %t%
if (ExStyle & 0x8) {
    WinSet, AlwaysOnTop, Off, %t%
    WinSetTitle, %t%, , % RegexReplace(t, " - AlwaysOnTop")
} else {
    WinSet, AlwaysOnTop, On, %t%
    WinSetTitle, %t%, , %t% - AlwaysOnTop
}
return
