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

#Include Lib\Acc.ahk
#Include Lib\BrowserControl.ahk
#Include Lib\Discord.ahk
#Include Lib\FullscreenWindowed.ahk
#Include Lib\Minecraft.ahk
#Include Lib\Misc.ahk
#Include Lib\MixerControl.ahk
#Include Lib\ModeHandler.ahk
#Include Lib\OBS.ahk
#Include Lib\Spotify.ahk
#Include Lib\TrayMenu.ahk
#Include Lib\Vegas.ahk
#Include Lib\VLC.ahk
#Include Lib\VoicemeeterRemote.ahk

; Tray menu info
Global tray_mainHotkeysName := "Enable Main Keyboard Binds"

; ==== Tray Menu assembly ====
Menu, Tray, Icon, Second Keyboard Icon.ico

Menu, Tray, NoStandard
Menu, Tray, Add, % TrayMenu.Names.Open, TrayMenu.ListLines
Menu, Tray, Add
Menu, Tray, Add, % TrayMenu.Names.CycleMode, TrayMenu.CycleMode
; Menu, Tray, Add, % TrayMenu.Names.EnableListLines, TrayMenu.EnableListLines
Menu, Tray, Add, % TrayMenu.Names.ToggleDebug, TrayMenu.ToggleDebug
Menu, Tray, Add, % TrayMenu.Names.MainHotkeys, TrayMenu.ToggleMainHotkeys
Menu, Tray, Add
Menu, Tray, Add, % TrayMenu.Names.Reload, TrayMenu.Reload
Menu, Tray, Add, % TrayMenu.Names.Exit, TrayMenu.Exit
; ===========================
Menu, Tray, Default, % TrayMenu.Names.Open

; Initialize AHI - AutoHotInterception - https://github.com/evilC/AutoHotInterception
#Include Lib\AutoHotInterception\AutoHotInterception.ahk
Global AHI := new AutoHotInterception()

; Add keyboards to this array to register their keys for macros
; WARNING - UNTESTED WITH ANYTHING EXCEPT KEYBOARDS.
Global MacroKeyboards := {"PrimaryBoard": "HID\VID_03F0&PID_0024&REV_0130"
                        , "FootPedal": "HID\VID_03F0&PID_0024&REV_0300"}


; General globals
Global mainKeyboardHotkeys := False
Global debug := False
Global timerVars := {}
Global StopwatchRunning := False
Global BeginTickCount := ""
Global EndTickCount := ""


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

; If shift is held while booting up, turn on debug mode.
If (GetKeyState("Shift")){
    ToggleDebug()
}

; Lists devices if debug mode is on. (Hold shift when the script is starting)
If (Debug) {
    tempStr := ""
    For i, v in AHI.GetDeviceList() {
        For i2, v2 in v {
            tempStr := tempStr . "`n" . v2
        }
        tempStr := tempStr . "`n"
    }
    msgbox % "Device List:`n`n"tempStr
}

Sounds.PopulateSounds()
Soundboard.PopulateSounds()
; Soundboard.LoadSettings() ; Not loading because there is no way of changing the settings from within the script yet
Sounds.SFX.PopulateSounds()
SubscribeAllKeys()

ModeHandler.ModeList := ["General", "Browser", "Resolve", "RPG"]
ModeHandler.Mode := 1

CheckRedundantKeybinds()

If (WinExist("ahk_exe Spotify.exe") && WinExist("Volume Mixer")) {
    Spotify.VolChange(0, "change") ; Workaround way of automatically locating spotify's volume slider on script-start. Should be improved.
}

