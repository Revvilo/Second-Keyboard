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
#Include Lib\SubscribeKeys.ahk

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

; Add device 'hardware ids' to this array with a corresponding name to register all keys as macros.
; -- Format: "NAME":"HardwareID"
; WARNING - UNTESTED WITH ANYTHING EXCEPT KEYBOARDS.
Global MacroKeyboards := {"PrimaryBoard": "HID\VID_03F0&PID_0024&REV_0130"}

; ====== Multiline example ======
; Global MacroKeyboards := {"PrimaryBoard": "HID\VID_03F0&PID_0024&REV_0130"
;                         , "SecondaryBoard": "HID\VID_03F0&PID_0024&REV_0130"
;                         , "BoardBanan": "HID\VID_03F0&PID_0024&REV_0130"}

Class KeybindSets {
    ; -- Each class name within KeybindSets should correspond to a device using the NAME specified above.
    ; -- The class within the NAME class shall be a class named Global and can be included from a separate file as seen already.
    ; --- The location of the file is arbitrary, as you have to specify it yourself in the include statement, but the Keybinds/<devicename>/ folder is recommended.
    Class PrimaryBoard {
        #Include Keybinds\PrimaryBoard\Global.ahk
    }
}

Return

; Processes all inputs before calling the respective key's callback.
MacroBroker(deviceName, code, name, skipKeyUp, state) {

    DeviceGlobalClass := KeybindSets[deviceName]["Global"]

    ; MODIFIER HANDLING
    ; Handles modifier keys before checking the up event
    If (DeviceGlobalClass.modifierKeys.HasKey(name)) { ; Is this key a global modifier (irrespective of current mode)?
        ; This key was stated in the <devicename>/Hotkeys/Global.ahk class to be handled as a modifier
        Modifiers.HandleState(state, DeviceGlobalClass.modifierKeys[name])
        Return
    }

    ; Below here the key is NOT a modifier.

    ; SKIP KEYUP
    ; If skipKeyUp is true, and it's the key up event, just skip.
    If ((!state) && skipKeyUp)
        Return


    ; APPLY ALIASES
    ; Puts an alias, if applicable, into effect - overriding the key's name with a callback-friendly string.
    If (keyAliases.HasKey(name)) {
        ; Stores the original input
        ; input := name ; This is only needed if we use the raw 'input' below. Removed for efficiency.
        name := keyAliases[input]
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