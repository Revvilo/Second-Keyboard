AddTextEvent(Contents := "", Preset := "Base") {
    SendInput, !ix
    WinWait, Video Media Generators,, 5
    Sleep, 500
    SelectTextPreset(Preset)
    If (Contents != "") {
        oldClipboard := Clipboard
        Clipboard := Contents
        SendInput, ^v
        Sleep, 100
        Clipboard := oldClipboard
    } Else {
        Sleep, 100
    }
}

ShowSubtitleGui() {
    Gui, Destroy
    Gui, Font, s10, Tahoma
    Gui, Add, Edit, w300 h150 vEditContents
    Gui, Font, s8
    Gui, Add, Button, h23 w75 gVegasGui_Done, Done
    Gui, Add, Button, x+10 h23 w75 gVegasGui_Cancel, Cancel
    Gui, Show,, Enter Text For Subtitling
}

VegasGui_Done() { ; -- === ---- ===== ------ =======
    Gui, Submit
    WinActivate, VEGAS Pro 14.0
    SplitContents := StrSplit(EditContents, "`n")
    For i, v in SplitContents {
        Sleep, 150
        v := Trim(v, " `t")
        AddTextEvent(v)
        WinClose, Video Media Generators
        If (SplitContents[i+1] != "") {
            SendInput, ^!{Right}
        }
    }
}

VegasGui_Cancel() {
    Gui, Destroy
}

Vegas_ToggleShake() {
    Static Toggle
    Static randMax := 25
    Static randMin := randMax - randMax * 2
    Static mouseX
    Static mouseY
    MouseGetPos, mouseX, mouseY
    SetTimer, shake, % (Toggle:=!Toggle) ? 0 : "Off"
    shake:
        Random, randX, %randMin%, %randMax%
        Random, randY, %randMin%, %randMax%
        MouseMove, mouseX + randX, mouseY + randY

        ; ControlFocus, SonyCreativeSoftwareInc_TrackView1, Track Motion
        ; SendInput, {Left}

        Sleep, 1
    Return
}

SelectTextPreset(Preset) {
    ControlFocus, Edit1, Video Media Generators
    SendInput, {F4}{Sleep, 50}%Preset%{Enter}
    Sleep, 500
    ControlFocus, WindowsForms10.RichEdit20W.app.0.1e84ccb_r70_ad21
}

EnterText(Text) {
    ControlSend, WindowsForms10.RichEdit20W.app.0.1e84ccb_r70_ad21, %Text%
}

