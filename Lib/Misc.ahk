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
}