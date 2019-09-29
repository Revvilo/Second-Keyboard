Class Global {

    ; List of keys that will be considered modifiers instead of hotkeys along with their respective aliases to use when checking for said modifiers.
    ; For example: { "RAlt": "Alt" } - this means if 'RAlt' is pressed, it is sent as 'Alt' when passed into a callback, so you'd then check for (modifiers == "Alt")
    ; Of course any name can be used as the second string for you to identify later. The first string must be the key that will be pressed as a modifier.
    Static modifierKeys := {  "LControl":   "Control"
                            , "RControl":   "Control"
                            , "LShift":     "Shift"
                            , "RShift":     "Shift"
                            , "LAlt":       "Alt"
                            , "RAlt":       "Alt"
                            , "NumpadSub":  "NumpadSub"
                            , "LWin":       "WinKey"
                            , "RWin":       "WinKey" }

    ; == GLOBAL BINDS ==

    ; FOR THIS SPECIFIC DEVICE, ANY BINDS (Which are callback functions) THAT ARE ADDED IN HERE WILL ALWAYS BE EXECUTED INSTEAD OF THEIR MODE-DEPENDANT COUNTERPARTS.
    ; This means if you declare a callback for 'enter' in here, it doesn't matter which mode you're using, or which modes contain a callback declaration for 'enter', the one in here will always be used.
    ; You will see that currently unused callbacks are commented out to leave them open for mode-dependant hotkeys -
    ; because it doesn't matter if the callback is empty, it will still override any mode hotkeys.

    ; ==================


    ;v ==================================================== v;
    ;v == CRITICAL HOTKEYS ================================ v;
    ;v == These only need to exist once, in global ======== v;
    ;v == They allow you to have control over the script == v;
    ;v ==================================================== v;

    Escape() {
        ExitApp
    }
    Tilde() { ; -- Reload Key
        Reload
    }
    ; Mode change
    Tab(modifiers) {
        If (modifiers == "Control")  { ; Reset mode - Ctrl Tab
            ModeHandler.Mode := 1
        } Else If (modifiers == "") { ; Cycle mode - Tab
            ModeHandler.Cycle()
        }
    }

    ;v ================== v;
    ;v == USER HOTKEYS == v;
    ;v ================== v;

    ; ------------------------ ;
    ; -- MODIFIER CALLBACKS -- ;

    ; WinKey_Shift is to handle winkey+shift keypress while still using main WinKey func
    Shift_WinKey(Key) {
        This.WinKey(Key, ShiftHeld := true)
    }
    WinKey(Key, ShiftHeld := false) {
        If (Key == "p") {
            Misc.ExploreTo("F:\Dev", ShiftHeld)
        } Else If (Key == "v") {
            Misc.ExploreTo("F:\Video", ShiftHeld)
        } Else If (Key == "r") {
            Misc.ExploreTo("F:\Source", ShiftHeld)
        } Else If (Key == "m") {
            Misc.ExploreTo("F:\Games\Minecraft", ShiftHeld)
        }
    }

    ; --------------- ;
    ; -- MISC KEYS -- ;

    F1(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F13}
    }
    F2(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F14}
    }
    F3(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F15}
    }
    F4(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F16}
    }
    F5(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F17}
    }
    F6(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F18}
    }
    F7(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F19}
    }
    F8(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F20}
    }
    F9(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F21}
    }
    F10(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F22}
    }
    F11(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F23}
    }
    F12(Modifiers) {
        If (Modifiers == "Alt")
            SendInput, {F24}
    }

    Left() {
        SendInput, ^#{left} ; -- Virtual desktop left
    }
    Right() {
        SendInput, ^#{right} ; -- Virutal desktop right
    }
    Up(modifiers) {
        If (modifiers == "") {
            OBS.SceneControlSend("{UP}")
        } Else If (modifiers == "Control") {
            ToggleFakeFullscreen()
        }
    }
    Down() {
        OBS.SceneControlSend("{DOWN}")
    }

    Equals() {
        ToggleTimer("AutoFishing")
    }


    Space() { ; -- Play/pause
        ; ControlSend,, {Media_Play_Pause}, Spotify
        ; SendInput, {Media_Play_Pause}
        If (WinExist("ahk_exe Spotify.exe")) {
            Spotify.PlayPause()
        } Else {
            BrowserControl.YoutubeMusic.PlayPause()
        }
    }
    ; Enter() {
    ; }
    RightBracket() {
    }
    LeftBracket() {
    }
    BackSlash() {
    }
    ForwardSlash() {
        BrowserControl.Fullscreen()
    }
    ; LWin() {
    ; }
    ; RWin() {
    ; }
    AppsKey() {
        BrowserControl.PlayPause()
    }
    Apostrophe(Modifiers) {
        If (Modifiers == "") {
            IfWinExist, Firefox
            {
                WinRestore, Firefox
                WinMaximize, Firefox
                ; WinActivate, Firefox
            } Else {
                Run, Firefox.exe
            }
        } Else If (Modifiers == "Alt") {
            WinClose, Firefox
        }
    }
    ; Semicolon() {
    ; }
    ; Comma() {
    ; }
    Dot() {
        Run, "C:\Program Files (x86)\VB\Voicemeeter\voicemeeterpro.exe" -R
    }
    PgUp() {
        ; OBS.Transition()
    }
    PgDn() {
        OBS.Transition()
    }
    End() {
        OBS.SaveReplayBuffer()
    }
    Home() {
        ; OBS.SendToOBS("{F24}") ; Toggle capture foreground window.
    }
    Insert() {
        OBS.ToggleStreaming()
        SoundPlay, % Sounds.connected
    }
    Delete() {
        OBS.ToggleRecording()
        ; OBS.SendToOBS("{F22}")    ; Toggle Recording
    }


    ; --------------------- ;
    ; -- NUMPAD CONTROLS -- ;

    NumpadIns() { ; -- Numpad0
        OBS.MuteUnmuteMic()
    }
    NumpadEnd(modifiers) { ; -- Numpad1
        OBS.SelectScene("Game")
        OBS.AutoTransition(modifiers)
    }
    NumpadDown(modifiers) { ; -- Numpad2
        OBS.SelectScene("Stand By")
        OBS.AutoTransition(modifiers)
    }
    NumpadPgDn(modifiers) { ; -- Numpad3
        OBS.SelectScene("Desktop")
        OBS.AutoTransition(modifiers)
    }
    NumpadLeft(modifiers) { ; -- Numpad4
        OBS.SelectScene("Fullscreen Cam")
        OBS.AutoTransition(modifiers)
    }
    NumpadClear(modifiers) { ; -- Numpad5
        OBS.SelectScene("Big sad")
        OBS.AutoTransition(modifiers)
    }
    NumpadRight(modifiers) { ; -- Numpad6
        OBS.SelectScene("Zoom Cam 2")
        OBS.AutoTransition(modifiers)
    }
    NumpadHome(modifiers) { ; -- Numpad7
        OBS.SelectScene("Flipped Cam")
        OBS.AutoTransition(modifiers)
    }
    NumpadUp(modifiers) { ; -- Numpad8
        OBS.SelectScene("Zoom Flipped Cam 1")
        OBS.AutoTransition(modifiers)
    }
    NumpadPgUp(modifiers) { ; -- Numpad9
        OBS.SelectScene("Zoom Flipped Cam 2")
        OBS.AutoTransition(modifiers)
    }

    NumpadAdd() {
        SendInput, !{F19} ; -- Toggle Discord deafen
    }
    NumpadDiv() {
        OBS.Transition(1)
    }
    NumpadMult() {
        OBS.Transition(2)
    }
    ; NumpadSub() {
    ; }
    NumpadDel(Modifiers) {
        If (Modifiers == "NumpadSub")
            OBS.ShowHideWebcam()
        Else If (Modifiers == "")
            OBS.MuteUnmuteSystem()
    }
    NumpadEnter() {
        SendInput, !{F20} ; -- Toggle Discord mic
    }
    Numlock() { ; This doesn't work - Both numlock and scrolllock have the same keycode(?), god knows why.
        This.Pause()
    }
    Pause() {
        OBS.ToggleStudioMode()
        ; WinGet, obslist, ControlList, ahk_exe obs64.exe
        ; Msgbox, %obslist%
        ; Loop, Parse, obslist, "`n"
        ; {
        ;     ; msgbox, %A_LoopField%
        ;     ControlSend, %A_LoopField%, {F17}, ahk_exe obs64.exe

        ; }
        ; SendInput, {F17}
    }


    ; ------------- ;
    ; -- NUMBERS -- ;

    1(Modifiers) {
        PlayPreloadedSound(Sounds.SFX["applause"])
        ; SoundPlay, % Sounds.SFX.applause
    }
    2(Modifiers) {
        SoundPlay, % Sounds.SFX["Badum Tss"]
    }
    3(Modifiers) {
        SoundPlay, % Sounds.SFX["357 Magnum Gun Shot Fire"]
    }
    4(Modifiers) {
        SoundPlay, % Sounds.SFX.fart
    }
    5(Modifiers) {
        SoundPlay, % Sounds.SFX["Crab Rave"]
    }
    6(Modifiers) {
        SoundPlay, % Sounds.SFX["Song - Ocean Man"]
    }
    7(Modifiers) {
    }
    8(Modifiers) {
    }
    9(Modifiers) {
    }
    0(Modifiers) {
    }


    ; ------------- ;
    ; -- LETTERS -- ;

    A(modifiers) {
        If (WinExist("ahk_exe Spotif.exe")) {
            If (modifiers == "") { ; -- Spotify vol decrease
                Spotify.VolChange(-1, "change")
            } Else If (modifiers == "Shift") { ; -- Spotify vol -5
                Spotify.VolChange(-5, "change")
            } Else If (modifiers == "Control") { ; -- Spotify quiet vol
                Spotify.VolChange(Spotify.volQuiet, "set")
            }
        } Else {
            If (modifiers == "") { ; -- vol increase
                MixerControl.ChangeVolume("Mozilla Firefox", -1, "change")
            } Else If (modifiers == "Alt") {
                BrowserControl.YoutubeMusic.VolDown()
            } Else If (modifiers == "Shift") { ; -- vol +5
                MixerControl.ChangeVolume("Mozilla Firefox", -5, "change")
            } Else If (modifiers == "Control") { ; -- set to loud vol
                MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.volQuiet, "set")
            }
        }
    }
    B() {
    }
    C(modifiers) {
        If (modifiers == "Alt") { ; -- Autoclicker - Ctrl Alt C
            ToggleTimer("AutoClicker")
        }
    }
    D() {
    }
    E(modifiers) {
        If (modifiers == "WinKey") { ; -- Open editing folder
            Run, F:\Video\Editing
        }
    }
    F() {
        TestChars := "!()0123456789?ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        TestChars := StrSplit(TestChars)
        For i, v in TestChars
        {
            SendInput, % Asc(v) . "{enter}"
        }
    }
    G() {
    }
    H() {
    }
    I() {
    }
    J() {
    }
    K() {
    }
    L() {
    }
    M(modifiers) {
        If (modifiers == "Alt Control") { ; -- Copy Mouse Position - Ctrl Alt M
            MouseGetPos, OutputVarX, OutputVarY
            Clipboard := OutputVarX . ", " . OutputVarY
            SoundPlay, % Sounds.connected
        }
    }
    N() {
    }
    O() {
    }
    P() {
    }
    Q(modifiers) {
        If (WinExist("ahk_exe Spotify.exe")) {
            If (modifiers == "") { ; -- Spotify vol increase
                Spotify.VolChange(1, "change") 
            } Else If (modifiers == "Shift") { ; -- Spotify vol +5
                Spotify.VolChange(5, "change")
            } Else If (modifiers == "Control") { ; -- Spotify loud vol
                Spotify.VolChange(Spotify.volLoud, "set")
            } Else If (modifiers == "Control Shift") {
                Spotify.VolChange(Spotify.systemVol, "set")
            }
        } Else {
            If (modifiers == "") { ; -- vol increase
                MixerControl.ChangeVolume("Mozilla Firefox", 1, "change")
            } Else If (modifiers == "Alt") {
                BrowserControl.YoutubeMusic.VolUp()
            } Else If (modifiers == "Shift") { ; -- vol +5
                MixerControl.ChangeVolume("Mozilla Firefox", 5, "change")
            } Else If (modifiers == "Control") { ; -- set to loud vol
                MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.volLoud, "set")
            } Else If (modifiers == "Control Shift") {
                MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.systemVol, "set")
            }
        }
    }
    R() {
    }
    S(modifiers) {
        If (modifiers == "Shift") {
            Misc.SpaceOutLetters()
        } Else If (modifiers == "Alt") {
            Misc.SmallLetters()
        }
    }
    T(modifiers) {
        If (modifiers == "")
            Spotify.ToggleVisibility()
        Else If (modifiers == "Shift") {
            SendInput, {U+2713} ; -- ✓ Check mark
        } Else If (modifiers == "Control Shift") {
            SendInput, {U+2714} ; -- ✔ Heavy check mark
        }
    }
    U() {
    }
    V(modifiers) {
        If (modifiers == "WinKey") { ; -- Open video folder
            If (WinActive("ahk_exe explorer.exe ahk_class CabinetWClass"))
                SendInput, ^lF:\Video{enter}
            Else
                Run, F:\Video
        } Else If (modifiers == "Shift WinKey") {
            Run, F:\Video
        }
    }
    W() {
    }
    X(modifiers) {
        If (modifiers == "") {
            SendInput, {Media_Next} ; Next Song
        } Else If (modifiers == "Alt") {
            Minecraft.MouseMove(2100, 350)
        }
    }
    Y() {
        ResetVolumeMixer()
    }
    Z(modifiers) {
        If (modifiers == "") {
            SendInput, {Media_Prev} ; Prev song
        } Else If (modifiers == "Alt") {
            Minecraft.MouseMove(-2100, -350)
        }
    }
}