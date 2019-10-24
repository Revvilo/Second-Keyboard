Class Browser {
    Q(Modifiers) {
        If (Modifiers.IsPressed()) { ; -- vol increase
            MixerControl.ChangeVolume("Mozilla Firefox", 1, "change")
        } Else If (Modifiers.IsPressed("Alt")) {
            BrowserControl.YoutubeMusic.VolUp()
        } Else If (Modifiers.IsPressed("Shift")) { ; -- vol +5
            MixerControl.ChangeVolume("Mozilla Firefox", 5, "change")
        } Else If (Modifiers.IsPressed("Control")) { ; -- set to loud vol
            MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.volLoud, "set")
        } Else If (Modifiers.IsPressed("Control", "Shift")) {
            MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.systemVol, "set")
        }
    }
    A(Modifiers) {
        If (Modifiers.IsPressed()) { ; -- vol increase
            MixerControl.ChangeVolume("Mozilla Firefox", -1, "change")
        } Else If (Modifiers.IsPressed("Alt")) {
            BrowserControl.YoutubeMusic.VolDown()
        } Else If (Modifiers.IsPressed("Shift")) { ; -- vol +5
            MixerControl.ChangeVolume("Mozilla Firefox", -5, "change")
        } Else If (Modifiers.IsPressed("Control")) { ; -- set to loud vol
            MixerControl.ChangeVolume("Mozilla Firefox", MixerControl.volQuiet, "set")
        }
    }
}