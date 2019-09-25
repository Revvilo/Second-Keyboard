Class OBS {
    Static SceneListClassNN := "Qt5QWindowIcon23"
    Static ChatPopoutTitle := "Twitch - Mozilla Firefox"
    Static EventsPopoutTitle := "StreamElements - Activity Feed - Mozilla Firefox"
    Static EventsPopoutTitleAlt := "Streamlabs Login - Mozilla Firefox"

    ; Select scene based on the index within the list control.
    SelectScene(reqSelection)
    {
        If reqSelection is not integer
            Throw { what: "Invalid argument", file: A_LineFile, line: A_LineNumber, message: "SelectScene argument must be a number!" }

        ; Changing the dock layout on OBS will screw the path up. Yea idk. It's still more reliable than the garbage ClassNN tho.
        oAcc := Acc_Get("Object", "4.4.1.1.1", 0, "OBS Studio ahk_exe obs64.exe") ; Resulting acc obj is list of scenes in OBS - acc role 33
        ; Acc_Children(oAcc)[3].accSelect(0x2, 0) ; Does not work - Wish it did tho
        id := Acc_WindowFromObject(oAcc) ; Gets control HWND from object
        selectedIndex := oAcc.accSelection ; Currently selected index
        selectedIndexDelta := reqSelection - selectedIndex ; Difference between destination index and current index
        ; Msgbox, % Format("Delta: {}`nRequest: {}`nCurrent: {}", selectedIndexDelta, reqSelection, selectedIndex) ; Debug dialog
        If (selectedIndexDelta < 0) {
            ; Need to go upward to get to the requested value
            Loop, % Abs(selectedIndexDelta)
                ControlSend,, {Up}, ahk_id %id%
        } Else If (selectedIndexDelta > 0) {
            ; Need to go downward to get to the requested value - Abs omitted for cleanliness
            Loop, % selectedIndexDelta
                ControlSend,, {Down}, ahk_id %id%
        }
    }

    ToggleStudioMode()
    {
        ; Doesn't work ffs - why does this shit just do everything except actually run the purpose of the control
        Acc_Get("DoAction", "4.8.1.3", 0, "ahk_exe obs64.exe")
    }

    ; Literally all this does is skip if fortnite is active. Just so the game doesn't tab out.
    SpiffyActivate(intitle) {
        IfWinActive, Fortnite
            Return
        WinActivate, %intitle%
    }

    CheckRecordingStatus() {
        Msgbox, CheckOBSRecordingStatus is unimplemented.
        Return
        WinGet, OutputVar, ControlListHwnd, ahk_exe obs64.exe

        Arr := StrSplit(OutputVar, "`n")

        For, i, v in Arr {
            ControlGet, OutputVarCtrl, List, , %v%, ahk_exe obs64.exe
            buffer_size = 20

            ; ensure AHk properly updates variable by initializing with non-zero value
            VarSetCapacity( buffer, buffer_size, 1 )

            ; notice implicit WinTitle specification (i.e., Last Found Window via above WinWait command)
            SendMessage, 0x0D, buffer_size, &buffer, %OutputVarCtrl%, ahk_exe obs64.exe
            Str := Str . "`n" . v . "`n[ " . ErrorLevel . " ]"
        }
        Msgbox, %Str%
    }

    SetMode(mode = "") {
        Throw { what: "Unimplemented Exception", message: "SetMode is currently unimplemented" }
        Return
        If(mode != "")
        {
            If(mode == "Record") {
                ; WinMenuSelectItem, OBS,, Profile, 7
            }
            Else If(mode == "Stream") {

            }
        } Else {
            Throw, "SetOBSMode: Non existant mode requested: " + mode
        }
    }

    AutoTransition(modifiers) {
        If (modifiers == "NumpadSub") {
            This.SendToOBS("{F14}")  ; -- OBS Transition 2 (Cut)
        }
    }

    SendToOBS(input := "") {
        If (input == "") {
            Throw, Invalid Input for SendToOBS
        } Else {
            WinGet, winList, List, ahk_exe obs64.exe
            If (winList == 0)
            {
                SoundPlay, % Sounds.Asterisk
                return
            }
            ; PLEASE COMMENT WHY YOU REMOVE STUFF CMON MAN
            ; If (winList > 1) {
                ; Loop, %winList%
                ; {
                    ; msgbox % winList%a_index%
                    ; this_id := winList%a_index%
                    ; ControlSend,, %input%, ahk_id %this_id%
                    ; Sleep, 1000
                ; }
            ; } ;Else {
                this_id := winList1
                ; msgbox %this_id%
                ControlSend,, %input%, ahk_id %this_id%
            ; }
        }
    }
}