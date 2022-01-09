#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

I_Icon = .\keyboard-settings-white.png
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%
Menu, Tray, Tip, AHK Hotkeys

; Modifier keys list
; # is windows key
; ! is alt
; ^ is ctrl
; >^ is rctrl
; <^ is lctrl
; + is shift
; <^>! is altgr

; Programming keys
; altgr +, = {
<^>!,::{

; altgr + . = }
<^>!.::}

; altgr+right shift +, = (
<^>!+,::
    Send (
return

; altgr+right shift + . = )
<^>!+.::
    Send )
return

; altgr+right ctrl +, = [
<^>!>^,::
    Send [
return

; altgr+right ctrl + . = ]
<^>!>^.::
    Send ]
return

; ctrl+shift+c - Quick google highlighted text
^+c::
    {
        Send, ^c
        Sleep 50
        Run, http://www.google.com/search?q=%clipboard%
    Return
}

; Media control
; left ctrl + left alt + {key}
<^<!s::Media_Play_Pause
<^<!a::Media_Prev
<^<!d::Media_Next
<^<!<::Volume_Mute
<^<!x::Volume_Up
<^<!z::Volume_Down
Browser_Back::Media_Prev
Browser_Forward::Media_Next

; Remap AppsKey to Win key (physical position on new keyboard changed places of LWin key which is super annoying)
AppsKey::LWin

; Remap key on numpad to Tab
NumpadHome::Tab