Class KeybindSets {
    ; -- Each class is a set of keybinds assigned to a specific device (keyboard) with their own mode specific and global hotkeys
    Class PrimaryBoard {
        ; -- ALL BINDS (callbacks) PLACED IN 'GLOBAL' WILL OVERRIDE THE CURRENT MODE --
        #Include Keybinds\PrimaryBoard\Global.ahk
        ; -- #Include other callback classes below here with the same name as it's respective mode
        #Include Keybinds\PrimaryBoard\Browser.ahk
        #Include Keybinds\PrimaryBoard\General.ahk
        #Include Keybinds\PrimaryBoard\Resolve.ahk
        #Include Keybinds\PrimaryBoard\RPG.ahk
    }
    Class NumpadBoard {
        ; -- ALL BINDS (callbacks) PLACED IN 'GLOBAL' WILL OVERRIDE THE CURRENT MODE --
        #Include Keybinds\NumpadBoard\Global.ahk
        ; -- #Include other callback classes below here with the same name as it's respective mode
    }
}

Global DeviceTypes := {"Macroboard" : 0, "Pedal" : 1}
    
Return

; =================== ;
; Main Keyboard Binds ;
; =================== ;

#If
~*!x:: ; ALT + x
    Discord.ToggleMute()
Return
*!z:: ; ALT + z
    Discord.ToggleDeafen()
Return
*>!o:: ; RIGHT Alt + O
    OBS.ToggleRecording()    ; Toggle Recording
Return
*<!F1:: ; LEFT Alt + F1
    Spotify.PlayPause()
Return
*<!<^F2:: ; LEFT Alt + LEFT Control + F2
    Spotify.Next()
Return
*<!<^F1:: ; LEFT Alt + LEFT Control + F1
    VoicemeeterRemote.ToggleDim(VoicemeeterRemote.Strips["Spotify"])
Return
*<!F2:: ; Left Alt + F2
    KeyWait, Alt, Up
    Sleep, 10
    BrowserControl.PlayPause()
Return
!+p:: ; Alt Shift P
    ; DetectHiddenWindows, On
    WinGet, OutputVar, List, ahk_exe Spotify.exe
    Loop %OutputVar% {
        temp := OutputVar%A_Index%
        WinGetTitle, temp1, ahk_id %temp%
        Msgbox, % temp1 . "`nID: " . temp
        ControlSend,, {space}, ahk_id %temp%
    }
    DetectHiddenWindows, Off
Return
^!F4::
    WinKill, A
Return
;Testing hotkey
; ^h::
;     Msgbox, % DllCall(VoicemeeterRemote.mFunctions["IsParametersDirty"], "Int")
; Return


; ==================== ;
; ==== Hotstrings ==== ;
; ==================== ;

#Include Hotstrings\Minecraft-Hotstrings.ahk

#Include Hotstrings\Path-Shortcuts.ahk


