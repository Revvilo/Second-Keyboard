Class OBS {
    Static SceneListClassNN := "Qt5QWindowIcon23"
    Static ChatPopoutTitle := "Twitch - Mozilla Firefox"
    Static EventsPopoutTitle := "StreamElements - Activity Feed - Mozilla Firefox"
    Static EventsPopoutTitleAlt := "Streamlabs Login - Mozilla Firefox"

    Static WebSocket := ""

    ; Select scene based on the index within the list control.
    SelectScene(RequestedScene)
    {
        Socket := OBS.GetOBSWebsocket()
        ; temp := Socket.SendRequest("ToggleStudioMode")
        ; listvars
        ; pause
        ; reader := temp.CreateReader()
        ; Return
        Try {
            Socket.SetPreviewScene(RequestedScene)
        } Catch e {
            Throw { what: "Scene not found: """ RequestedScene """", message: "Scene names are case-sensitive.", level: "info" }
        }
        
        ; The below comments are related to getting values which is in need of implementation
        ; Return
        ; temp := Socket.SendRequest("GetCurrentScene")
        ; msgbox % temp.TryGetValue("Message")
        ; listvars
        ; Return
    }

    SceneControlSend(key)
    {
        Controlsend,, %key%, % "ahk_id " Acc_WindowFromObject(OBS.GetSceneList())
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
        Return ; is this needed? who knows who cares
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
            OBS.SendToOBS("{F14}")  ; -- OBS Transition 2 (Cut)
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
                Return
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

    GetSceneList()
    {
        ; Changing the dock layout on OBS will screw the path up. Yea idk. It's still more reliable than the garbage ClassNN tho.
        oAcc := ""
        If (not (oAcc := Acc_Get("Object", "4.4.1.1.1", 0, "OBS ahk_exe obs64.exe")))
        {
            SoundPlay, % Sounds.asterisk
            Throw { what: "Could not locate scene list in OBS", level: "Info" }
        } Else {
            Return oAcc
        }
    }

    GetOBSWebsocket() {
        ; Msgbox, % OBS.OBSSocket "`n`n" (new OBSWebSocket("")) "`n`n" (OBS.OBSSocket == "") "`n`n" (This.OBSSocket == "")
        ; If (OBS.OBSSocket = "") {
        ;     OBS.OBSSocket := new OBS.OBSWebSocket("ws://127.0.0.1:4444")
        ; }
        If (not WinExist("ahk_exe obs64.exe"))
        {
            SoundPlay, % Sounds.asterisk
            Return
        }
        If (OBS.WebSocket = "") {
            asm := CLR_LoadLibrary("Lib\OBS-Websocket\obs-websocket-dotnet.dll")
            OBS.WebSocket := CLR_CreateObject(asm, "OBSWebsocketDotNet.OBSWebSocket")
            ; OBS.WebSocket.WSTimout := new OBS.WebSocket.WSTimeout(10)
            OBS.WebSocket.Connect("ws://127.0.0.1:4444", "webpleb")
        }
        Return OBS.WebSocket
    }
}