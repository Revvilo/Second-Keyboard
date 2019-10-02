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

    SetProfile(RequestedProfile = "") {
        If(RequestedProfile != "")
        {
            Socket := OBS.GetOBSWebsocket()
            Socket.SetCurrentProfile(RequestedProfile)
        } Else {
            Throw { What: "Error setting OBS Profile", Message: "SetProfile: Non existant mode requested: " RequestedProfile }
        }
    }

    SetSceneCollection(RequestedCollection = "") {
        If(RequestedCollection != "")
        {
            Socket := OBS.GetOBSWebsocket()
            Socket.SetCurrentSceneCollection(RequestedCollection)
        } Else {
            Throw { What: "Error setting OBS Scene Collection", Message: "SetSceneCollection: Non existant collection requested: " RequestedCollection }
        }
    }

    Transition(RequestedTransition := "") {
        Socket := OBS.GetOBSWebsocket()
        If (!RequestedTransition) {
            OBS.SendToOBS("{F13}")
        } Else If (RequestedTransition is integer && RequestedTransition < 3 && RequestedTransition > 0) {
            OBS.SendToOBS(Format("{{}F1{}{}}", RequestedTransition + 3)) ; + 2 to index it to F14 and F15
        }
    }

    AutoTransition(modifiers) {
        If (modifiers == "NumpadSub") {
            OBS.Transition()
        }
    }

    ToggleRecording() {
        Socket := OBS.GetOBSWebsocket()
        Socket.SendRequest("StartStopRecording")
    }

    ToggleStreaming() {
        Socket := OBS.GetOBSWebsocket()
        Socket.SendRequest("StartStopStreaming")
    }

    MuteUnmuteMic() {
        OBS.SendToOBS("{F16}")
    }

    MuteUnmuteSystem() {
        OBS.SendToOBS("{F18}")
    }

    ToggleWebcam() {
        OBS.SendToOBS("{F17}")
    }

    ToggleStudioMode() {
        OBS.SendToOBS("{F24}")
    }

    SaveReplayBuffer() {
        OBS.SendToOBS("{F21}")
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
            ControlSend,, %input%, ahk_id %winList1%
        }
    }

    GetSceneList()
    {
        ; Changing the dock layout on OBS will screw the path up. Yea idk. It's still more reliable than the ClassNN tho.
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
        ; Play a sound and stop here if OBS isn't running
        ;  (also deletes the variable incase a socket was previously connected)
        If (not WinExist("ahk_exe obs64.exe"))
        {
            OBS.WebSocket.Disconnect()
            OBS.WebSocket := ""
            SoundPlay, % Sounds.asterisk
            Return
        }

        ; We detect if OBS has been closed and re-opened since the last check by seeing if the PID has changed
        ;  if it has changed we have to re-establish the connection
        WinGet, CurrentPID, PID, ahk_exe obs64.exe

        If (OBS.WebSocket = "" || OBS.PreviousPID != CurrentPID) {
            OBS.PreviousPID := CurrentPID
            asm := CLR_LoadLibrary("Lib\OBS-Websocket\obs-websocket-dotnet.dll")
            OBS.WebSocket := CLR_CreateObject(asm, "OBSWebsocketDotNet.OBSWebSocket")
            ; OBS.WebSocket.WSTimeout(10) ; Doesn't work because fuck knows
            OBS.WebSocket.Connect("ws://127.0.0.1:4444", "webpleb")
        }
        Return OBS.WebSocket
    }
}