; Predicate to handle any options I want to apply to multiple keys - Mostly just to skip the key up event.
; - "Broker" is a possibly incorrect name, but it's the best I've come up with at the moment.
MacroBroker(deviceName, code, name, skipKeyUp, state) {

    DeviceGlobalClass := KeybindSets[deviceName]["Global"]
    DeviceModeClass := KeybindSets[deviceName][ModeHandler.Mode]
    DebugMessage((Format("========== The key {} was intercepted. ==========`n`n"
    . "Device name: " . deviceName . "`n"
    . "Current mode: " . ModeHandler.Mode . "`n`n"
    . "Callback: `t{}`n"
    . "Key Code:`t{}`n"
    . "Global bind:`t{}`n`n"
    . "Modifiers:`t{}`n`n"
    . "Using alias:`t{}{}`n"
    . "Ignore key up:`t{}"
    , state ? "pressed" : "released"
    , keyAliases.HasKey(name) ? keyAliases[name] : name
    , code
    , KeybindSets[deviceName].Global.HasKey(name) ? "Yes" : "No"
    , Modifiers.ToString() == "" ? "None" : Modifiers.ToString()
    , keyAliases.HasKey(name) ? "Yes" : "No"
    , keyAliases.HasKey(name) ? ("`nOriginal Name:`t" . name) : ""
    , skipKeyUp ? "Yes" : "No")))

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

    ; If skipKeyUp is true, and it's the key up event, stop processing.
    If ((!state) && skipKeyUp)
        Return

    ; Puts an alias, if applicable, into effect - overriding the key's name with a callback-friendly string.
    If (keyAliases.HasKey(name)) {
        ; Stores the original input
        input := name
        name := keyAliases[name]
    }

    ; Below determines which callback to run respective of the current mode using the following rules in order;
    ; -If there is a callback for this key in the <devicename>/Hotkeys/Global class, it completely ignores the current mode and runs that callback.
    ; -Else it runs the callback from the current mode's class instead.
    ; -Otherwise, if no callback is available, notify the user and return.

    ; CurrentModifiers := Modifiers.ToString(Delimiter := Modifiers.CallbackFriendlyDelimiter)
    If (DeviceGlobalClass.HasKey(name)) { ; Does this device's global bindset have a callback for this key?
        callback := ObjBindMethod(DeviceGlobalClass, name)
    } Else If (DeviceModeClass.HasKey(name)) { ; Does this device's current mode bindset have a callback for this key?
        callback := ObjBindMethod(DeviceModeClass, name)
    } Else {
        TrayTip,, % Format("Not modifier & no callback available`nKey: {}`t`tMode: {}`nDevice: {}", name, ModeHandler.Mode, deviceName)
        DebugMessage("No callback available. Have you #included the mode class?")
    }

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

; Sneaky little function
nothing() {
}

Class Soundboard {
    Static ProfileCount := 8
    Static SlotCount := 9
    Static IniName := "SoundboardConfig.ini"
    Static CurrProfileIndex := 1 ; Starting setting for selected profile on boot
    ; ^^ Config ^^

    Static Binds := []
    Static SoundList := {}

    PopulateSounds() {
        This.SoundList := {}
        Loop, Files, Soundboard\*, F
        {
            fileName := StrSplit(A_LoopFileName, .)[1]
            This.SoundList[filename] := A_ScriptDir . "\Soundboard\" . A_LoopFileName
        }

        Loop, Files, Soundboard\Voicemeeter\*, F
        {
            fileName := StrSplit(A_LoopFileName, .)[1]
            This.SoundList[filename] := A_ScriptDir . "\Soundboard\Voicemeeter\" . A_LoopFileName
        }
    }

    Stop() {
        VoicemeeterRemote.StopPlayback()
    }

    Play() {
        VoicemeeterRemote.PlayRecorder()
    }

    SetProfile(ByRef ProfileIndex) {
        If ((ProfileIndex is Number) && (ProfileIndex <= This.ProfileCount))
            This.CurrProfileIndex := ProfileIndex
        This.ShowSettings(Refresh := True)
    }

    PlaySlot(ByRef Index) {
        If (Index <= This.SlotCount)
            IniRead, OutputVar, % This.IniName, % This.CurrProfileIndex, %Index%
            If (OutputVar != "") {
                If (SubStr(OutputVar, 2, 1) == ":") {
                    VoicemeeterRemote.PlayFile(OutputVar)
                } Else {
                    VoicemeeterRemote.PlayFile(This.SoundList[OutputVar])
                }
            } Else {
                TrayTip, Soundboard, Slot not bound
            }
    }

    SaveSettings() {
        Loop, % This.ProfileCount {
            ProfileIndex := A_Index
            Loop, %SlotCount% {
                IniWrite, % This.Binds[ProfileIndex][A_Index], % This.IniName, % ProfileIndex, %A_Index%
            }
        }
    }

    FadeOutSettings(duration := 100) {
        DllCall("AnimateWindow", "Ptr", WinExist(), "UInt", duration, "UInt", fadeIn ? 0x80000 : 0x80000 | 0x10000)
        Gui SoundboardDisplay:Destroy
    }

    ShowSettings(Refresh := False) {
        ; TODO: Close [fade out] soundboard display after a duration
        Gui SoundboardDisplay:+LastFoundExist
        If (WinExist() && !Refresh) {
            This.FadeOutSettings()
        } Else If !(!WinExist() && Refresh) {
            SysGet, OutputVar, MonitorWorkArea
            Width := 500
            Height := 180
            Padding := 2
            PosX := OutputVarRight - Width - Padding
            PosY := OutputVarBottom - Height - Padding
            
            Gui SoundboardDisplay:New ; TODO: see if there's a way to update all the controls on the window without re-creating it (which makes it flash)
            Gui -Caption +AlwaysOnTop
            Gui, Add, Text,, % "Current Profile: " . This.CurrProfileIndex
            Gui, Add, Text, yp+15,

            Loop % This.SlotCount {
                IniRead, OutputVar, % This.IniName, % This.CurrProfileIndex, % A_Index
                OutputVar := Format("{} - {}", A_Index, OutputVar)
                Gui, Add, Text, yp+15, %OutputVar%
            }

            Gui, Show, W%Width% H%Height% X%PosX% Y%PosY% NA
            Gui +LastFound
            WinGet GUI_ID, ID
            ; SetTimer, FadeOutSettingsTimer, -1
            Return

            ; FadeOutSettingsTimer:
            ;     Sleep, 1500
            ;     DllCall("AnimateWindow", "Ptr", WinExist(), "UInt", 1000, "UInt", fadeIn ? 0x80000 : 0x80000 | 0x10000)
            ;     ; This.FadeOutSettings(1000)
            ; Return
        }
    }

    LoadSettings() {
        Loop, % This.ProfileCount {
            ProfileIndex := A_Index
            This.Binds[ProfileIndex] := {}
            Loop, % This.SlotCount {
                IniRead, OutputVar, % This.IniName, % ProfileIndex, %A_Index%
                This.Binds[ProfileIndex][A_Index] := OutputVar
            }
        }
        ; IniRead, OutputVar, Filename, Section, Key [, Default]
    }
}

; Sounds provider
Class Sounds {
    PopulateSounds() {
        Loop, Files, Sounds\*.mp3, F
        {
            filename := StrSplit(A_LoopFileName, .)[1]
            this[filename] := "Sounds\" . A_LoopFileName
        }
    }
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
        DebugMessage(Format("`n[Modifier Handler]`tBeginning {}    Held modifiers: {}", Keys.Count() < 1 ? "check for no modifiers." : "search for following modifiers:    Requested Modifiers: " . Keys.Count(), This.ActiveModifiers.Count()))

        If (Keys.Count() > 0) {
            Msg := ""
            For Index, Name in Keys {
                Msg .= " " . Name . ","
            }
            DebugMessage("`t-" . SubStr(Msg, 1, -1))
        }

        RequestList := Keys
        ActiveList := This.ActiveModifiers

        If (ActiveList.Count() != RequestList.Count()) { ; Match impossible if count of entries does not match
            DebugMessage("`tArray lengths do not match.")
            DebugMessage(">> Match failure, returning False.")
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
                DebugMessage("`tSearch iteration completed without finding match.")
                DebugMessage(">> Match failure, returning False.")
                Return False ; Loop has exited without finding match
            }
        }
        DebugMessage(">>> Match success; returning True.`n`n")
        Return True
    }
}

