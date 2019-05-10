Class OBS {
    Static ChatPopoutTitle := "Twitch - Mozilla Firefox"
    Static EventsPopoutTitle := "StreamElements - Activity Feed - Mozilla Firefox"
    Static EventsPopoutTitleAlt := "Streamlabs Login - Mozilla Firefox"

    Static horizontalGapCompensation := 14
    Static verticalGapCompensation := 7

    Static offsets_offset_x := 0
    Static offsets_offset_y := 0

    Static topleft_origin_x
    Static topleft_origin_y

    Static chat_x
    Static chat_y
    Static chat_w := 262
    Static chat_h

    Static events_x
    Static events_y
    Static events_w
    Static events_h
    Static events_x_state2
    Static events_y_state2
    Static events_w_state2
    Static events_h_state2

    Static obs_x
    Static obs_y
    Static obs_w
    Static obs_h

    Static obs_x_state2 := OBS.topleft_origin_x
    Static obs_y_state2 := OBS.topleft_origin_y
    Static obs_w_state2 := 1296
    Static obs_h_state2 := 1004

    Static obs_x_dual1 := OBS.topleft_origin_x
    Static obs_y_dual1 := OBS.topleft_origin_y
    Static obs_w_dual1 := 1293
    Static obs_h_dual1 := 504

    Static obs_x_dual2 := OBS.topleft_origin_x
    Static obs_y_dual2 := OBS.topleft_origin_y + OBS.obs_h_dual1 - 7 ; idfk, but it fixes the stupid gap
    Static obs_w_dual2 := OBS.obs_w_dual1
    Static obs_h_dual2 := OBS.obs_h_dual1

    ; VARIABLES ABOVE MUST REFERENCE 'OBS' AND NOT 'THIS'

    ; OK LOOK I KNOW THIS IS ALL BUGGERED - BUT I MADE IT WHEN I WAS BUT A SMALL LAD AND I REALLY CANT DO IT

    ;--------------------------------------------------------------------------------------------------------------------------------------------------

    CalculatePositions() {
        SysGet, PrimaryMonitor, Monitor
        SysGet, Monitor, MonitorWorkArea, 2

        ; These two are here to maintain original functionality while in the process of changing to a dynamic pos calc system.
        this.topleft_origin_x := MonitorLeft
        this.topleft_origin_y := MonitorTop

        this.chat_x := MonitorLeft
        this.chat_y := MonitorTop
        this.chat_w := OBS.chat_w
        this.chat_h := MonitorBottom

        this.events_x := MonitorLeft + this.chat_w - OBS.horizontalGapCompensation
        this.events_y := MonitorTop + MonitorBottom / 2
        this.events_w := MonitorRight - PrimaryMonitorRight - this.chat_w
        this.events_h := MonitorBottom / 2
        this.events_x_state2 := this.events_x
        this.events_y_state2 := MonitorTop
        this.events_w_state2 := this.events_w
        this.events_h_state2 := MonitorBottom

        this.obs_x := MonitorLeft + this.chat_w - OBS.horizontalGapCompensation
        this.obs_y := MonitorTop
        this.obs_w := MonitorRight - PrimaryMonitorRight - this.chat_w
        this.obs_h := MonitorBottom / 2 + OBS.verticalGapCompensation

        this.obs_x_state2 := this.topleft_origin_x
        this.obs_y_state2 := this.topleft_origin_y
        this.obs_w_state2 := 1296
        this.obs_h_state2 := 1004

        this.obs_x_dual1 := this.topleft_origin_x
        this.obs_y_dual1 := this.topleft_origin_y
        this.obs_w_dual1 := 1293
        this.obs_h_dual1 := 504

        this.obs_x_dual2 := this.topleft_origin_x
        this.obs_y_dual2 := this.topleft_origin_y + this.obs_h_dual1 - 7 ; idfk, but it fixes the stupid gap
        this.obs_w_dual2 := this.obs_w_dual1
        this.obs_h_dual2 := this.obs_h_dual1
    }

    SizeComponents(Chat = False, Events = False, OBS = False)
    {
        This.CalculatePositions()
        SetTitleMatchMode, 1
        prevWindow := WinActive("A")
        If(ErrorLevel) {
            ; Msgbox, % "prevWindow error in OBS.ahk: " A_LastError
        }
        
        If(Chat)
        {
            WinMove, % this.ChatPopoutTitle,, % this.chat_x, % this.chat_y, % this.chat_w - this.offsets_offset_x, % this.chat_h
            WinRestore, % this.ChatPopoutTitle
            this.SpiffyActivate(this.ChatPopoutTitle)
        }

        If(Events)
        {
            WinRestore, % this.EventsPopoutTitle
            this.SpiffyActivate(this.EventsPopoutTitle)
            If(Events && OBS)
            {
                WinMove, % this.EventsPopoutTitle,, % this.events_x - this.offsets_offset_x, % this.events_y, % this.events_w + this.offsets_offset_x, % this.events_h
            }
            Else
            {
                WinMove, % this.EventsPopoutTitle,, % this.events_x_state2 - this.offsets_offset_x, % this.events_y_state2, % this.events_w_state2 + this.offsets_offset_x, % this.events_h_state2
            }
        }

        If(OBS)
        {
            WinGet, OBSCount, List, ahk_exe obs64.exe
            Loop %OBSCount% {
                id := OBSCount%a_index%
                WinRestore, ahk_id %id%
                this.SpiffyActivate("ahk_id " id)
            }
            neitherOpen := !Chat && !Events
            If (OBSCount > 1) {
                WinMove, ahk_id %OBSCount1%,, % this.obs_x_dual1, % this.obs_y_dual1, % this.obs_w_dual1, % this.obs_h_dual1
                WinMove, ahk_id %OBSCount2%,, % this.obs_x_dual2, % this.obs_y_dual2, % this.obs_w_dual2, % this.obs_h_dual2
            } Else If (neitherOpen) {
                WinMove, ahk_exe obs64.exe,, % this.obs_x_state2, % this.obs_y_state2, % this.obs_w_state2, % this.obs_h_state2
            } Else If (not neitherOpen) {
                WinMove, ahk_exe obs64.exe,, % this.obs_x - this.offsets_offset_x, % this.obs_y, % this.obs_w + this.offsets_offset_x, % this.obs_h
            }
        }
        ; WinActivate, ahk_id %prevWindow%
        SetTitleMatchMode, 2
    }

    OpenComponents(Chat = False, Events = False, OBS = False)
    {
        oldTMM := A_TitleMatchMode
        SetTitleMatchMode, 1
        If (Chat && Events)
        {
            ; The sole purpose of this messed up looking if/else shit is to make it so that if both windows are requested, AND they're both NOT open
            ; - it opens them simultaniously, rather than one, then waiting, then the other one. Just QOL stuff really.
            If (not WinExist(this.ChatPopoutTitle) && not WinExist(this.EventsPopoutTitle))
            {
                Run, "C:\Program Files\Mozilla Firefox\firefox.exe" -new-window "Lib\Events Popout.html"
                Run, "C:\Program Files\Mozilla Firefox\firefox.exe" -new-window "Lib\Chat Popout.html"
                WinWait, % this.ChatPopoutTitle
                WinWait, % this.EventsPopoutTitle
                WinGet, WindowList, List, Mozilla Firefox

                Loop, %WindowList%
                {
                    id := WindowList%A_Index%
                    WinClose, ahk_id %id%
                }

            }

            If (not WinExist(this.ChatPopoutTitle))
            {
                this.OpenChatPopout()
            }

            If (not WinExist(this.EventsPopoutTitle))
            {
                this.OpenEventsPopout()
            }
        } Else {
            If (Chat)
            {
                this.OpenChatPopout()
            }

            If (Events)
            {
                this.OpenEventsPopout()
            }
        }

        If (OBS)
        {
            If(not WinExist("ahk_exe obs64.exe"))
            {
                Run, obs64.exe, C:\Program Files (x86)\obs-studio\bin\64bit\
                ; WinWait, ahk_exe obs64.exe
            }
        }
        SetTitleMatchMode, %oldTMM%
    }

    ; Literally all this does is skip if fortnite is active. Just so the game doesn't tab out.
    SpiffyActivate(intitle) {
        IfWinActive, Fortnite
            Return
        WinActivate, %intitle%
    }

    OpenChatPopout() {
        SetTitleMatchMode, 1 ; IMPORTANT
        If(not WinExist(this.ChatPopoutTitle))
        {
            ; The below script requires TitleMatchMode to be on 1 - meaning EXACT match mode, we utilise that, so it's an important step.
            Run, "C:\Program Files\Mozilla Firefox\firefox.exe" -new-window "Lib\Chat Popout.html" ; Makes sure to open the HTML page in a new window - IMPORTANT
            WinWait, % this.ChatPopoutTitle ; Waits for the popout to actually open - IMPORTANT
            WinClose, Mozilla Firefox ; Kills the byproduct window that was opened when we opened the popout HTML script.

            ; Msgbox, Open the Twitch chat popout and close this message
            ; parameters := "toolbar=0,menubar=0"
            ; address := "https://www.twitch.tv/popout/revvilo/chat?popout="
            ; js := "javascript:window.open('https://www.twitch.tv/popout/revvilo/chat?popout=', '_blank', toolbar=0,menubar=0);windows.close()"
            ; Run, firefox.exe -new-window "https://www.twitch.tv/popout/revvilo/chat?popout="
            
            ; Run, chrome.exe --app=https://www.Twitch.tv/revvilo/chat?popout=
            ; WinWait, Twitch
        }
        SetTitleMatchMode, 2
    }

    OpenEventsPopout() {
        ; See the "Chat" script above for info comments before modifying anything here.
        SetTitleMatchMode, 1
        If(not WinExist(this.EventsPopoutTitle) and not WinExist(this.EventsPopoutTitleAlt))
        {
            Run, "C:\Program Files\Mozilla Firefox\firefox.exe" -new-window "Lib\Events Popout.html"
            WinWait, % this.EventsPopoutTitle
            WinClose, Mozilla Firefox

            ; Run, firefox.exe -new-window "https://streamlabs.com/dashboard/recent-events"
            ; Run, chrome.exe --app=https://streamlabs.com/dashboard/recent-events
            ; WinWait, Recent Events
        }
        SetTitleMatchMode, 2
    }

    WaitForComponents(Chat = False, Events = False, OBS = False)
    {
        If(Chat)
        {
            WinWait, % this.ChatPopoutTitle,, 10
        }

        If(Events)
        {
            WinWait, % this.EventsPopoutTitle,, 10
        }

        If(OBS)
        {
            WinWait, ahk_exe obs64.exe,, 10
        }
    }

    CloseComponents(Chat = False, Events = False, OBS = False)
    {
        oldTMM := A_TitleMatchMode
        SetTitleMatchMode, 1
        If(Chat)
        {
            WinClose, % this.ChatPopoutTitle
        }

        If(Events)
        {
            WinClose, % this.EventsPopoutTitle
        }
        SetTitleMatchMode, %A_TitleMatchMode%

        If(OBS)
        {
            ; WinClose, ahk_exe obs64.exe
            WinGet, OBSCount, List, ahk_exe obs64.exe
            Loop %OBSCount% {
                id := OBSCount%a_index%
                ; Msgbox, closing %id%
                WinClose, ahk_id %id%
            }
        }
    }

    CheckOBSRecordingStatus() {
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

    SetOBSMode(mode = "") {
        Msgbox, SetOBSMode is unimplemented.
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

    ; Select scene based on the name or part of it. Selects first occurrence of the requestedScene.
    SelectScene(requestedScene)
    {
        ; Msgbox % Acc_Get("Location", "4.4.1.1.1.3", 0, "ahk_exe obs64.exe")
        ; Msgbox, % oAcc.accRole(0)
        ; oAcc := Acc_Get("Object", "4.4.1.1.1", 0, "ahk_exe obs64.exe")
        ; Loop % oAcc.accChildCount
        ; {
        ;     If (InStr(oAcc.accName(A_Index), requestedScene))
        ;     {
                ; Msgbox, % oAcc.accName(Key)
                ; oAcc.accDoDefaultAction(A_Index) ; Does not work
                ; oAcc.accChild(A_Index).accDoDefaultAction() ; Works
                ; Test := SendMessage, LVM_FINDITEMA := 0x100D, -1, %requestedScene%, Qt5QWindowIcon17, ahk_exe obs64.exe
                ; Msgbox, %ErrorLevel%
                ; oAcc := Acc_Get("Object", "4.4.1.1.1." A_Index, 0, "ahk_exe obs64.exe")
                ; oAcc.accDoDefaultAction()
                ; oAcc.accSelect(0x3, A_Index)
                ; Msgbox, %ErrorLevel%
        ;         Return
        ;     }
        ; }
        ; SoundPlay, % Sounds.Asterisk ; Plays if the requested scene wasn't found
        ; WinGet, obsControlList, ControlList, ahk_exe obs64.exe
        ; ; ControlGet, obsScenesText, Cmd, [Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText
        ; ; Msgbox, %obsScenesText%
        ; ; OutStr := ""
        ; Loop, Parse, obsControlList
        ; {
        ;     ControlGetText, obsScenesText, %A_LoopField%, ahk_exe obs64.exe
        ;     Msgbox, %obsScenesText%
        ; }
        ; Msgbox, %obsControlList%
        ; Return
        ; ControlGet, controlText, Cmd, [Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText
        ; Return
        ; ControlSend, Qt5QWindowIcon26, %keys%, ahk_exe obs64.exe
        ControlSend, Qt5QWindowIcon26, %requestedScene%, ahk_exe obs64.exe
        ; ControlSend, Qt5QWindowIcon17, %requestedScene%, ahk_exe obs64.exe
        ; ControlSend, Qt5QWindowIcon14, %keys%, ahk_exe obs64.exe
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
            ; If (winList > 1) {
            ;     Loop, %winList%
            ;     {
            ;         this_id := winList%a_index%
            ;         ControlSend,, %input%, ahk_id %this_id%
            ;         Sleep, 1000
            ;     }
            ; } Else {
                this_id := winList1
                ControlSend,, %input%, ahk_id %this_id%
            ; }
        }
    }
}