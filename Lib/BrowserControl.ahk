Class BrowserControl {
    Static PreferredBrowserExe := "ahk_exe firefox.exe"

    SendToBrowser(Input) {
        ControlSend, ahk_parent, %Input%, % BrowserControl.PreferredBrowserExe
    }

    PlayPause() {
        This.SendToBrowser("k")
    }

    MuteUnmute() {
        This.SendToBrowser("m")
    }

    Fullscreen() {
        This.SendToBrowser("f")
    }

    Class YoutubeMusic {
        PlayPause() {
            This.SendToBrowser(";")
        }

        Shuffle() {
            This.SendToBrowser("s")
        }

        Next() {
            This.SendToBrowser("k")
        }

        Prev() {
            This.SendToBrowser("j")
        }

        SeekFwd() {
            This.SendToBrowser("l")
        }

        SeekBwd() {
            This.SendToBrowser("h")
        }

        VolUp() {
            This.SendToBrowser("=")
        }

        VolDown() {
            This.SendToBrowser("-")
        }

        SendToBrowser(input) {
            oldDHW := A_DetectHiddenWindows
            DetectHiddenWindows, On
            If (BrowserControl.YoutubeMusic.IsRunning()) {
                ControlSend, ahk_parent, % input, % "ahk_exe " . BrowserControl.PreferredBrowserExe
            }
            DetectHiddenWindows, % oldDHW
        }

        IsRunning() {
            If (WinExist("YouTube Music ahk_exe " . BrowserControl.PreferredBrowserExe)) {
                return True
            } Else {
                return False
            }
        }
    }
}