ToggleDebug() {
    If (debug) {
        Global debug = False    ; Disable
        Menu, Tray, Uncheck, % TrayMenu.Names.ToggleDebug
        SoundPlay, % sounds.disconnected
    } Else {
        Global debug = True     ; Enable
        Menu, Tray, Check, % TrayMenu.Names.ToggleDebug
        SoundPlay, % Sounds.connected
    }
}

CheckRedundantKeybinds() {
    For i, val in ModeHandler.ModeList {
        listOfRedundantCallbacks := ""
        For ii, value in KeybindSets[val] {
            ; Msgbox, Callback %ii%
            If (KeybindSets.Global.HasKey(ii) && ii != "__Class") {
                listOfRedundantCallbacks := listOfRedundantCallbacks . "`n" . ii
            }
        }
        If (listOfRedundantCallbacks != "")
            Msgbox, % Format("The following list of keys will not ever trigger because they already have a callback inside of Global.`n`n`nMode: {}{}", val, listOfRedundantCallbacks)
    }
}

ResetVolumeMixer(vol := "") {
    oldDHW := A_DetectHiddenWindows
    DetectHiddenWindows, On
    If (!WinExist("ahk_exe SndVol.exe")) {
        Run, SndVol.exe,, Min
        WinWait, Volume Mixer
    }
    DetectHiddenWindows, %oldDHW%

    WinGet, mixerHandle, ID, Volume Mixer
    WinGet, mixerControlList, ControlList, ahk_id %mixerHandle%
    controlsArray := StrSplit(mixerControlList, "`n")

    If (vol == "") {
        ; Sets every entry in the Audio Mixer to the current system volume
        SoundGet, systemVolume
        systemVolume := Floor(systemVolume)
        MsgBox, 1, Reset Volume Mixer?, This will reset all sliders in the volume mixer to the system volume: %systemVolume%
        IfMsgBox, Cancel
            Return
        TrayTip, Resetting all sliders in the Mixer, No target volume specified.`nDefaulting to system volume: %systemVolume%
        vol := 100 - systemVolume
    } Else {
        TrayTip, Setting all sliders in the Mixer, Volume was specified.`nSetting to volume: %vol%
        vol := 100 - vol
    }

    If (mixerControlList != "") {
        For i, e in controlsArray {

            ; If the line is a static text control
            If (RegExMatch(e, "msctls_trackbar\d{0,9}")) {
                SendMessage TBM_SETPOSNOTIFY:=0x422, 1, %vol%, %e%, Volume Mixer
            }
        }
    }
}

