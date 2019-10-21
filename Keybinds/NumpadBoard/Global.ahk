Class Global {

    ; List of keys that will be considered modifiers instead of hotkeys along with their respective aliases to use when retreiving modifiers. Eg { "RAlt": "Alt" } - 'RAlt' is known as 'Alt'
    Static modifierKeys := {  "NumpadSub": "NumpadSub"
                            , "RControl": "Control" 
                            , "RShift": "Shift" }

    Space() {
        Spotify.ToggleVol()
        Return
        If (WinActive("ahk_exe Firefox.exe")) {
            Sendinput, {Ctrl Down}m{Ctrl Up}
        }
        WinMinimize, ahk_exe Firefox.exe
        WinMinimize, a
    }

    ; PrintScreen() {
    ;     KeybindSets.PrimaryBoard.Global.Appskey()
    ; }
    Apostrophe() {
        ToggleTimer("AutoClicker")
    }
    Up() { ; LEFT
        SendInput, {Media_Prev}
    }
    Down() { ; RIGHT
        SendInput, {Media_Next}
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

    Delete(modifiers) {
        KeybindSets.PrimaryBoard.Global.Delete(modifiers)
    }
    Insert(modifiers) {
        KeybindSets.PrimaryBoard.Global.Insert(modifiers)
    }
    Home(modifiers) {
        KeybindSets.PrimaryBoard.Global.Home(modifiers)
    }
    End(modifiers) {
        KeybindSets.PrimaryBoard.Global.End(modifiers)
    }
    PgUp(modifiers) {
        KeybindSets.PrimaryBoard.Global.PgUp(modifiers)
    }
    PgDn(modifiers) {
        KeybindSets.PrimaryBoard.Global.PgDn(modifiers)
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

    NumpadIns(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadIns(modifiers)
    }
    NumpadEnd(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadEnd(modifiers)
    }
    NumpadDown(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadDown(modifiers)
    }
    NumpadPgDn(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadPgDn(modifiers)
    }
    NumpadLeft(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadLeft(modifiers)
    }
    NumpadClearmodifiers(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadClear(modifiers)
    }
    NumpadRight(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadRight(modifiers)
    }
    NumpadHome(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadHome(modifiers)
    }
    NumpadUp(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadUp(modifiers)
    }
    NumpadPgUp(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadPgUp(modifiers)
    }
    NumpadAdd(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadAdd(modifiers)
    }
    NumpadDiv(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadDiv(modifiers)
    }
    NumpadMult(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadMult(modifiers)
    }
    NumpadDel(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadDel(modifiers)
    }
    NumpadEnter(modifiers) {
        KeybindSets.PrimaryBoard.Global.NumpadEnter(modifiers)
    }
}