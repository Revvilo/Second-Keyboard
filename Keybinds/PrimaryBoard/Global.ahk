Class Global {

    ; List of keys that will be considered Modifiers instead of hotkeys along with their respective aliases to use when checking for said Modifiers.
    ; For example: { "RAlt": "Alt" } - this means if 'RAlt' is pressed, it is sent as 'Alt' when passed into a callback, so you'd then check for (Modifiers == "Alt")
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
    Tab(Modifiers) {
        If (Modifiers == "Control")  { ; Reset mode - Ctrl Tab
            ModeHandler.Mode := 1
        } Else If (Modifiers == "") { ; Cycle mode - Tab
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
    Up(Modifiers) {
        If (Modifiers == "") {
            OBS.SceneControlSend("{UP}")
        } Else If (Modifiers == "Control") {
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

    NumpadIns(Modifiers) { ; -- Numpad0
        If (Modifiers == "NumpadSub") {
            OBS.FlipCamera()
        } Else {
            OBS.MuteUnmuteSystem()
        }
    }
    NumpadEnd(Modifiers) { ; -- Numpad1
        OBS.SelectScene("Game")
        OBS.AutoTransition(Modifiers)
    }
    NumpadDown(Modifiers) { ; -- Numpad2
        OBS.SelectScene("Stand By")
        OBS.AutoTransition(Modifiers)
    }
    NumpadPgDn(Modifiers) { ; -- Numpad3
        OBS.SelectScene("Desktop")
        OBS.AutoTransition(Modifiers)
    }
    NumpadLeft(Modifiers) { ; -- Numpad4
        OBS.SelectScene("Fullscreen Cam")
        OBS.AutoTransition(Modifiers)
    }
    NumpadClear(Modifiers) { ; -- Numpad5
        OBS.SelectScene("Zoom Cam 1")
        OBS.AutoTransition(Modifiers)
    }
    NumpadRight(Modifiers) { ; -- Numpad6
        OBS.SelectScene("Zoom Cam 2")
        OBS.AutoTransition(Modifiers)
    }
    NumpadHome(Modifiers) { ; -- Numpad7
        OBS.SelectScene("Big sad")
        OBS.AutoTransition(Modifiers)
    }
    NumpadUp(Modifiers) { ; -- Numpad8
        OBS.SelectScene("Zoom Flipped Cam 1")
        OBS.AutoTransition(Modifiers)
    }
    NumpadPgUp(Modifiers) { ; -- Numpad9
        OBS.SelectScene("Zoom Flipped Cam 2")
        OBS.AutoTransition(Modifiers)
    }

    NumpadAdd(Modifiers) {
        If (Modifiers == "NumpadSub") {
            OBS.SetProfile("Stream")
            Return
        }
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
            OBS.ToggleCamera()
        Else If (Modifiers == "")
            OBS.MuteUnmuteMic()
    }
    NumpadEnter(Modifiers) {
        If (Modifiers == "NumpadSub") {
            OBS.SetProfile("1080p60 Recording")
            Return
        }
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
        Sounds.PlaySoundEffect("Badum Tss")
        ; Sounds.PlaySoundEffect("Badum Tss")
    }
    3(Modifiers) {
        Sounds.PlaySoundEffect("357 Magnum Gun Shot Fire")
    }
    4(Modifiers) {
        Sounds.PlaySoundEffect("fart")
        ; SoundPlay, % Sounds.SFX.fart
    }
    5(Modifiers) {
        Sounds.PlaySoundEffect("Crab Rave")
    }
    6(Modifiers) {
        Sounds.PlaySoundEffect("Song - Ocean Man")
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

    A(Modifiers) {
        If (WinExist("ahk_exe Spotify.exe")) {
            If (Modifiers == "") { ; -- Spotify vol decrease
                Spotify.VolChange(-1, "change")
            } Else If (Modifiers == "Shift") { ; -- Spotify vol -5
                Spotify.VolChange(-5, "change")
            } Else If (Modifiers == "Control") { ; -- Spotify quiet vol
                Spotify.VolChange(Spotify.volQuiet, "set")
            }
        } Else {
            If (Modifiers == "") { ; -- vol increase
                MixerControl.ChangeVolume("Mozilla Firefox", -1, "change")
            } Else If (Modifiers == "Alt") {
                BrowserControl.YoutubeMusic.VolDown()
            } Else If (Modifiers == "Shift") { ; -- vol +5
                MixerControl.ChangeVolume("Mozilla Firefox", -5, "change")
            } Else If (Modifiers == "Control") { ; -- set to loud vol
                MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.volQuiet, "set")
            }
        }
    }
    B() {
    }
    C(Modifiers) {
        If (Modifiers == "Alt") { ; -- Autoclicker - Ctrl Alt C
            ToggleTimer("AutoClicker")
        }
    }
    D() {
    }
    E(Modifiers) {
        If (Modifiers == "WinKey") { ; -- Open editing folder
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
    M(Modifiers) {
        If (Modifiers == "Alt Control") { ; -- Copy Mouse Position - Ctrl Alt M
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
    Q(Modifiers) {
        If (WinExist("ahk_exe Spotify.exe")) {
            If (Modifiers == "") { ; -- Spotify vol increase
                Spotify.VolChange(1, "change") 
            } Else If (Modifiers == "Shift") { ; -- Spotify vol +5
                Spotify.VolChange(5, "change")
            } Else If (Modifiers == "Control") { ; -- Spotify loud vol
                Spotify.VolChange(Spotify.volLoud, "set")
            } Else If (Modifiers == "Control Shift") {
                Spotify.VolChange(Spotify.systemVol, "set")
            }
        } Else {
            If (Modifiers == "") { ; -- vol increase
                MixerControl.ChangeVolume("Mozilla Firefox", 1, "change")
            } Else If (Modifiers == "Alt") {
                BrowserControl.YoutubeMusic.VolUp()
            } Else If (Modifiers == "Shift") { ; -- vol +5
                MixerControl.ChangeVolume("Mozilla Firefox", 5, "change")
            } Else If (Modifiers == "Control") { ; -- set to loud vol
                MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.volLoud, "set")
            } Else If (Modifiers == "Control Shift") {
                MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.systemVol, "set")
            }
        }
    }
    R() {
    }
    S(Modifiers) {
        If (Modifiers == "Shift") {
            Misc.SpaceOutLetters()
        } Else If (Modifiers == "Alt") {
            Misc.SmallLetters()
        }
    }
    T(Modifiers) {
        If (Modifiers == "")
            Spotify.ToggleVisibility()
        Else If (Modifiers == "Shift") {
            SendInput, {U+2713} ; -- ✓ Check mark
        } Else If (Modifiers == "Control Shift") {
            SendInput, {U+2714} ; -- ✔ Heavy check mark
        }
    }
    U() {
    }
    V(Modifiers) {
        If (Modifiers == "WinKey") { ; -- Open video folder
            If (WinActive("ahk_exe explorer.exe ahk_class CabinetWClass"))
                SendInput, ^lF:\Video{enter}
            Else
                Run, F:\Video
        } Else If (Modifiers == "Shift WinKey") {
            Run, F:\Video
        }
    }
    W() {
    }
    X(Modifiers) {
        If (Modifiers == "") {
            SendInput, {Media_Next} ; Next Song
        } Else If (Modifiers == "Alt") {
            Minecraft.MouseMove(2100, 350)
        }
    }
    Y() {
        ResetVolumeMixer()
    }
    Z(Modifiers) {
        If (Modifiers == "") {
            SendInput, {Media_Prev} ; Prev song
        } Else If (Modifiers == "Alt") {
            Minecraft.MouseMove(-2100, -350)
        }
    }
}