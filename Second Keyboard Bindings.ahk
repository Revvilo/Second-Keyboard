#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
; #Warn
; ListLines Off
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

Process, Exist
Process, Priority, %ErrorLevel%, High

; This is a flipping mess
#Include, F:\Programming\AHK Scripts\Fullscreen Windowed.ahk
#Include Initialization\Vegas.ahk

; AHI Key subscription
#Include Keybinds\SubscribeKeys.ahk

#Include Lib\BrowserControl.ahk
#Include Lib\Vegas.ahk
#Include Lib\Minecraft.ahk
#Include Lib\Spotify.ahk
#Include Lib\OBS.ahk
#Include Lib\VLC.ahk
#Include Lib\Acc.ahk

; Tray menu info
Global tray_mainHotkeysName := "Main Keyboard Hotkeys"

; ==== Tray Menu assembly ====
Menu, Tray, Icon, Second Keyboard Icon.ico
Menu, Tray, Add
Menu, Tray, Add, Cycle Mode, TrayMenu_CycleMode
Menu, Tray, Add, Debug Mode, ToggleDebug
Menu, Tray, Add, %tray_mainHotkeysName%, ToggleMainHotkeys
; Menu, Tray, Check, %tray_mainHotkeysName%
Menu, Tray, Add
Menu, Tray, Add, % "Second Keyboard Bindings HUB", nothing
Menu, Tray, Add, % "© Revvilo - 2019", nothing
; ===========================

; Initialize AHI - AutoHotInterception - https://github.com/evilC/AutoHotInterception
#Include Lib\AutoHotInterception\AutoHotInterception.ahk
Global AHI := new AutoHotInterception()

; Add keyboards to this array to register their keys for macros
; WARNING - UNTESTED WITH ANYTHING EXCEPT KEYBOARDS.
Global MacroKeyboards := {"PrimaryBoard": "HID\VID_03F0&PID_0024&REV_0130"
                        , "NumpadBoard": "HID\VID_03F0&PID_0024&REV_0300"}

; General globals
Global luaMacrosPath := "F:\Programming\luamacros"
Global soundsPath := A_WorkingDir . "\Sounds\"
Global mainKeyboardHotkeys := False
Global toggle_mcMacros
Global debug := False
Global reloadingScript := False
Global timerVars := {}
Global StopwatchRunning := False
Global BeginTickCount := ""
Global EndTickCount := ""


; List of keys that will be overridden to call a correct callback function
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
Sounds.SFX.PopulateSounds()
SubscribeAllKeys()

ModeHandler.ModeList := ["General", "Minecraft", "Editing", "Animating"]
ModeHandler.Mode := 1

CheckRedundantKeybinds()

If (WinExist("ahk_exe Spotify.exe") && WinExist("Volume Mixer")) {
    Spotify.VolChange(0, "change")
}

Class KeybindSets {
    ; -- Each class is a set of keybinds assigned to a specific device (keyboard) with their own mode specific and global hotkeys
    Class PrimaryBoard {
        ; -- ALL BINDS (callbacks) PLACED IN 'GLOBAL' WILL OVERRIDE THE CURRENT MODE --
        #Include Keybinds\PrimaryBoard\Global.ahk
        ; -- #Include other callback classes below here with the same name as it's respective mode
    }
    Class NumpadBoard {
        ; -- ALL BINDS (callbacks) PLACED IN 'GLOBAL' WILL OVERRIDE THE CURRENT MODE --
        #Include Keybinds\NumpadBoard\Global.ahk
        ; -- #Include other callback classes below here with the same name as it's respective mode
    }
}

Return

TrayMenu_CycleMode:
    ModeHandler.Cycle()
Return

; =================== ;
; Main Keyboard Binds ;
; ====================;

#IfWinActive, Minecraft
; Hotstrings
::#sel::{#}selection
::#set::{#}selection set
::#killitems::kill @e[type=item]
::#sp::{#}fill reccomplex:generic_space air
::#y::{#}confirm
::#n::{#}cancel
::#cl::{#}fill air
::#d::{#}selection clear
::#tree::{#}selection wand log|log2|leaves|leaves2
::#deltree::{#}fill air log|log2|leaves|leaves2

