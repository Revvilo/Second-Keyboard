Class General {

    ; List of keys that will be considered Modifiers instead of hotkeys along with their respective aliases to use when checking for said Modifiers.
    ; For example: { "RAlt": "Alt" } - this means if 'RAlt' is pressed, it is sent as 'Alt' when passed into a callback, so you'd then check for (Modifiers.IsPressed("Alt"))
    ; Of course any name can be used as the second string for you to identify later. The first string must be the key that will be pressed as a modifier.
    ; Same rules as callbacks apply for mode specificity!
    Static modifierKeys := {  "LControl":   "Control"
                            , "RControl":   "Control"
                            , "LShift":     "Shift"
                            , "RShift":     "Shift"
                            , "LAlt":       "Alt"
                            , "RAlt":       "Alt"
                            , "NumpadSub":  "NumpadSub"
                            , "LWin":       "WinKey"
                            , "RWin":       "WinKey" }

    Up(Modifiers) {
        If (Modifiers.IsPressed()) {
            OBS.SceneControlSend("{UP}")
        } Else If (Modifiers.IsPressed("Control")) {
            ToggleFakeFullscreen()
        }
    }
    Down() {
        OBS.SceneControlSend("{DOWN}")
    }
    Apostrophe(Modifiers) {
        If (Modifiers.IsPressed()) {
            IfWinExist, Firefox
            {
                WinRestore, Firefox
                WinMaximize, Firefox
                ; WinActivate, Firefox
            } Else {
                Run, Firefox.exe
            }
        } Else If (Modifiers.IsPressed("Alt")) {
            WinClose, Firefox
        }
    }
    ; Semicolon() {
    ; }
    ; Comma() {
    ; }
    ; Dot() {
    ; }
    ; PgUp() {
        ; OBS.Transition()
    ; }
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
        If (Modifiers.IsPressed("NumpadSub")) {
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
        If (Modifiers.IsPressed("NumpadSub")) {
            OBS.SetProfile("Stream")
            Return
        } Else {
            Discord.ToggleDeafen()
        }
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
        If (Modifiers.IsPressed("NumpadSub"))
            OBS.ToggleCamera()
        Else If (Modifiers.IsPressed())
            OBS.MuteUnmuteMic()
    }
    NumpadEnter(Modifiers) {
        If (Modifiers.IsPressed("NumpadSub")) {
            OBS.SetProfile("1080p60 Recording")
            Return
        } Else {
            Discord.ToggleMute()
        }
    }
    Numlock() { 
        OBS.ToggleStudioMode()
    }
    ; Pause() { ; This doesn't work - Both numlock and scrolllock have the same keycode(?), god knows why.
    ; }

    ; ---------------- ;
    ; -- SOUNDBOARD -- ;

    F1(Modifiers) {
        If (Modifiers.IsPressed("Ctrl")) {
            Soundboard.PopulateSounds()
        } Else {
            Soundboard.Stop()
        }
    }
    F2(Modifiers) {
        Soundboard.Play()
    }
    F3(Modifiers) {
        Soundboard.ShowSettings()
    }
    F4(Modifiers) {
    }
    
    F5(Modifiers) {
        Soundboard.SetProfile(1)
    }
    F6(Modifiers) {
        Soundboard.SetProfile(2)
    }
    F7(Modifiers) {
        Soundboard.SetProfile(3)
    }
    F8(Modifiers) {
        Soundboard.SetProfile(4)
    }

    1(Modifiers) {
        Soundboard.PlaySlot(1)
    }
    2(Modifiers) {
        Soundboard.PlaySlot(2)
    }
    3(Modifiers) {
        Soundboard.PlaySlot(3)
    }
    4(Modifiers) {
        Soundboard.PlaySlot(4)
    }
    5(Modifiers) {
        Soundboard.PlaySlot(5)
    }
    6(Modifiers) {
        Soundboard.PlaySlot(6)
    }
    7(Modifiers) {
        Soundboard.PlaySlot(7)
    }
    8(Modifiers) {
        Soundboard.PlaySlot(8)
    }
    9(Modifiers) {
        Soundboard.PlaySlot(9)
    }
    0(Modifiers) {
    }

    ; A(Modifiers) {
    ; }
    ; B(Modifiers) {
    ; }
    ; P(Modifiers) {
    ; }
    ; R(Modifiers) {
    ; }
    C(Modifiers) {
        If (Modifiers.IsPressed("Control", "Alt")) { ; -- Autoclicker - Ctrl Alt C
            ToggleTimer("AutoClicker")
        }
    }
    ; E(Modifiers) {
    ; }
    M(Modifiers) {
        If (Modifiers.IsPressed("Alt", "Control")) { ; -- Copy Mouse Position - Ctrl Alt M
            MouseGetPos, OutputVarX, OutputVarY
            Clipboard := OutputVarX . ", " . OutputVarY
            SoundPlay, % Sounds.connected
        }
    }
    S(Modifiers) {
        If (Modifiers.IsPressed("Shift")) {
            Misc.SpaceOutLetters()
        } Else If (Modifiers.IsPressed("Alt")) {
            Misc.SmallLetters()
        } Else If (Modifiers.IsPressed("Winkey")) {
            Run, D:\Games\Minecraft\Servers
        } Else If (Modifiers.IsPressed()) {
            Spotify.ToggleVol()
        }
    }
    T(Modifiers) {
        If (Modifiers.IsPressed())
            Spotify.ToggleVisibility()
        Else If (Modifiers.IsPressed("Shift")) {
            SendInput, {U+2713} ; -- ✓ Check mark
        } Else If (Modifiers.IsPressed("Control", "Shift")) {
            SendInput, {U+2714} ; -- ✔ Heavy check mark
        }
    }

    Y() {
        ResetVolumeMixer()
    }

}