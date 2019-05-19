class Fortnite {
    FortniteTrackingTrainer() {
        ; Randomly strafes to simulate enemy movement
        If (!(WinActive("Fortnite")))
            Return

        ; There's no way in hell that this should be global, but I don't play Fortnite anymore so I don't care
        Global Alternate
        If (InStr(Alternate, "a")) {
            Alternate := "d"
        } Else {
            Alternate := "a"
        }

        SendInput, {%Alternate% down}
        
        Random, RandomTime, 500, 2500
        RandomTime := RandomTime / 1000 ; Translate milliseconds to floating point seconds
        Input, PressedKey, I T%RandomTime% V,, a,d
        If (ErrorLevel == "Timeout") {
            SendInput, {%Alternate% up}
        } Else {
            SendInput, {%Alternate% up}
            SendInput, {%PressedKey% down}
            KeyWait, %PressedKey%
        }
        ; Sleep, % RandomTime
    }
}