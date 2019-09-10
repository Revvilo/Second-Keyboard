Class Misc {
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
}