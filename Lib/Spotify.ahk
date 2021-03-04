; TODO: This is a library, so it should not have references to external classes such as "Sounds"

Class Spotify {

    ; These two multipliers determine the volume - relative to the current system vol - that will be known as the loud and quiet settings.
    Static volLoudMultiplier := 0.3
    Static volQuietMultiplier := 0.05

    Static currentVolume := ""
    Static oldVolume := ""
    Static hiddenState := ""
    Static oldControlList := ""
    Static volSliderClassNN := ""
    Static spotifyNameClassNN := ""
    Static sliderPos := ""
    Static isVolToggled := false

    systemVol {
        get {
            SoundGet, systemVolume ; Gets the current system volume to use as the max limit for setting volume
            ; Msgbox, %systemVolume%
            Return Floor(systemVolume)
        }
    }
    volLoud {
        get {
            Return this.systemVol * this.volLoudMultiplier
        }
    }
    volQuiet {
        get {
            Return this.systemVol * this.volQuietMultiplier
        }
    }

    Class Alert {
        Static Title := "Spotify Vol Control"
        Static ErrorTitle := "Spotify Vol Control - Error"
    }

    Next() {
        SendInput, {Media_Next} ; Next Song
    }

    Prev() {
        SendInput, {Media_Prev} ; Previous Song
    }

    PlayPause() {
        DetectHiddenWindows, On
        If (WinExist("ahk_exe Spotify.exe"))
            PostMessage, 0x319,, 0xE0000,, ahk_exe Spotify.exe ; msg: WM_APPCOMMAND - lParam: APPCOMMAND_MEDIA_PLAY_PAUSE
        DetectHiddenWindows, Off
    }

    ; -- Toggles visibiliy of Spotify
    ToggleVisibility() {
        oldDHW := A_DetectHiddenWindows
        DetectHiddenWindows, On
        WinGet, spotifyHandle, List, ahk_exe Spotify.exe

        If (DllCall("IsWindowVisible", "UInt", spotifyHandle3, "Int", "0")) { ; Is Spotify visible? If it is, hide it.
            ; Spotify is visible
            SoundPlay, % Sounds.modeChange1
            WinHide, ahk_id %spotifyHandle3%
        } Else {
            ; It's not visible
            SoundPlay, % Sounds.modeChange3
            WinShow, ahk_id %spotifyHandle3%
        }
        DetectHiddenWindows, %oldDHW%
    }

    VolSetPercent(percent := "") {
        
    }

    ToggleVol() {
        If (Spotify.isVolToggled) {
            Spotify.VolChange(Spotify.volLoud, "set")
            Spotify.isVolToggled := false
        } Else {
            Spotify.VolChange(Spotify.volQuiet, "set")
            Spotify.isVolToggled := true
        }
    }

    ; TODO: Change the system so that it takes one of either a percentage value, a positive number, or a negative number to avoid this silly 'vol mode' thing
    ; The percentage would be from volQuiet to volLoud, meaning 50% would be the centerpoint between those two values
    ; Negative values would decrease the volume relatively, and positive would increase

    ; Changes the volume relatively, or sets an absolute volume
    VolChange(volChange := "", volMode := "") {
        If (WinExist("ahk_exe Spotify.exe")) {
            If (!WinExist("ahk_exe SndVol.exe")) {
                Run, SndVol.exe,, Min
                WinWait, Volume Mixer,, 10
                If (ErrorLevel) {
                    SoundPlay, % Sounds.disconnected, Wait
                    MsgBox,, % Spotify.Alert.ErrorTitle, % "Ran out of time while waiting for Volume Mixer to open."
                    Return
                }
                Sleep, 1000 ; Give the mixer time to be fully open
            }

            WinGet, mixerHandle, ID, Volume Mixer
            WinGet, outControlList, ControlList, ahk_id %mixerHandle%
            WinGet, spotifyProcesses, List, ahk_exe Spotify.exe

            currentSpotifyTitle := ""

            Loop, %spotifyProcesses% {
                iterationID := spotifyProcesses%A_Index%
                WinGetTitle, currentSpotifyTitle, ahk_id %iterationID%
                If (currentSpotifyTitle != "") {
                    Break
                }
            }
            If (currentSpotifyTitle == "" && !debug) {
                TrayTip, % This.Alert.Title, % "Spotify's title could not be retrieved. Try debug mode."
                Return
            }

            ControlGetText, wasSpotifysTitle, % This.spotifyNameClassNN, ahk_id %mixerHandle% ; Gets the current text of the control that was originally Spotify's title

            ; DEBUGGING
            If (debug) {
                processList := ""
                Loop, %spotifyProcesses% {
                    tempID := spotifyProcesses%A_Index%
                    WinGetTitle, tempTitle, ahk_id %tempID%
                    processList := processList . A_Index . "`t" . tempTitle . "`n"
                }
                MsgBox, % "wasSpotifysTitle:`t`t" . wasSpotifysTitle . "`ncurrentSpotifyTitle:`t" . currentSpotifyTitle . ((wasSpotifysTitle == currentSpotifyTitle) ? ("`n`nTitles Matched: YES") : ("`n`nTitles Matched: NO")) . "`n`nspotifyNameClassNN:`t" . This.spotifyNameClassNN . "`nvolSliderClassNN:`t`t" . This.volSliderClassNN . "`n`nSpotify's processes with titles:`n" . processList
            }
            ; ---------


            ; CODE THAT LOCKS ON TO SPOTIFY'S SLIDER
            ; Only executes if the control that was last confirmed to contain Spotify's name doesn't contain it anymore.
            If (This.volSliderClassNN == "" || (wasSpotifysTitle != currentSpotifyTitle)) {
                controlsArray := StrSplit(outControlList, "`n")
                FoundSpotify := 0
                For i, e in controlsArray {
                    ; If the line is a static text control
                    If (RegExMatch(e, "Static")) {
                        ; Get the text stored in the static text control
                        ControlGetText, controlText, %e%, ahk_id %mixerHandle%

                        ; If the control's text is the same as the title found earlier
                        If ((controlText == currentSpotifyTitle)) {
                            ; Record the index of the volume slider for Spotify - Two is added because the program's name control preceeds the slider by two controls
                            This.spotifyNameClassNN := controlsArray[A_Index]
                            This.volSliderClassNN := controlsArray[A_Index + 2]

                            ; Spotify was found in the mixer
                            Soundplay, % Sounds.connected
                            FoundSpotify := 1
                            Break
                        }
                    }
                }
                ; -- This is buggered. Fix it.
                If (!FoundSpotify) {
                    Soundplay, % Sounds.asterisk, Wait
                    ; SendInput, {Media_Play_Pause}
                    ; Sleep, 500
                    ; SendInput, {Media_Play_Pause}
                    ; Sleep, 2000
                    ; TrayTip, % Spotify.Alert.Title, % "Cannot find Spotify in the audio mixer.`nTry playing a track."
                }
            } Else {
                ; Commented because DebugTryTip is elsewhere in the project.
                ; DebugTrayTip("No change in the Mixer was detected.`nSliderClassNN: " . This.volSliderClassNN . "`nCurrentSpotifyTitle: " . currentSpotifyTitle . "`nTitle unchanged?: " . ((wasSpotifysTitle == currentSpotifyTitle) ? "True" : "False"))
            }


            ; ========================================================


            SendMessage TBM_GETPOS:=0x400,,, % This.volSliderClassNN, Volume Mixer
            currentVol := 100 - ErrorLevel
            sliderPos := ErrorLevel

            ; Immediately sets the volume to the value in volChange.
            If (volMode == "set") {
                If (not (volChange > this.systemVol)) {
                    SendMessage TBM_SETPOSNOTIFY:=0x422, 1, % 100 - volChange, % This.volSliderClassNN, Volume Mixer ; Absolute change
                } Else {
                    SendMessage TBM_SETPOSNOTIFY:=0x422, 1, % this.systemVol, % This.volSliderClassNN, Volume Mixer ; Absolute change
                }
            ; Increases or decreases the volume if the argument is a positive or a negative number.
            } Else If (volMode == "change") {
                ; Will the volume change exceed maxVol?
                If (not currentVol + volChange > this.systemVol) {
                    ; Will the volume change preceed minVol? (to avoid accidental muting)
                    If (not currentVol + volChange < this.volQuiet) {
                        SendMessage TBM_SETPOSNOTIFY:=0x422, 1, % sliderPos - volChange, % This.volSliderClassNN, Volume Mixer ; Relative change
                    } Else {
                        SendMessage TBM_SETPOSNOTIFY:=0x422, 1, % 100 - This.volQuiet, % This.volSliderClassNN, Volume Mixer ; Set to min vol
                    }
                } Else {
                    SendMessage TBM_SETPOSNOTIFY:=0x422, 1, % 100 - this.systemVol, % This.volSliderClassNN, Volume Mixer ; Set to max vol
                }
            } Else {
                Throw, "`n[ERROR]`n  Cannot change Spotify volume - Mode not recognised or blank`n  Mode = `"" . volMode . "`""
            }
        } Else {
            ; Spotify isn't running.
            Soundplay, % Sounds.disconnected, Wait
            ; TrayTip, % Spotify.Alert.Title, % "Spotify is not running."
            Return
        }
    }
}