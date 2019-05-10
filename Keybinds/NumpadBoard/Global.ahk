Class Global {

    ; List of keys that will be considered modifiers instead of hotkeys along with their respective aliases to use when retreiving modifiers. Eg { "RAlt": "Alt" } - 'RAlt' is known as 'Alt'
    Static modifierKeys := { "NumpadSub": "NumpadSub"
    , "RControl": "Control" 
    , "RShift": "Shift" }

    ; PrintScreen() {
    ;     KeybindSets.PrimaryBoard.Global.Appskey()
    ; }
    Apostrophe() {
        ToggleTimer("AutoClicker")
    }
    Up() { ; RIGHT
        SendInput, {Media_Next}
    }
    Down() { ; LEFT
        SendInput, {Media_Prev}
    }
    Right(modifiers) { ; UP
        If (modifiers == "") { ; -- Spotify vol +5
            Spotify.VolChange(5, "change")
        } Else If (modifiers == "Control") { ; -- Spotify loud vol
            Spotify.VolChange(Spotify.volLoud, "set")
        } Else If (modifiers == "Control Shift") {
            Spotify.VolChange(Spotify.systemVol, "set")
        }
    }
    Left(modifiers) { ; DOWN
        If (modifiers == "") { ; -- Spotify vol -5
            Spotify.VolChange(-5, "change")
        } Else If (modifiers == "Control") { ; -- Spotify quiet vol
            Spotify.VolChange(Spotify.volQuiet, "set")
        }
    }

    Enter() {
        SendInput, {Media_Play_Pause}
    }

    Delete() {
        KeybindSets.PrimaryBoard.Global.Delete()
    }
    Insert() {
        KeybindSets.PrimaryBoard.Global.Insert()
    }
    Home() {
        KeybindSets.PrimaryBoard.Global.Home()
    }
    End() {
        KeybindSets.PrimaryBoard.Global.End()
    }
    PgUp() {
        KeybindSets.PrimaryBoard.Global.PgUp()
    }
    PgDn() {
        KeybindSets.PrimaryBoard.Global.PgDn()
    }
    Backslash(modifiers) {
        If (modifiers == "") {
            BrowserControl.PlayPause()
        } Else If (modifiers == "NumpadSub") {
            BrowserControl.ToggleFullscreen()
        }
    }

    RightBracket() {
        ToggleTimer("Vanilla_Autocraft")
        SendInput, {Shift Up}
    }
    LeftBracket() {
        ToggleTimer("Vanilla_Plankcraft")
        SendInput, {Shift Up}
        SendInput, {Control Up}
    }

    NumpadIns() {
        KeybindSets.PrimaryBoard.Global.NumpadIns(modifiers)
    }
    NumpadEnd() {
        KeybindSets.PrimaryBoard.Global.NumpadEnd(modifiers)
    }
    NumpadDown() {
        KeybindSets.PrimaryBoard.Global.NumpadDown(modifiers)
    }
    NumpadPgDn() {
        KeybindSets.PrimaryBoard.Global.NumpadPgDn(modifiers)
    }
    NumpadLeft() {
        KeybindSets.PrimaryBoard.Global.NumpadLeft(modifiers)
    }
    NumpadClear() {
        KeybindSets.PrimaryBoard.Global.NumpadClear(modifiers)
    }
    NumpadRight() {
        KeybindSets.PrimaryBoard.Global.NumpadRight(modifiers)
    }
    NumpadHome() {
        KeybindSets.PrimaryBoard.Global.NumpadHome(modifiers)
    }
    NumpadUp() {
        KeybindSets.PrimaryBoard.Global.NumpadUp(modifiers)
    }
    NumpadPgUp() {
        KeybindSets.PrimaryBoard.Global.NumpadPgUp(modifiers)
    }
    NumpadAdd() {
        KeybindSets.PrimaryBoard.Global.NumpadAdd()
    }
    NumpadDiv() {
        KeybindSets.PrimaryBoard.Global.NumpadDiv()
    }
    NumpadMult() {
        KeybindSets.PrimaryBoard.Global.NumpadMult()
    }
    NumpadDel(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadDel(modifiers)
    }
    NumpadEnter() {
        KeybindSets.PrimaryBoard.Global.NumpadEnter()
    }
}