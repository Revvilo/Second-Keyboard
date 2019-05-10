Class BrowserControl {
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
            ControlClick, X400 Y300, Firefox
            Sleep, 50
            ControlSend,, {space}, Firefox
        } Else If (InStr(FirefoxTitle, "Youtube")) {
            ; ControlGet, ControlID, Hwnd,, MozillaWindowClass, Firefox.
            ; ControlFocus,, ahk_id %ControlID%
            ControlSend,, k, Firefox
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
            ControlClick, X400 Y300, Firefox
            Sleep, 50
            ControlSend,, {Control Down}f{Control Up}, Firefox
        } Else If (InStr(FirefoxTitle, "Youtube")) {
            ; ControlGet, ControlID, Hwnd,, MozillaWindowClass, Firefox.
            ; ControlFocus,, ahk_id %ControlID%
            ControlSend,, f, Firefox
        }

        SetTitleMatchMode, % oldTMM
        DetectHiddenWindows, % oldDHW
    }
}