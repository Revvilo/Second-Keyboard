Class Global {

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

    ; == GLOBAL BINDS ==

    ; FOR THIS SPECIFIC DEVICE, ANY BINDS (Which are callback functions) THAT ARE ADDED IN HERE WILL ALWAYS BE EXECUTED INSTEAD OF THEIR MODE-DEPENDANT COUNTERPARTS.
    ; This means if you declare a callback for 'enter' in here, it doesn't matter which mode you're using, or which modes contain a callback declaration for 'enter', the one in here will always be used.
    ; You will see that currently unused callbacks are commented out to leave them open for mode-dependant hotkeys -
    ; because it doesn't matter if the callback is empty, it will still override any mode hotkeys.

    ; ==================


    ;v ================================================================================ v;
    ;v == CRITICAL HOTKEYS ============================================================ v;
    ;v == These only need to exist once, in global, for this respective device ======== v;
    ;v == They allow you to have control over the script ============================== v;
    ;v ================================================================================ v;

    Escape() {
        ExitApp
    }
    Tilde() { ; -- Reload Key
        Reload
    }
    ; Mode change
    Tab(Modifiers) {
        If (Modifiers.IsPressed("Control"))  { ; Reset mode - Ctrl Tab
            ModeHandler.Mode := 1
        } Else If (Modifiers.IsPressed()) { ; Cycle mode - Tab
            ModeHandler.Cycle()
        }
    }

    ;v ================== v;
    ;v == USER HOTKEYS == v;
    ;v ================== v;

    ; --------------- ;
    ; -- MISC KEYS -- ;

    ; F1(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F13}
    ; }
    ; F2(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F14}
    ; }
    ; F3(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F15}
    ; }
    ; F4(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F16}
    ; }
    ; F5(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F17}
    ; }
    ; F6(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F18}
    ; }
    ; F7(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F19}
    ; }
    ; F8(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F20}
    ; }
    ; F9(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F21}
    ; }
    ; F10(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F22}
    ; }
    ; F11(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F23}
    ; }
    ; F12(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt"))
    ;         SendInput, {F24}
    ; }

    Left() {
        SendInput, ^#{left} ; -- Virtual desktop left
    }
    Right() {
        SendInput, ^#{right} ; -- Virutal desktop right
    }
    ; Up(Modifiers) {
    ; }
    ; Down() {
    ; }

    ; Equals() {
    ; }
    Space(Modifiers) { ; -- Play/pause media
        ; ControlSend,, {Media_Play_Pause}, Spotify
        ; SendInput, {Media_Play_Pause}
        ; If (WinExist("ahk_exe Spotify.exe")) {
        If(Modifiers.IsPressed()) {
            Spotify.PlayPause()
        } Else If (Modifiers.IsPressed("Control")) {
            BrowserControl.PlayPause()
        }
        ; } Else {
            ; BrowserControl.YoutubeMusic.PlayPause()
        ; }
    }
    ; Enter() {
    ; }
    ; RightBracket() {
    ; }
    ; LeftBracket() {
    ; }
    ; BackSlash() {
    ; }
    ; ForwardSlash() {
    ; }
    ; LWin() {
    ; }
    ; RWin() {
    ; }
    AppsKey(Modifiers) { ; Browser play/pause | mute | fullscreen
        If (Modifiers.IsPressed()) {
            BrowserControl.PlayPause()
        } Else If (Modifiers.IsPressed("Control")) {
            BrowserControl.MuteUnmute()
        } Else If (Modifiers.IsPressed("WinKey")) {
            BrowserControl.Fullscreen()
        }
    }
    ; Apostrophe(Modifiers) {
    ; }
    ; Semicolon() {
    ; }
    ; Comma() {
    ; }
    Dot() {
        Run, "C:\Program Files (x86)\VB\Voicemeeter\voicemeeterpro.exe" -R
    }
    PgUp() {
        OBS.SkipAlert()
    }
    PgDn() {
        OBS.Transition()
    }
    End() {
        OBS.SaveReplayBuffer()
    }
    Home() {
        OBS.PauseResumeRecording()
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

    ; NumpadIns(Modifiers) { ; -- Numpad0
    ; }
    ; NumpadEnd(Modifiers) { ; -- Numpad1
    ; }
    ; NumpadDown(Modifiers) { ; -- Numpad2
    ; }
    ; NumpadPgDn(Modifiers) { ; -- Numpad3
    ; }
    ; NumpadLeft(Modifiers) { ; -- Numpad4
    ; }
    ; NumpadClear(Modifiers) { ; -- Numpad5
    ; }
    ; NumpadRight(Modifiers) { ; -- Numpad6
    ; }
    ; NumpadHome(Modifiers) { ; -- Numpad7
    ; }
    ; NumpadUp(Modifiers) { ; -- Numpad8
    ; }
    ; NumpadPgUp(Modifiers) { ; -- Numpad9
    ; }

    ; NumpadAdd(Modifiers) {
    ; }
    ; NumpadDiv() {
    ; }
    ; NumpadMult() {
    ; }
    ; NumpadSub() {
    ; }
    ; NumpadDel(Modifiers) {
    ; }
    ; NumpadEnter(Modifiers) {
    ; }
    ; Numlock() {
    ; }
    ; Pause() { ; This doesn't work - Both numlock and scrolllock have the same keycode(?), god knows why.
    ; }


    ; ------------- ;
    ; -- NUMBERS -- ;

    ; 1(Modifiers) {
    ; }
    ; 2(Modifiers) {
    ; }
    ; 3(Modifiers) {
    ; }
    ; 4(Modifiers) {
    ; }
    ; 5(Modifiers) {
    ; }
    ; 6(Modifiers) {
    ; }
    ; 7(Modifiers) {
    ; }
    ; 8(Modifiers) {
    ; }
    ; 9(Modifiers) {
    ; }
    ; 0(Modifiers) {
    ; }


    ; ------------- ;
    ; -- LETTERS -- ;

    A(Modifiers) {
        Fadetime := 150
        Strip := VoicemeeterRemote.strips["Spotify"]
        ; VoicemeeterRemote.ZeroStripEQ() ; Old revvilo why the fk did you put this here?
        If (Modifiers.IsPressed()) { ; -- Spotify vol decrease
            VoicemeeterRemote.ChangeStripGain(Strip, -1)

        } Else If (Modifiers.IsPressed("Shift")) { ; -- Spotify vol -5
            VoicemeeterRemote.ChangeStripGain(Strip, -5)

        } Else If (Modifiers.IsPressed("Control")) { ; -- Spotify quiet vol
            ; VoicemeeterRemote.SetStripEQ(Strip, -12, -12, 12)
            VoicemeeterRemote.FadeStripTo(Strip, -25, Fadetime)

        } Else If (Modifiers.IsPressed("Control", "Shift")) { ; -- Quiet 2
            ; VoicemeeterRemote.SetStripEQ(Strip, -12, -12, 12)
            VoicemeeterRemote.FadeStripTo(Strip, -35, Fadetime)

        } Else If (Modifiers.IsPressed("Alt")) {
            VoicemeeterRemote.SetStripEQ(Strip, -12, -12, 0)

        } Else If (Modifiers.IsPressed("Alt", "Control")) {
            VoicemeeterRemote.ZeroStripEQ(Strip)

        } Else If (Modifiers.IsPressed("Alt", "Control", "Shift")) {
            VoicemeeterRemote.FadeStripTo(Strip, -60, 15000)
            Sleep, 15000
            Spotify.PlayPause()
            VoicemeeterRemote.FadeStripTo(Strip, -10, 2000)
        }
    }
    ; B() {
    ; }
    ; C(Modifiers) {
    ; }
    D(Modifiers) {
        VoicemeeterRemote.StandardVolumeControl(Modifiers, VoicemeeterRemote.Strips["Browser"], 0)
    }
    E(Modifiers) {
        strip := VoicemeeterRemote.Strips["Browser"]

        VoicemeeterRemote.StandardVolumeControl(Modifiers, strip, 1)

        If (Modifiers.IsPressed("WinKey")) { ; -- Open editing folder
            Run, D:\Video\Editing
        } Else If (Modifiers.IsPressed("Alt")) { ; -- Toggle Voice Changer
            VoicemeeterRemote.ToggleStripOutput("3", "B3")
            VoicemeeterRemote.ToggleStripOutput("4", "B3")
        
        } Else If (Modifiers.IsPressed("Control", "Shift", "Alt")) {
            VoicemeeterRemote.ToggleStripOutput(strip, "A2")
            VoicemeeterRemote.ToggleStripOutput(strip, "A1")
        }
    }
    F(Modifiers) {
        If (Modifiers.IsPressed()) { ; -- Playback vol decrease
            VoicemeeterRemote.ChangePlaybackGain(-1)

        } Else If (Modifiers.IsPressed("Shift")) { ; -- Playback vol -5
            VoicemeeterRemote.ChangePlaybackGain(-5)

        } Else If (Modifiers.IsPressed("Control")) { ; -- Playback quiet vol
            ; VoicemeeterRemote.SetStripEQ(Strip, -12, -12, 12)
            VoicemeeterRemote.SetPlaybackGain(-25)

        } Else If (Modifiers.IsPressed("Control", "Shift")) { ; -- Playback quiet 2
            ; VoicemeeterRemote.SetStripEQ(Strip, -12, -12, 12)
            VoicemeeterRemote.SetPlaybackGain(-35)
        }
    }
    ; G() {
    ; }
    ; H() {
    ; }
    ; I() {
    ; }
    ; J() {
    ; }
    ; K() {
    ; }
    ; L() {
    ; }
    ; M(Modifiers) {
    ;     If (Modifiers.IsPressed("Alt", "Control")) { ; -- Copy Mouse Position - Ctrl Alt M
    ;         MouseGetPos, OutputVarX, OutputVarY
    ;         Clipboard := OutputVarX . ", " . OutputVarY
    ;         SoundPlay, % Sounds.connected
    ;     }
    ; }
    ; N() {
    ; }
    ; O() {
    ; }
    ; P() {
    ; }
    Q(Modifiers) {
        Fadetime := 200
        Strip := VoicemeeterRemote.strips["Spotify"]
        ; VoicemeeterRemote.ZeroStripEQ(Strip) ; Old revvilo why the fk did you put this here?
        VoicemeeterRemote.StandardVolumeControl(Modifiers, Strip, True)
        If (Modifiers.IsPressed("Control", "Shift", "Alt")) { ; Toggles the strip between outputting on a1 and a2
            VoicemeeterRemote.ToggleStripOutput("5", "A2")
            VoicemeeterRemote.ToggleStripOutput("5", "A1")
        }
    }
    R(Modifiers) {
        ; ---- PLAYBACK Volume Control ----
            
        If (Modifiers.IsPressed()) { ; -- Playback vol increase
            VoicemeeterRemote.ChangePlaybackGain(1)

        } Else If (Modifiers.IsPressed("Shift")) { ; -- Playback vol -5
            VoicemeeterRemote.ChangePlaybackGain(5)

        } Else If (Modifiers.IsPressed("Control")) { ; -- Playback quiet vol
            ; VoicemeeterRemote.SetStripEQ(Strip, -12, -12, 12)
            VoicemeeterRemote.SetPlaybackGain(-10)

        } Else If (Modifiers.IsPressed("Control", "Shift")) { ; -- Playback quiet 2
            ; VoicemeeterRemote.SetStripEQ(Strip, -12, -12, 12)
            VoicemeeterRemote.SetPlaybackGain(0)
        }
    }
    S(Modifiers) {
        strip := VoicemeeterRemote.Strips["Discord"]
        If(Modifiers.IsPressed("Alt")) {
            Misc.SpaceOutLetters()
        } Else {
            VoicemeeterRemote.StandardVolumeControl(Modifiers, strip, 0)
        }
    }
    T(Modifiers) {
        If(Modifiers.IsPressed()) {
            VoicemeeterRemote.ToggleStripOutput(4, "A1")
        }
    }
    ; U() {
    ; }
    V(Modifiers) {
        If (Modifiers.IsPressed("WinKey")) { ; -- Open video folder
            If (WinActive("ahk_exe explorer.exe ahk_class CabinetWClass"))
                SendInput, ^lD:\Video{enter}
            Else
                Run, D:\Video
        } Else If (Modifiers.IsPressed("Shift", "WinKey")) {
            Run, D:\Video
        }
    }
    W(Modifiers) {
        strip := VoicemeeterRemote.Strips["Discord"]
        VoicemeeterRemote.StandardVolumeControl(Modifiers, strip, 1)

        If (Modifiers.IsPressed("Control", "Shift", "Alt")) { ; Toggles the strip between outputting on a1 and a2
            VoicemeeterRemote.ToggleStripOutput(strip, "A2")
            VoicemeeterRemote.ToggleStripOutput(strip, "A1")

        }
    }
    X(Modifiers) {
        If (Modifiers.IsPressed()) {
            SendInput, {Media_Next} ; Next Song
        } Else If (Modifiers.IsPressed("Alt")) {
            Minecraft.MouseMove(2100, 350)
        }
    }
    ;Y(Modifiers) {
    ;}
    Z(Modifiers) {
        If (Modifiers.IsPressed()) {
            SendInput, {Media_Prev} ; Prev song
        ; } Else If (Modifiers.IsPressed("Alt")) {
        ;     Minecraft.MouseMove(-2100, -350)
        }
    }
}