::#testplatform::{#}selection set 699 4 -734 589 15 -848 --first --second
::#testplatair::{#}selection set 699 16 -734 589 255 -848 --first --second

::#ex::{#}selection expand
::#exh::{#}selection expand -z 1 -x 1
::#shh::{#}selection expand -z -1 -x -1

::#solid::{#}fill reccomplex:generic_solid air
::#delsolid::{#}fill air reccomplex:generic_solid
::#space::{#}fill reccomplex:generic_space air
::#dsp::{#}fill air reccomplex:generic_space
::#delspace::{#}fill air reccomplex:generic_space

::#w::{#}selection wand
::#up1::{#}selection set ~ ~1 ~
::#dn1::{#}selection set ~ ~-1 ~
:O:#p1::{#}selection set ~ ~ ~ --first{left 10}
:O:#p2::{#}selection set ~ ~ ~ --second{left 11}
Return

#IfWinActive, Voltz
~$^w::
    SendInput, {w down}
    sleep 100
    SendInput {w up}
    Sleep 50
    SendInput, {w down}
    KeyWait, w
    SendInput, {w up}
Return

#If
*>!o:: ; Right Alt + O
    OBS.SendToOBS("{F22}")    ; Toggle Recording
Return
^!F4::
    WinKill, A
Return
; ^!p::
; {
;     ControlClick, Start, Alarms & Clock
; }
; Return
; ~CapsLock UP::
;     SetCapsLockState, Off
; ^p::
;     ; SendMessage %LB_SELECTSTRING%,0,&txt,, ahk_id %hlblList% 
;     txt := "1"
;     SendMessage, LB_SELECTSTRING := 0x018C, 0, "1",, ahk_id 0x740440 ;LB_SETCURSEL := 0x186
;     Msgbox, %ErrorLevel%

    ; MsgBox, % oAcc.accSelection()
    ; coAcc := oAcc.accChild(1)
    ; MsgBox, % coAcc.accName(0)
    ; oAcc.accSelect(2, "1")
    ; Msgbox, %ErrorLevel%
    ; Control, ChooseString, 1, Qt5QWindowIcon17, ahk_exe obs64.exe
    ; SendMessage, LB_SELECTSTRING, [wParam, lParam, Qt5QWindowIcon17, OBS
    ; ControlGet items, Visible, , Qt5QWindowIcon17, OBS
    ; Msgbox, %items%
Return
; ^F1::
; {
;     Try {
;         SoundPlay, % Sounds.SFX.stopSounds
;     } Catch e {
;         Msgbox, Error
;     }
;     ; ControlGet, OutputVar, List,, Qt5QWindowIcon5, ahk_exe obs64.exe
;     ; Msgbox, %OutputVar%
;     ; WinGet, obsControlList, ControlList, ahk_exe obs64.exe
;     ; ; ControlGet, obsScenesText, Cmd, [Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText
;     ; ; Msgbox, %obsScenesText%
;     ; OutStr := ""
;     ; Loop, Parse, obsControlList
;     ; {
;     ;     ; ControlGetText, obsScenesText, %A_LoopField%, ahk_exe obs64.exe
;     ;     ; Msgbox, %A_Index%`t%obsScenesText%
;     ;     ControlGet, OutputVar, List, Count, Qt5QWindowIcon5, OBS
;     ;     ; Msgbox, %A_Index%`t%OutputVar%
;     ;     OutStr .= OutputVar . "`n"
;     ; }
    
;     ; Msgbox, %OutStr%
;     ; Return
; }
; Return
; ============================ ;
; AHI Keypress callbacks below ;
; ============================ ;

; Predicate to handle any options I want to apply to multiple keys - Mostly just to skip the key up event.
; - "Broker" is a possibly incorrect name, but it's the best I have.
MacroBroker(deviceName, code, name, skipKeyUp, state) {

    DeviceGlobalClass := KeybindSets[deviceName]["Global"]
    DeviceModeClass := KeybindSets[deviceName][mode]

    ; I use an if debug in this case for performance, since the message is so large and inefficient.
    If (debug)
    Msgbox, % (Format("A macro key was pressed and debug mode is on.`n`n"
    . "Device name: " . deviceName . "`n`n"
    . "Global bind:`t{}`n`n"
    . "Callback: `t{}`n"
    . "Key Code:`t{}`n"
    . "Modifiers:`t{}`n`n"
    . "Using alias:`t{}{}`n"
    . "Ignore key up:`t{}`n`n"
    , KeybindSets[deviceName].Global.HasKey(name) ? "Yes" : "No"
    , name
    , code
    , Modifiers.Get() == "" ? "None" : Modifiers.Get()
    , keyAliases.HasKey(input) ? "Yes" : "No"
    , keyAliases.HasKey(input) ? ("`nOriginal Name:`t" . input) : ""
    , skipKeyUp ? "Yes" : "No"))

    ; Handles modifier keys
    If (DeviceGlobalClass.modifierKeys.HasKey(name)) {
        Modifiers.HandleState(state, DeviceGlobalClass.modifierKeys[name])
        Return
    } Else If (DeviceModeClass.modifierKeys.HasKey(name)) {
        Modifiers.HandleState(state, DeviceModeClass.modifierKeys[name])
        Return
    }

    ; If skipKeyUp is true, and it's the key up event, stop processing.
    If ((!state) && skipKeyUp)
        Return

    ; Puts an alias, if applicable, into effect - overriding the key's name.
    If (keyAliases.HasKey(name)) {
        ; Stores the original input
        input := name
        name := keyAliases[name]
    }




    ; Determines what callback to choose based on the current mode using the following rules in order;
    ; -If there is a callback for said key in the .Hotkeys/Global class, it completely ignores the current mode and selects it.
    ; -If one doesn't exist in the global hotkeys, it selects the callback from the respective mode's class instead.
    ; -If the callback that was chosen doesn't actually exist, it simply returns, and if debug mode is on, alerts the user.
    If (DeviceGlobalClass.HasKey(name)) {
        callback := ObjBindMethod(DeviceGlobalClass, name)
    } Else If (DeviceModeClass.HasKey(name)) {
        callback := ObjBindMethod(DeviceModeClass, name)
    } Else {
        TrayTip,, % Format("Not modifier & no callback available`nKey: {}`t`tMode: {}`nDevice: {}", name, ModeHandler.Mode, deviceName)
        DebugMessage("No callback available.")
        Return
    }

    ; And finally calls the callback
    Try {
        callback.Call(Modifiers.Get())
    } Catch e {
        Msgbox, % "An error occured within the callback.`n`nYou can double click the icon in the system tray while this msgbox is open to see the line where it errored."
    }


    ; All this crap is from when I was using Luamacros
    ; Still needs to be transferred to callbacks

    /*
    ; Mode specific hotkeys
    If (Mode == "General") { ; === --===== ----======= ------========= --------=========== ----------=============
        If (WinActive("IntelliJ")) {
            If (input == "num1") {
                SendInput, !f
                SendInput, {down}
                SendInput, {right}
                SendInput, {down 9}
            } Else If (input == "c") {
                SendInput, ^+u
            }
        } Else If (input == "h") {
            OBS.CheckOBSRecordingStatus()
        } Else If (input == "alt+l") { ; Face scene change screenshotter
            OBS.SceneControlSend("j")
            ControlFocus, Qt5QWindowIcon5, obs64.exe
            SendInput, +{F10}
            Sleep, 50
            SendInput, {Up 5}
            SendInput, {Right}
            SendInput, {Enter}
            Sleep, 50
            SendInput, !{PrintScreen}
        } Else If (input == "control+shift+space") {
            activeWindow := WinExist("a")
            WinMove, ahk_id %activeWindow%,, 0, 0, 1920, 1055
        } Else If (input == "shift+t") {
            SendInput, ✔
        } Else If (input == "control+up") { ; --
        } Else If (input == "apostrophe") {
            SendInput, 2147483647
        } Else If (input == "shift+y") {
            ResetVolumeMixer(35) ; Sets all sliders in the volume mixer to the same as the master volume
        } Else If (input == "num1") {
        } Else If (input == "num2") {
        } Else If (input == "num3") {
        } Else If (input == "num4") {
        } Else If (input == "num5") {
        } Else If (input == "up") {            ; OBS Scene up
        } Else If (input == "down") {          ; OBS Scene down
        } Else If (input == "numDiv") {        ; OBS Transition
        } Else If (input == "numMult") {       ; OBS Alt Transition
        } Else If (input == "num0") {          ; OBS Toggle Webcam
        } Else If (input == "numDelete") {     ; OBS Toggle Mic
        } Else If (input == "i") {             ; Size windows according to current layout - logic in ".\Initialization\Spotify.ahk\OBS.SizeComponents()"
        } Else If (input == "leftbracket") {
        } Else If (input == "rightbracket") {
        } Else If (input == "backslash") {
        } Else If (input == "p")
        Else If (input == "pageup") {
        } Else If (input == "pagedown") {
        } Else If (input == "end") {
        }
    } Else If (Mode == "Minecraft") { ; === --===== ----======= --MINECRAFT --========= --------=========== ----------=============
        #Include, Keybinds/Minecraft.ahk
    } Else If (Mode == "Editing") { ; === --===== ----======= --EDITING --========= --------=========== ----------=============
        If (WinActive("VEGAS")) {
            If (input == "enter") {
                SendInput, s{Numpad7 2}{Delete}^+f ; Split, select clip preceeding cursor, delete it, then ripple all
            }
        }
    } Else If (Mode == "Animating") { ; === --===== ----======= --ANIMATING --========= --------=========== ----------=============
        If (input = "t") {
            AddTextEvent(, "Base")
        } Else If (input = "shift+t") {
            ShowSubtitleGui()
        } Else If (input = "p") {
            If (running) {
                SetTimer, KeyframeLoop, Delete
                running = 0
            } Else {
                SetTimer, KeyframeLoop, 25
                running = 1
            }
        } Else If (input == "a") {
            Vegas_ToggleShake()
        }
    }
    */
}

nothing() {
}

; Sounds provider
Class Sounds {
    Class SFX {
        PopulateSounds() {
            Loop, Files, SoundEffects\*, F
            {
                fileName := StrSplit(A_LoopFileName, .)[1]
                ; FileRead, fileData, %A_LoopFileName%
                ; fileDataTwo := fileData
                ; Msgbox, % A_LoopFileName . "`n`n" . &fileData . "`n`n" . &fileDataTwo
                ; this[fileName] := fileData
                this[filename] := "SoundEffects\" . A_LoopFileName
            }
        }
    }

    PopulateSounds() {
        Loop, Files, Sounds\*.mp3, F
        {
            filename := StrSplit(A_LoopFileName, .)[1]
            ; FileRead, fileData, filename
            ; this[filename] := fileData
            this[filename] := "Sounds\" . A_LoopFileName
        }
    }
}

; Modifier hotkey handling
Class Modifiers {
    Static ActiveModifiers := {}

    Get() {
        output := ""
        For Key, Val in Modifiers.ActiveModifiers {
            If (Val) {
                output := output . Key . " "
            }
        }
        Return Trim(output)
    }

    HandleState(pressed, key) {
        If (pressed == 1) {
            If (!Modifiers.ActiveModifiers[key]) {
                Modifiers.ActiveModifiers[key] := True
                ; ToolTip, ▼ %key%
            }
        } Else {
            Modifiers.ActiveModifiers[key] := False
            ; ToolTip, ▲ %key%
        }
    }
}

ToggleMainHotkeys() {
    If (mainKeyboardHotkeys) {
        mainKeyboardHotkeys := False
        Menu, Tray, Uncheck, %tray_mainHotkeysName%
        SoundPlay, % sounds.disconnected
    } Else {
        mainKeyboardHotkeys := True
        Menu, Tray, Check, %tray_mainHotkeysName%
        SoundPlay, % Sounds.connected
    }
}

ToggleDebug() {
    If (debug) {
        Global debug = False    ; Disable
        Menu, Tray, Uncheck, Debug Mode
        SoundPlay, % sounds.disconnected
    } Else {
        Global debug = True     ; Enable
        Menu, Tray, Check, Debug Mode
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
            Msgbox, % Format("The following list of keys will not trigger because they already have a callback inside of Global.`n`n`nMode: {}{}", val, listOfRedundantCallbacks)
    }
}

PlayPreloadedSound(ByRef Sound) {
    Msgbox, % &Sound
    Return DLLCall("winmm.dll\sndPlaySoundA", UInt, &Sound, UInt, ((SND_MEMORY:=0x4) | (SND_NODEFAULT:=0x2)))
}


; Mode change handling
Class ModeHandler
{
    Static ModeList
    Static ModeIndex
    Static CurrentMode

    Cycle() {
        ModeHandler.Mode := "Cycle"
    }

    Mode {
        get {
            Return ModeHandler.CurrentMode
        }

        ; TODO: This seriously needs optimising. Like really. I just made it "work" when I changed from a monolithic system.
        set {
            DebugMessage("Requested Mode: " . value)

            If ((value is integer) && (value > 0)) { ; If value is an integer that is above 0: set CurrentMode to that CurrentMode out of the list
                this.ModeIndex := value
                this.CurrentMode := this.ModeList[this.ModeIndex]
                SoundPlay, % Sounds[this.CurrentMode], Wait
            } Else { ; Otherwise just cycle it through
                If (this.CurrentMode == "") { ; Failsafe for in case CurrentMode isn't set yet
                    this.ModeIndex := 1
                    this.CurrentMode := this.ModeList[this.ModeIndex]
                } Else {
                    If (this.ModeIndex >= this.ModeList.MaxIndex()) { ; If at the end of the list of modes, go back to the start
                        this.ModeIndex := 1
                        this.CurrentMode := this.ModeList[this.ModeIndex]
                    } Else { ; Otherwise cycle by one
                        this.ModeIndex++
                        this.CurrentMode := this.ModeList[this.ModeIndex]
                    }
                }
                SoundPlay, % Sounds[this.CurrentMode]
            }
        }
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
        MsgBox, 1, Reset Volume Mixer?, This will reset all sliders in the volume mixer to the system volume: %systemVolume%
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
    If (debug) {
        Msgbox, % inMsg
    }
}

; Traytip variation of above
DebugTrayTip(inMSG := "") {
    If (debug) {
        TrayTip, % "Debugging", %inMSG%
    }
}

; -- This automatically toggles a timer for the name provided.
; -- The name must be a function or label NAME. Aka without the ().
; -- Returns 1 upon timer started and 0 for timer stopped
; --- TODO: Could possibly use Func() objects for this instead.
ToggleTimer(timerName, endExec := "") {
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

; -- Autoclicker macro for use with 'settimer'
AutoClicker() {
    Click, Right
}

AutoFishing() {
    FishDetected := False
    IfWinActive, Minecraft
    {
        WinGet, mcInstances, List, Minecraft
        Loop %mcInstances% {
            mcInstanceID := mcInstances%A_Index%

            ; WinActivate, ahk_id %mcInstanceID%

            WinGetPos, X, Y, Width, Height, ahk_id %mcInstanceID%
            X1 := Width / 2 - 50 + X
            Y1 := Height / 2 - 10 + Y
            X2 := Width / 2 + 50 + X
            Y2 := Height / 2 + 60 + Y

            ; ToolTip, ., % X1, % Y1
            ; Sleep, 50
            ; ToolTip, ., % X2, % Y2
            ; ToolTip, % Format("{}`n{}`n{}`n{}`n`n{}`n{}`n{}`n{}", X, Y, Width, Height, X1, Y1, X2, Y2), 500, 500

            ; 50F6FC
            PixelSearch, OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, FF0000, 1, Fast
            ; 51F9FF
            If (ErrorLevel == 1) {
                ; SoundPlay, % Sounds.Disconnected, wait
                ControlClick,, ahk_id %mcInstanceID%,, Right
                ; Random, rand, 50, 150
                Sleep, %rand%
                ControlClick,, ahk_id %mcInstanceID%,, Right
                FishDetected := True
            } Else If (ErrorLevel == 2) {
                SoundPlay, Sounds.Asterisk, wait
            }
        }
        If (FishDetected)
            Sleep, 100
        ; Sleep, 50
    } Else {
        ToggleTimer("AutoFishing")
    }
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