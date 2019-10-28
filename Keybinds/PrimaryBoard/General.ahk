Class General {
    Q(Modifiers) {
        If (WinExist("ahk_exe Spotify.exe")) {
            If (Modifiers.IsPressed()) { ; -- Spotify vol increase
                VoicemeeterRemote.ChangeStripGain(3, 1)
                ; Spotify.VolChange(1, "change") 
            } Else If (Modifiers.IsPressed("Shift")) { ; -- Spotify vol +5
                VoicemeeterRemote.ChangeStripGain(3, 5)
                ; Spotify.VolChange(5, "change")
            } Else If (Modifiers.IsPressed("Control")) { ; -- Spotify loud vol
                VoicemeeterRemote.SetStripGain(3, -10)
                ; Spotify.VolChange(Spotify.volLoud, "set")
            } Else If (Modifiers.IsPressed("Control", "Shift")) {
                VoicemeeterRemote.SetStripGain(3, 0)
                ; Spotify.VolChange(Spotify.systemVol, "set")
            }
        }
    }
    A(Modifiers) {
        If (WinExist("ahk_exe Spotify.exe")) {
            If (Modifiers.IsPressed()) { ; -- Spotify vol decrease
                VoicemeeterRemote.ChangeStripGain(3, -1)
                ; Spotify.VolChange(-1, "change")
            } Else If (Modifiers.IsPressed("Shift")) { ; -- Spotify vol -5
                VoicemeeterRemote.ChangeStripGain(3, -5)
                ; Spotify.VolChange(-5, "change")
            } Else If (Modifiers.IsPressed("Control")) { ; -- Spotify quiet vol
                VoicemeeterRemote.SetStripGain(3, -30)
                ; Spotify.VolChange(Spotify.volQuiet, "set")
            }
        }
    }
}