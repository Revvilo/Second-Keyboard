; THIS FILE IS NOT COMPLETE AND SHOULD NOT BE IN USE UNTIL THE OLD SPOTIFY CODE IS ADAPTED
; IT IS CURRENTLY A STRAIGHT COPY PASTE OF THE CODE USED IN SPOTIFY.AHK

Class MixerControl {
    ; These two multipliers determine the volume - relative to the current system vol - and will be known as the loud and quiet settings.
    Static volLoudMultiplier := 0.6
    Static volQuietMultiplier := 0.05

    Static volSliderClassNN := ""
    Static programNameControlClassNN := ""
    Static sliderPos := ""

    systemVol {
        get {
            SoundGet, systemVolume ; Gets the current system volume to use as the max limit for setting volume
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

    ; Changes the volume relatively, or sets an absolute volume
    ChangeVolume(TargetProgramName, volChange := "", volMode := "") {
        If (WinExist(TargetProgramName)) {
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


            ;;;; Unneeded due to normal use of the mixer not requiring the program to work around Spotify's title changing antics ;;;;
            ; WinGet, spotifyProcesses, List, ahk_exe Spotify.exe

            ; currentSpotifyTitle := ""

            ; Loop, %spotifyProcesses% {
            ;     iterationID := spotifyProcesses%A_Index%
            ;     WinGetTitle, currentSpotifyTitle, ahk_id %iterationID%
            ;     If (currentSpotifyTitle != "") {
            ;         Break
            ;     }
            ; }
            ; If (currentSpotifyTitle == "" && !debug) {
            ;     TrayTip, % This.Alert.Title, % "Spotify's title could not be retrieved. Try debug mode."
            ;     Return
            ; }


            ; DEBUGGING
            ; If (debug) {
            ;     processList := ""
            ;     Loop, %spotifyProcesses% {
            ;         tempID := spotifyProcesses%A_Index%
            ;         WinGetTitle, tempTitle, ahk_id %tempID%
            ;         processList := processList . A_Index . "`t" . tempTitle . "`n"
            ;     }
            ;     MsgBox, % "wasSpotifysTitle:`t`t" . wasSpotifysTitle . "`ncurrentSpotifyTitle:`t" . currentSpotifyTitle . ((wasSpotifysTitle == currentSpotifyTitle) ? ("`n`nTitles Matched: YES") : ("`n`nTitles Matched: NO")) . "`n`nprogramNameControlClassNN:`t" . This.programNameControlClassNN . "`nvolSliderClassNN:`t`t" . This.volSliderClassNN . "`n`nSpotify's processes with titles:`n" . processList
            ; }
            ; ---------


            ; CODE THAT LOCKS ON TO THE PROGRAM'S SLIDER
            ; Only executes if the control that was last confirmed to contain the programs's name doesn't contain it anymore.

            ControlGetText, wasProgramsTitle, % This.programNameControlClassNN, ahk_id %mixerHandle% ; Gets the current text of the control that was originally the programs's title

            If (This.volSliderClassNN == "" || TargetProgramName != wasProgramsTitle) {
                controlsArray := StrSplit(outControlList, "`n")
                FoundProgram := 0
                For i, e in controlsArray {
                    ; If the line is a static text control
                    If (RegExMatch(e, "Static")) {
                        ; Get the text stored in the static text control
                        ControlGetText, controlText, %e%, ahk_id %mixerHandle%

                        ; If the control's text is the same as the title found earlier
                        If (controlText == TargetProgramName) {
                            ; Record the index of the volume slider for the program - Two is added because the program's name control preceeds the slider by two controls
                            This.programNameControlClassNN := controlsArray[A_Index]
                            This.volSliderClassNN := controlsArray[A_Index + 2]

                            ; The program was found in the mixer
                            Soundplay, % Sounds.connected
                            FoundProgram := 1
                            Break
                        }
                    }
                }
                ; -- This is buggered. Fix it.
                If (!FoundProgram) {
                    Soundplay, % Sounds.asterisk, Wait
                    ; SendInput, {Media_Play_Pause}
                    ; Sleep, 500
                    ; SendInput, {Media_Play_Pause}
                    ; Sleep, 2000
                    ; TrayTip, % Spotify.Alert.Title, % "Cannot find Spotify in the audio mixer.`nTry playing a track."
                }
            } Else {
                DebugTrayTip("No change in the Mixer was detected.`nSliderClassNN: " . This.volSliderClassNN . "`nCurrentSpotifyTitle: " . currentSpotifyTitle . "`nTitle unchanged?: " . ((wasSpotifysTitle == currentSpotifyTitle) ? "True" : "False"))
            }
            ; ========================================================

            ; Msgbox, % This.volSliderClassNN
            SendMessage TBM_GETPOS:=0x400,,, % This.volSliderClassNN, Volume Mixer
            currentVol := 100 - ErrorLevel
            sliderPos := ErrorLevel

            ; Increases or decreases the volume if the argument is a positive or a negative number.
            If (volMode == "set") {
                If (not (volChange > this.systemVol)) {
                    SendMessage TBM_SETPOSNOTIFY:=0x422, 1, % 100 - volChange, % This.volSliderClassNN, Volume Mixer ; Absolute change
                } Else {
                    SendMessage TBM_SETPOSNOTIFY:=0x422, 1, % this.systemVol, % This.volSliderClassNN, Volume Mixer ; Absolute change
                }
            } Else If (volMode == "change") {
                ; If the volume change will not exceed the maxVol
                If (not currentVol + volChange > this.systemVol) {
                    ; If the volume change will not preceed minVol (to avoid accidental muting)
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