; Msgbox that requires 'debug' to be true in order to show
DebugMessage(inMsg := "")
{
    OutputDebug, % inMSG
    ; If (debug) {
    ;     Msgbox, % inMsg
    ; }
}

; Traytip variation of above
DebugTrayTip(inMSG := "") {
    OutputDebug, % inMSG
    If (debug) {
        TrayTip, % "Debugging", %inMSG%
    }
}

; -- This automatically toggles a timer for the name provided.
; -- The name must be a function or label NAME. Without the ().
; -- Returns 1 upon timer started and 0 for timer stopped
; --- TODO: Could possibly use Func() objects for this instead.
ToggleTimer(timerName, endExec := "", forceState := "") {
    if (forceState == true) {
        timerVars[timerName] := True
        SoundPlay, % Sounds.Connected
        SetTimer, %timerName%, 0
        Return, timerVars[timerName]
    } else if (forceState == false) {
        timerVars[timerName] := False
        SoundPlay, % Sounds.Disconnected
        SetTimer, %timerName%, Delete
        Return, timerVars[timerName]
    } else {
        if (!timerVars[timerName]) {
            timerVars[timerName] := True
            SoundPlay, % Sounds.Connected
            SetTimer, %timerName%, 0
            Return, timerVars[timerName]
        } else {
            timerVars[timerName] := False
            SoundPlay, % Sounds.Disconnected
            SetTimer, %timerName%, Delete
            Return, timerVars[timerName]
        }
    }
}

; -- Autoclicker macro for use with 'settimer'
AutoClicker() {
    Click, Right
}

; -- Autoclicker macro for use with 'settimer'
AutoAttack() {
    Click, Left
}

Stopwatch() {
    If (!StopwatchRunning) {
        StopwatchRunning := True
        BeginTickCount := A_TickCount
    } Else {
        StopwatchRunning := False
        EndTickCount := A_TickCount
        ElapsedMS := EndTickCount - BeginTickCount
        FormatTime, OutputTime, HHMMSS, Format
        Msgbox, %ElapsedMS%
    }
}

ExitRoutine(ExitReason, ExitCode) { ; All code for closing script here
    VoicemeeterRemote.ExitCleanup()
    ExitApp
}