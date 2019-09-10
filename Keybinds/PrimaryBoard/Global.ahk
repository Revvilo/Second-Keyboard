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
    WinKey_Shift(Key) {
        This.WinKey(Key, ShiftHeld := true)
    }
    WinKey(Key, ShiftHeld := false) {
        If (Key == "p") {
            Misc.ExploreTo("F:\Programming", ShiftHeld)
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

    F1() {
        SendInput, {U+2770} ; ❰
    }
    F2() {
        SendInput, {U+2550} ; ═
    }
    F3() {
        SoundPlay, % Sounds.SFX.stopSounds
    }
    F4() {
        SendInput, {U+2771} ; ❱
    }
    F5() {
    }
    F6() {
        Minecraft.SendCommand("/{#}fill air reccomplex:generic_space --shape sphere")
        Sleep, 200
        Minecraft.SendCommand("/{#}selection set ~ ~1 ~")
    }
    ; F7() {
    ; }
    ; F8() {
    ; }
    ; F9() {
    ; }
    ; F10() {
    ; }
    ; F11() {
    ; }
    ; F12() {
    ; }

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
        ; WinMove, Twitch - Mozilla Firefox,, 50, 50, 200, 500
        OBS.CloseComponents(,,True) ; Close OBS
        OBS.OpenComponents(True, True) ; Open chat and events log
        OBS.WaitForComponents(True, True) ; Wait for them
        OBS.SizeComponents(True, True) ; Size chat and events log
    }
    LeftBracket() {
        OBS.OpenComponents(True, True, True) ; Open all
        OBS.WaitForComponents(True, True, True) ; Wait for all
        OBS.SizeComponents(True, True, True) ; Size all
    }
    BackSlash() {
        ; OBS.CloseComponents(True, True) ; Close chat and events log
        OBS.OpenComponents(,,True) ; Open OBS
        ; OBS.WaitForComponents(,,True) ; Wait for OBS
        ; OBS.SizeComponents(,,True) ; Size it
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
        OBS.SendToOBS("{F23}")    ; -- Toggle Streaming
        SoundPlay, % Sounds.connected
    }
    PgDn() {
        OBS.SendToOBS("{F22}")    ; Toggle Recording
    }
    End() {
        OBS.SendToOBS("{F21}")    ; Save Replay Buffer
    }
    Home() {
        OBS.SendToOBS("{F24}") ; Toggle capture foreground window.
    }
    Delete() {
    }
    Insert() {
    }


    ; --------------------- ;
    ; -- NUMPAD CONTROLS -- ;

    NumpadIns() { ; -- Numpad0
        OBS.SendToOBS("{F16}") ; -- OBS Toggle Mic
    }
    NumpadEnd(modifiers) { ; -- Numpad1
        OBS.SelectScene("1")
        OBS.AutoTransition(modifiers)
    }
    NumpadDown(modifiers) { ; -- Numpad2
        OBS.SelectScene("2")
        OBS.AutoTransition(modifiers)
    }
    NumpadPgDn(modifiers) { ; -- Numpad3
        OBS.SelectScene("3")
        OBS.AutoTransition(modifiers)
    }
    NumpadLeft(modifiers) { ; -- Numpad4
        OBS.SelectScene("4")
        OBS.AutoTransition(modifiers)
    }
    NumpadClear(modifiers) { ; -- Numpad5
        OBS.SelectScene("5")
        OBS.AutoTransition(modifiers)
    }
    NumpadRight(modifiers) { ; -- Numpad6
        OBS.SelectScene("6")
        OBS.AutoTransition(modifiers)
    }
    NumpadHome(modifiers) { ; -- Numpad7
        OBS.SelectScene("7")
        OBS.AutoTransition(modifiers)
    }
    NumpadUp(modifiers) { ; -- Numpad8
        OBS.SelectScene("8")
        OBS.AutoTransition(modifiers)
    }
    NumpadPgUp(modifiers) { ; -- Numpad9
        OBS.SelectScene("9")
        OBS.AutoTransition(modifiers)
    }

    NumpadAdd() {
        SendInput, !{F19} ; -- Toggle Discord deafen
    }
    NumpadDiv() {
        OBS.SendToOBS("{F13}") ; -- OBS Transition 1 (Luma Wipe)
    }
    NumpadMult() {
        OBS.SendToOBS("{F14}")  ; -- OBS Transition 2 (Cut)
    }
    ; NumpadSub() {
    ; }
    NumpadDel(Modifiers) {
        If (Modifiers == "NumpadSub")
        OBS.SendToOBS("{F15}") ; -- OBS Toggle Camera
        Else If (Modifiers == "")
        OBS.SendToOBS("{F18}") ; -- OBS Toggle System Audio
    }
    NumpadEnter() {
        SendInput, !{F20} ; -- Toggle Discord mic
    }
    ; Numlock() { ; This doesn't work - Both pause_break and scrolllock show up as "Pause", god knows why.
    ; }
    Pause() {
        OBS.SendToOBS("{F17}")
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

    1() {
        PlayPreloadedSound(Sounds.SFX["applause"])
        ; SoundPlay, % Sounds.SFX.applause
    }
    2() {
        SoundPlay, % Sounds.SFX["Badum Tss"]
    }
    3() {
        SoundPlay, % Sounds.SFX["357 Magnum Gun Shot Fire"]
    }
    4() {
        SoundPlay, % Sounds.SFX.fart
    }
    5() {
        SoundPlay, % Sounds.SFX["Crab Rave"]
    }
    6() {
        SoundPlay, % Sounds.SFX["Song - Ocean Man"]
    }
    7() {
    }
    8() {
    }
    9() {
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
    }
    G() {
    }
    H() {
    }
    I() {
        OBS.SizeComponents(True, True, True) ; -- Size windows according to current layout
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
        OBS.CloseComponents(True, True, True)
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