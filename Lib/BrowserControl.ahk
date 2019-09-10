Class BrowserControl {
    Static PreferredBrowserExe := "Firefox.exe"
    PlayPause() {
        oldTMM := A_TitleMatchMode
        oldDHW := A_DetectHiddenWindows
        SetTitleMatchMode, 2
        DetectHiddenWindows, On

        ; ControlSend,, k, Firefox

        WinGetTitle, FirefoxTitle, Firefox
        DebugMessage("Firefox's Title: " . FirefoxTitle)
        If (InStr(FirefoxTitle, "Twitch")) {
            ; ControlGet, ControlID, Hwnd,, MozillaWindowClass, Firefox
            ; ControlFocus,, ahk_id %ControlID%
            ControlClick, X400 Y300, % "ahk_exe " . BrowserControl.PreferredBrowserExe
            Sleep, 50
            ControlSend,, {space}, % "ahk_exe " . BrowserControl.PreferredBrowserExe
        } Else If (InStr(FirefoxTitle, "Youtube")) {
            ; ControlGet, ControlID, Hwnd,, MozillaWindowClass, Firefox.
            ; ControlFocus,, ahk_id %ControlID%
            ControlSend,, k, % "ahk_exe " . BrowserControl.PreferredBrowserExe
        }

        SetTitleMatchMode, % oldTMM
        DetectHiddenWindows, % oldDHW
    }

    Fullscreen() {
        oldTMM := A_TitleMatchMode
        oldDHW := A_DetectHiddenWindows
        SetTitleMatchMode, 2
        DetectHiddenWindows, On

        WinGetTitle, FirefoxTitle, Firefox
        DebugMessage("Firefox's Title: " . FirefoxTitle)
        If (InStr(FirefoxTitle, "Twitch")) {
            ; ControlGet, ControlID, Hwnd,, MozillaWindowClass, Firefox
            ; ControlFocus,, ahk_id %ControlID%
            ControlClick, X400 Y300, % "ahk_exe " . BrowserControl.PreferredBrowserExe
            Sleep, 50
            ControlSend,, {Control Down}f{Control Up}, % "ahk_exe " . BrowserControl.PreferredBrowserExe
        } Else If (InStr(FirefoxTitle, "Youtube")) {
            ; ControlGet, ControlID, Hwnd,, MozillaWindowClass, Firefox.
            ; ControlFocus,, ahk_id %ControlID%
            ControlSend,, f, % "ahk_exe " . BrowserControl.PreferredBrowserExe
        }

        SetTitleMatchMode, % oldTMM
        DetectHiddenWindows, % oldDHW
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
                ControlSend,, % input, % "ahk_exe " . BrowserControl.PreferredBrowserExe
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