Class General {
    Q(Modifiers) {
        If (WinExist("ahk_exe Spotify.exe")) {
            If (Modifiers.IsPressed()) { ; -- Spotify vol increase
                Spotify.VolChange(1, "change") 
            } Else If (Modifiers.IsPressed("Shift")) { ; -- Spotify vol +5
                Spotify.VolChange(5, "change")
            } Else If (Modifiers.IsPressed("Control")) { ; -- Spotify loud vol
                Spotify.VolChange(Spotify.volLoud, "set")
            } Else If (Modifiers.IsPressed("Control", "Shift")) {
                Spotify.VolChange(Spotify.systemVol, "set")
            }
        }
    }
    A(Modifiers) {
        If (WinExist("ahk_exe Spotify.exe")) {
            If (Modifiers.IsPressed()) { ; -- Spotify vol decrease
                Spotify.VolChange(-1, "change")
            } Else If (Modifiers.IsPressed("Shift")) { ; -- Spotify vol -5
                Spotify.VolChange(-5, "change")
            } Else If (Modifiers.IsPressed("Control")) { ; -- Spotify quiet vol
                Spotify.VolChange(Spotify.volQuiet, "set")
            }
        }
    }
}