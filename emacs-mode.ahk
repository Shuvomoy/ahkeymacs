;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; emacs-mode
;
; An AutoHotkey script for enabling Emacs-like keybindings that can be toggled
; on or off system-wide or per-application.
;
; AHK version: v1.1.x
; Language:    English
; Platform:    Windows
; Author:      Jamison Bryant <robojamison@gmail.com>
;
; For more information, see README.md.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;=======================================
; Variables
;=======================================

; System tray icon for when Emacs mode is enabled
enabled_icon := "icons/enabled.ico"

; System tray icon for when Emacs mode is disabled
disabled_icon := "icons/disabled.ico"

; Whether or not Emacs mode is currently enabled
emacs_mode_enabled := false

; Whether or not script debug mode is enabled
debug_mode_enabled := true

; Whether or not the space bar has just been pressed
; (used in certain key chords)
is_spacebar_pressed := false

; Whether or not the 'x' key has just been pressed
; (used in certain key chords)
is_x_key_pressed := false

;=======================================
; Initialization
;=======================================

; Prevent empty variables from being looked up as envvars
; (see https://autohotkey.com/docs/commands/_NoEnv.htm)
#NoEnv

; Make "Send" command synonymous with "SendInput" command
; (see https://autohotkey.com/docs/commands/SendMode.htm)
SendMode Input

; Set working directory to this script's home directory
; (see https://autohotkey.com/docs/commands/SetWorkingDir.htm)
SetWorkingDir %A_ScriptDir%

; Enable keyboard hook for monitoring keystrokes and hotkeys
; (see https://autohotkey.com/docs/commands/_InstallKeybdHook.htm)
#InstallKeybdHook
#UseHook

; Disable Emacs mode on script launch
enable_emacs_mode(emacs_mode_enabled)

; Force script instance to replace any existing instances on launch
if (debug_mode_enabled) {
  #SingleInstance force
}

;=======================================
; Functions
;=======================================
enable_emacs_mode(true_or_false) {
  local mode_icon = true_or_false ? enabled_icon : disabled_icon
  local mode_status = true_or_false ? "ON" : "OFF"
  emacs_mode_enabled := true_or_false

  ; Display system notification message
  TrayTip, Emacs Mode, Emacs mode is %mode_status%, 10, 1
  Menu, Tray, Icon, %mode_icon%,
  Menu, Tray, Tip, Emacs Mode`nEmacs mode is %mode_status%

  ; FIXME: Not sure what this does (left over from old scripts)
  Send {Shift Up}
}

; send_command(raw_command, windows_command, second_windows_command) {
;   ; Check if Emacs mode is enabled
;   ; If so, send translated Emacs -> Windows keystroke to system
;   ; Otherwise, send raw keystroke to system
;   if (emacs_mode_enabled) {
;     Send, %windows_command%

;     if (second_windows_command <> "") {
;       Send, %second_windows_command
;     }
;   } else {
;     Send, raw_command
;   }

;   return
; }

is_exempt_program() {
  ; Automatically return true if Emacs mode is disabled
;  if (!emacs_mode_enabled) {
;    return true
;  }

  ; Define AHK class names for programs to NOT enable Emacs mode on
  cygwin_class   := ConsoleWindowClass  ; Cygwin
  explorer_class := CabinetWClass       ; Windows Explorer
  chrome_class   := Chrome_WidgetWin_1  ; Google Chrome
  emacs_class    := Emacs               ; Emacs
  ; Add your exempt programs here! Use AU3_Spy to get the class name.

  ; Check if current window is in list of exempt programs
  ; If so, return true. Otherwise, return false.
  IfWinActive,ahk_class cygwin_class
    return true

  IfWinActive,ahk_class explorer_class
    return true

  IfWinActive,ahk_class chrome_class
    return true

  IfWinActive,ahk_class emacs_class
    return true

  return false
}

delete_char()
{
  Send {Del}
  is_spacebar_pressed = false
  return
}

delete_backward_char()
{
  Send {BS}
  is_spacebar_pressed = false
  return
}

kill_line()
{
  Send {ShiftDown}{END}{SHIFTUP}
  Sleep 50 ;[ms] this value depends on your environment
  Send ^x
  is_spacebar_pressed = false
  return
}

open_line()
{
  Send {END}{Enter}{Up}
  is_spacebar_pressed = false
  return
}

quit()
{
  Send {ESC}
  is_spacebar_pressed = false
  return
}

newline()
{
  Send {Enter}
  is_spacebar_pressed = false
  return
}

indent_for_tab()
{
  Send {Tab}
  is_spacebar_pressed = false
  return
}

newline_and_indent()
{
  Send {Enter}{Tab}
  is_spacebar_pressed = false
  return
}

isearch_forward()
{
  Send ^f
  is_spacebar_pressed = false
  return
}

isearch_backward()
{
  Send ^f
  is_spacebar_pressed = false
  return
}

kill_region()
{
  Send ^x
  is_spacebar_pressed = false
  return
}

kill_ring_save()
{
  Send ^c
  is_spacebar_pressed = false
  return
}

yank()
{
  Send ^v
  is_spacebar_pressed = false
  return
}

undo()
{
  Send ^z
  is_spacebar_pressed = false
  return
}

find_file()
{
  Send ^o
  is_x_key_pressed = 0
  return
}

save_buffer()
{
  Send, ^s
  is_x_key_pressed = 0
  return
}

kill_emacs()
{
  Send !{F4}
  is_x_key_pressed = 0
  return
}

move_beginning_of_line()
{
  if is_spacebar_pressed
    Send +{HOME}
  else
    Send {HOME}

  return
}

move_end_of_line()
{
  if is_spacebar_pressed
    Send +{END}
  else
    Send {END}

  return
}

previous_line()
{
  if is_spacebar_pressed
    Send +{Up}
  else
    Send {Up}
  return
}

next_line()
{
  if is_spacebar_pressed
    Send +{Down}
  else
    Send {Down}

  return
}

forward_char()
{
  if is_spacebar_pressed
    Send +{Right}
  else
    Send {Right}

  return
}

backward_char()
{
  if is_spacebar_pressed
    Send +{Left}
  else
    Send {Left}

  return
}

scroll_up()
{
  if is_spacebar_pressed
    Send +{PgUp}
  else
    Send {PgUp}

  return
}

scroll_down()
{
  if is_spacebar_pressed
    Send +{PgDn}
  else
    Send {PgDn}

  return
}

;=======================================
; Keybindings
;=======================================

CapsLock::
  enable_emacs_mode(!emacs_mode_enabled)
  return

^x::
  if (emacs_mode_enabled && !is_exempt_program()) {
    is_x_key_pressed := true
  } else {
    Send %A_ThisHotkey%
  }

  return

^f::
  if (emacs_mode_enabled && !is_exempt_program()) {
    if (is_x_key_pressed) {
      find_file()
    } else {
      forward_char()
    }
  } else {
    Send %A_ThisHotkey%
  }

  return

^c::
  if (emacs_mode_enabled && !is_exempt_program()) {
    if (is_x_key_pressed) {
      kill_emacs()
    }
  } else {
    Send %A_ThisHotkey%
  }

  return

^d::
  if (emacs_mode_enabled && !is_exempt_program()) {
    delete_char()
  } else {
    Send %A_ThisHotkey%
  }

  return

^h::
  if (emacs_mode_enabled && !is_exempt_program()) {
    delete_backward_char()
  } else {
    Send %A_ThisHotkey%
  }

  return

^k::
  if (emacs_mode_enabled && !is_exempt_program()) {
    kill_line()
  } else {
    Send %A_ThisHotkey%
  }

  return

^g::
  if (emacs_mode_enabled && !is_exempt_program()) {
    quit()
  } else {
    Send %A_ThisHotkey%
  }

  return

^m::
  if (emacs_mode_enabled && !is_exempt_program()) {
    newline()
  } else {
    Send %A_ThisHotkey%
  }

  return

^i::
  if (emacs_mode_enabled && !is_exempt_program()) {
    indent_for_tab()
  } else {
    Send %A_ThisHotkey%
  }

  return

^s::
  if (emacs_mode_enabled && !is_exempt_program()) {
    if (is_x_key_pressed) {
      save_buffer()
    } else {
      isearch_forward()
    }
  } else {
    Send %A_ThisHotkey%
  }

  return

^r::
  if (emacs_mode_enabled && !is_exempt_program()) {
    isearch_backward()
  } else {
    Send %A_ThisHotkey%
  }

  return

^w::
  if (emacs_mode_enabled && !is_exempt_program()) {
    kill_region()
  } else {
    Send %A_ThisHotkey%
  }

  return

!w::
  if (emacs_mode_enabled && !is_exempt_program()) {
    kill_ring_save()
  } else {
    Send %A_ThisHotkey%
  }

  return

^y::
  if (emacs_mode_enabled && !is_exempt_program()) {
    yank()
  } else {
    Send %A_ThisHotkey%
  }

  return

^/::
  if (emacs_mode_enabled && !is_exempt_program()) {
    undo()
  } else {
    Send %A_ThisHotkey%
  }

  return

;$^{Space}::
^vk20sc039::
  if (emacs_mode_enabled && !is_exempt_program()) {
    Send {CtrlDown}{Space}{CtrlUp}
  } else {
    is_spacebar_pressed := (is_spacebar_pressed ? false : true)
  }

  return

^@::
  if (emacs_mode_enabled && !is_exempt_program()) {
    is_spacebar_pressed := (is_spacebar_pressed ? false : true)
  } else {
    Send %A_ThisHotkey%
  }

  return

^a::
  if (emacs_mode_enabled && !is_exempt_program()) {
    move_beginning_of_line()
  } else {
    Send %A_ThisHotkey%
  }

  return

^e::
  if (emacs_mode_enabled && !is_exempt_program()) {
    move_end_of_line()
  } else {
    Send %A_ThisHotkey%
  }

  return

^p::
  if (emacs_mode_enabled && !is_exempt_program()) {
    previous_line()
  } else {
    Send %A_ThisHotkey%
  }

  return

^n::
  if (emacs_mode_enabled && !is_exempt_program()) {
    next_line()
  } else {
    Send %A_ThisHotkey%
  }

  return

^b::
  if (emacs_mode_enabled && !is_exempt_program()) {
    backward_char()
  } else {
    Send %A_ThisHotkey%
  }

  return

^v::
  if (emacs_mode_enabled && !is_exempt_program()) {
    scroll_down()
  } else {
    Send %A_ThisHotkey%
  }

  return

!v::
  if (emacs_mode_enabled && !is_exempt_program()) {
    scroll_up()
  } else {
    Send %A_ThisHotkey%
  }

  return
