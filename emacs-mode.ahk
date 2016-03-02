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

; Disable Emacs mode on script launch
enable_emacs_mode(emacs_mode_enabled)

; Force script instance to replace any existing instances on launch
if (debug_mode_enabled) {
  #SingleInstance force
}

;=======================================
; Functions
;=======================================
enable_emacs_mode(tof) {
  local mode_icon = tof ? enabled_icon : disabled_icon
  local mode_status = tof ? "ON" : "OFF"
  emacs_mode_enabled := tof

  ; Display system notification message
  TrayTip, Emacs Mode, Emacs mode is %mode_status%, 10, 1
  Menu, Tray, Icon, %mode_icon%,
  Menu, Tray, Tip, Emacs Mode`nEmacs mode is %mode_status%

  ; FIXME: Not sure what this does (left over from old scripts)
  Send {Shift Up}
}

;=======================================
; Keybindings
;=======================================

CapsLock::
  enable_emacs_mode(!emacs_mode_enabled)
  return
