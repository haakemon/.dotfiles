#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

I_Icon = .\keyboard-settings-white.png
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%
Menu, Tray, Tip, AHK Hotkeys

<^>!7::
{
  Send |
  Return
}
<^>!+7::
{
  Send \
  Return
}
<^>!+8::
{
  Send {{} ; Sends {
  Return
}
<^>!+9::
{
  Send {}} ; Sends }
  Return
}

; ctrl+shift+c - Quick google highlighted text
^+c::
    {
        Send, ^c
        Sleep 50
        Run, https://www.google.com/search?q=%clipboard%
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


; Remap ctrl v to win v to get paste history - not working as expected..
; <^v::Send, #v


; Remap to "mac style" @ key, and need to add back shift modifier to keep asterisk working
'::@

+'::*

+4::
{
  Send $
  Return
}

<^>!2::
{
  Send '
  Return
}

; Modifier keys list
; # is windows key
; ! is alt
; ^ is ctrl
; >^ is rctrl
; <^ is lctrl
; + is shift
; <^>! is altgr
