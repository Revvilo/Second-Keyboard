#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
; #Warn
; SetCapsLockState, AlwaysOff
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
; SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SetTitleMatchMode, 2
CoordMode, Tooltip, Screen
CoordMode, Mouse, Relative
CoordMode, Pixel, Screen

OnExit(Func("ExitRoutine"))

Process, Exist
Process, Priority, %ErrorLevel%, High

; AHI Key subscription
#Include Keybinds\SubscribeKeys.ahk

#Include Lib\BrowserControl.ahk
#Include Lib\Discord.ahk
#Include Lib\OBS.ahk
#Include Lib\Spotify.ahk
#Include Lib\TrayMenu.ahk
#Include Lib\VoicemeeterRemote.ahk

; ==== Tray Menu assembly ====
Menu, Tray, Icon, Second Keyboard Icon.ico

Menu, Tray, NoStandard
Menu, Tray, Add, % TrayMenu.Names.Open, TrayMenu.ListLines
Menu, Tray, Add
; Menu, Tray, Add, % TrayMenu.Names.EnableListLines, TrayMenu.EnableListLines
Menu, Tray, Add, % TrayMenu.Names.Reload, TrayMenu.Reload
Menu, Tray, Add, % TrayMenu.Names.Exit, TrayMenu.Exit
; ===========================
Menu, Tray, Default, % TrayMenu.Names.Open

; Initialize AHI - AutoHotInterception - https://github.com/evilC/AutoHotInterception
#Include Lib\AutoHotInterception\AutoHotInterception.ahk
Global AHI := new AutoHotInterception()

; Add keyboards to this array to register their keys for macros
; WARNING - UNTESTED WITH ANYTHING EXCEPT KEYBOARDS.
Global MacroKeyboards := {"PrimaryBoard": "HID\VID_03F0&PID_0024&REV_0130"}

; List of key names that will be overridden to call a correct callback function
Global keyAliases := {   "/": "ForwardSlash"
                , "'": "Apostrophe"
                , ";": "Semicolon"
                , ",": "Comma"
                , ".": "Dot"
                , "-": "Minus"
                , "=": "Equals"
                , "``": "Tilde"
                , "]": "RightBracket"
                , "[": "LeftBracket"
                , "\": "Backslash" }
                
SubscribeAllKeys()

Class KeybindSets {
    ; -- Each class is a set of keybinds assigned to a specific device (keyboard) with their own mode specific and global hotkeys
    Class PrimaryBoard {
        ; -- ALL BINDS (callbacks) PLACED IN 'GLOBAL' WILL OVERRIDE THE CURRENT MODE --
        #Include Keybinds\PrimaryBoard\Global.ahk
    }
}

Return

; Predicate to handle any options I want to apply to multiple keys - Mostly just to skip the key up event.
; - "Broker" is a possibly incorrect name, but it's the best I've come up with at the moment.
MacroBroker(deviceName, code, name, skipKeyUp, state) {

    DeviceGlobalClass := KeybindSets[deviceName]["Global"]

    ; MODIFIER HANDLING
    ; Handles modifier keys [always before skipping the up event]
    If (DeviceGlobalClass.modifierKeys.HasKey(name)) { ; Is this key a global modifier (irrespective of current mode)?
        ; This key was stated in the <devicename>/Hotkeys/Global.ahk class to be handled as a modifier
        Modifiers.HandleState(state, DeviceGlobalClass.modifierKeys[name])
        Return
    } Else If (DeviceModeClass.modifierKeys.HasKey(name)) { ; Is this key a modifier key specific to the current mode?
        ; This key was stated in the <devicename>/Hotkeys/<modename>.ahk class to be handled as a modifier
        Modifiers.HandleState(state, DeviceModeClass.modifierKeys[name])
        Return
    }
    ; After this the key isn't a modifier (yes I know these comments are insanely verbose. Quiet. It's private code.)

    ; SKIP KEYUP
    ; If skipKeyUp is true, and it's the key up event, stop processing.
    If ((!state) && skipKeyUp)
        Return


    ; ALIAS
    ; Puts an alias, if applicable, into effect - overriding the key's name with a callback-friendly string.
    If (keyAliases.HasKey(name)) {
        ; Stores the original input
        input := name
        name := keyAliases[name]
    }


    ; REMOVED MODE HANDLING - ADAPTED TO CALLBACK CHECK ONLY
    If (DeviceGlobalClass.HasKey(name)) { ; Does this device's global bindset have a callback for this key?
        callback := ObjBindMethod(DeviceGlobalClass, name)
    } Else {
        TrayTip,, % Format("Not modifier & no callback available`nKey: {}`nDevice: {}", name, deviceName)
    }

    ; CALLBACK
    ; And finally calls the callback
    Try {
        callback.Call(Modifiers.Get())
    } Catch e {
        If (e.level = "fatal" || !e.level) {
            ErrorMsg := "Exception thrown!`n`nWhat: " e.what "`nFile: " e.file
            . "`nLine: " e.line "`nMessage: " e.message "`nExtra: " e.extra

            MsgBox, 16, Exception in Callback, %ErrorMsg%
        } Else If (e.level = "info") {
            ErrorMsg := e.what "`n" e.message "`n" e.extra
            TrayTip,, %ErrorMsg%
        }
    }
}

nothing() {
}

; Modifier hotkey handling
Class Modifiers {
    Static CallbackFriendlyDelimiter := "_"
    Static ActiveModifiers := {}

    HandleState(pressed, key) {
        If (pressed == 1) {
            If (!Modifiers.ActiveModifiers[key]) {
                Modifiers.ActiveModifiers[key] := True
            }
        } Else {
            Modifiers.ActiveModifiers.Delete(key)
        }
    }

    Modifiers() {
    }

    ; Gets a string of all the currently pressed modifiers separated by 'delimiter'
    ; delimiter defaults to a space
    ToString(delimiter = " ") {
        output := ""
        For Key, Val in Modifiers.ActiveModifiers {
            If (Val) {
                output := output . Key . delimiter
            }
        }
        Return Trim(output, delimiter)
    }

    Get() {
        Return new Modifiers()
    }

    IsPressed(Keys*) {

        If (Keys.Count() > 0) {
            Msg := ""
            For Index, Name in Keys {
                Msg .= " " . Name . ","
            }
        }

        RequestList := Keys
        ActiveList := This.ActiveModifiers

        If (ActiveList.Count() != RequestList.Count()) { ; Match impossible if count of entries does not match
            Return False
        }

        For NeedleIndex, NeedleKey in RequestList { ; For each requested modifier
            Success := False
            For ActiveKey, ActiveIndex in ActiveList { ; For each active modifier
                If (NeedleKey = ActiveKey) {
                    Success := True
                    Break ; This iteration's search has succeeded
                }
            }
            If (!Success) {
                Return False ; Loop has exited without finding match
            }
        }
        Return True
    }
}

ExitRoutine(ExitReason, ExitCode) { ; All code for closing script here
    VoicemeeterRemote.ExitCleanup()
    ExitApp
}