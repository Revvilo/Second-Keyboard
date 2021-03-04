Class Misc {
    ; This variable contains a list of Asc() converted characters and their "small" counterparts for use in making chars small
    Static CharDict := { "33": "{U+1d4e}", "40": "{U+207d}", "41": "{U+207e}", "48": "{U+2070}", "49": "{U+00b9}", "50": "{U+00b2}", "51": "{U+00b3}", "52": "{U+2074}", "53": "{U+2075}", "54": "{U+2076}", "55": "{U+2077}", "56": "{U+2078}", "57": "{U+2079}", "63": "{U+02c0}", "65": "{U+1d2c}", "66": "{U+1d2e}", "67": "{U+1d9c}", "68": "{U+1d30}", "69": "{U+1d31}", "70": "{U+1da0}", "71": "{U+1d33}", "72": "{U+1d34}", "73": "{U+1d35}", "74": "{U+1d36}", "75": "{U+1d37}", "76": "{U+1d38}", "77": "{U+1d39}", "78": "{U+1d3a}", "79": "{U+1d3c}", "80": "{U+1d3e}", "81": "{U+1d60}", "82": "{U+1d3f}", "83": "{U+02e2}", "84": "{U+1d40}", "85": "{U+1d41}", "86": "{U+2c7d}", "87": "{U+1d42}", "88": "{U+02e3}", "89": "{U+02b8}", "90": "{U+1dbb}", "97": "{U+1d43}", "98": "{U+1d47}", "99": "{U+1d9c}", "100": "{U+1d48}", "101": "{U+1d49}", "102": "{U+1da0}", "103": "{U+1d4d}", "104": "{U+02b0}", "105": "{U+1da6}", "106": "{U+02b2}", "107": "{U+1d4f}", "108": "{U+02e1}", "109": "{U+1d50}", "110": "{U+207f}", "111": "{U+1d52}", "112": "{U+1d56}", "113": "{U+1d60}", "114": "{U+02b3}", "115": "{U+02e2}", "116": "{U+1d57}", "117": "{U+1d58}", "118": "{U+1d5b}", "119": "{U+02b7}", "120": "{U+02e3}", "121": "{U+02b8}", "122": "{U+1dbb}" }

    FadeOutWindow(ByRef hwnd, ByRef duration := 100) {
        DllCall("AnimateWindow", "Ptr", hwnd, "UInt", duration, "UInt", fadeIn ? 0x80000 : 0x80000 | 0x10000)
    }

    FadeOutWindowAfter(ByRef hwnd, ByRef delay, ByRef duration := 100) {
        Sleep, % delay
        This.FadeOutWindow(hwnd, duration)
    }

    MoveWindowMonitor(ByRef hwnd, ByRef display) {
        SysGet, monitorCount, MonitorCount
        SysGet, monitorBounds, Monitor, %display%
        WinGetPos, winX, winY, winWidth, winHeight, ahk_id %hwnd%

        

        WinMove, ahk_id %hwnd%,, X, Y
    }

    SpaceOutLetters() {
        SendInput, ^c
        Sleep, 100
        Chars := StrSplit(Clipboard)
        Outstr := Chars[1]
        For i, v in Chars
        {
            If (i != 1)
                If (v == "    ")
                    Outstr .= v
                Else
                    Outstr := Outstr . "    " . v
        }
        Clipboard := Outstr
        SendInput, ^v
    }

    ExploreTo(path, forceNewWindow) {
        If (WinActive("ahk_exe explorer.exe ahk_class CabinetWClass") && !forceNewWindow)
            SendInput, ^l%path%{enter}
        Else
            Run, %path%
    }

    SmallLetters() {
        SendInput, ^c
        Sleep, 100
        Chars := StrSplit(Clipboard)
        For i, v in Chars
        {
            ascv := Asc(v)
            For ii, vv in This.CharDict
            {
                If (ascv == ii) {
                    SendInput, % vv
                    v := ""
                    Break
                }
            }
            SendInput, % v
        }
        ; Clipboard := Outstr
        ; SendInput, ^v
    }
}