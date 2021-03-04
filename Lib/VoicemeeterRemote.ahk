class VoicemeeterRemote {
    static IsInitialised := False
    static HeaderHWND
    static MessageHWND
    static mModule
    static prevVol
    static mFunctions := {}
    static mDLLDrive := "C:"
    static mDLLPath := "Program Files (x86)\VB\Voicemeeter"
    static mDLLFilename32 := "VoicemeeterRemote.dll"
    static mDLLFilename64 := "VoicemeeterRemote64.dll"
    static Strips := {"Mic" : 0, "Spotify" : 5, "Discord": 6, "Browser": 7}

    static mDLLFullPath := VoicemeeterRemote.mDLLDrive . "\" . VoicemeeterRemote.mDLLPath . "\"

    StandardVolumeControl(ByRef Modifiers, ByRef Strip, ByRef IncreaseDecrease) {
        If (Modifiers.IsPressed()) {
            If (IncreaseDecrease) {
                VoicemeeterRemote.ChangeStripGain(Strip, 1)
            } Else {
                VoicemeeterRemote.ChangeStripGain(Strip, -1)
            }

        } Else If (Modifiers.IsPressed("Shift")) {
            If (IncreaseDecrease) {
                VoicemeeterRemote.ChangeStripGain(Strip, 5)
            } Else {
                VoicemeeterRemote.ChangeStripGain(Strip, -5)
            }

        } Else If (Modifiers.IsPressed("Control", "Shift")) {
            If (IncreaseDecrease) {
                VoicemeeterRemote.FadeStripTo(Strip, 0)
            } Else {
                VoicemeeterRemote.FadeStripTo(Strip, -35)
            }
        
        } Else If (Modifiers.IsPressed("Control")) {
            If (IncreaseDecrease) {
                VoicemeeterRemote.FadeStripTo(Strip, -10)
            } Else {
                VoicemeeterRemote.FadeStripTo(Strip, -25)
            }
        }
    }

    ToggleDim(ByRef StripIndex) {
        ; If(This.GetStripGain(StripIndex) < )
    }

    SetStripGain(ByRef StripIndex, ByRef Gain) {
        This.SendScript(Format("Strip[{}].gain = {}", StripIndex, Gain))
    }

    ChangeStripGain(ByRef StripIndex, ByRef Gain) {
        ; Supports negative values due to adding a negative number being the same as subtraction
        This.SendScript(Format("Strip[{}].gain += {}", StripIndex, Gain))
        Sleep, 100
        This.ShowStripGain(StripIndex, "")
    }

    FadeStripTo(ByRef StripIndex, ByRef TargetGain, ByRef FadeTime := 100) {
        This.SendScript(Format("Strip[{}].FadeTo = ({}, {})", StripIndex, TargetGain, FadeTime))
        Sleep, % Fadetime + 50
        This.ShowStripGain(StripIndex, "")
    }

    GetStripGain(ByRef StripIndex) {
        outputGain := ""
        ; I call this twice because it doesn't work consistently if only called once. I've yet to work that one out.
        DllCall(VoicemeeterRemote.mFunctions["IsParametersDirty"], "Int")
        DllCall(VoicemeeterRemote.mFunctions["IsParametersDirty"], "Int")
        DllCall(VoicemeeterRemote.mFunctions["GetParameterFloat"], "AStr", Format("Strip[{}].gain", StripIndex), "Float*", outputGain)
        Return outputGain
    }

    ShowStripGain(ByRef StripIndex, ByRef Message, ByRef DisplayGainOverride := "") {
        Return ; TODO: FIX THIS
        If !(DisplayGainOverride is Float)
            Gain := VoicemeeterRemote.GetStripGain(StripIndex)
        Else
            Gain := DisplayGainOverride
        VoicemeeterRemote.UpdateNotificationWindow(">> " . Gain, Format("Strip {} Gain", StripIndex))
    }

    BuildNotificationWindow(ByRef Header, ByRef Message) {
        Gui VMRNotificationWindow:+LastFoundExist
        SysGet, OutputVar, Monitor, 2
        Width := 400
        Height := 180
        Padding := 5
        PosX := OutputVarLeft + Padding
        PosY := OutputVarBottom - Height - Padding - 30
        
        Gui VMRNotificationWindow:New ; TODO: see if there's a way to update all the controls on the window without re-creating it (which makes it flash)
        If(!WinExist()) {
            Gui, Show, W%Width% H%Height% X%PosX% Y%PosY% NA
            Gui -caption +LastFound
        }
        ; WinSet, TransColor, f0f0f0
        ; WinSet, Trans, 100
        ; Gui, Color, EEAA99
        Gui VMRNotificationWindow:+AlwaysOnTop
        Gui, VMRNotificationWindow:Font, s20, Roboto
        Gui, VMRNotificationWindow:Add, Text, w300 hwndOutHeaderHWND
        Gui, VMRNotificationWindow:Font, s15, Rubik
        Gui, VMRNotificationWindow:Add, Text, w300 hwndOutMessageHWND
        ; WinGet GUI_ID, ID
        This.MessageHWND := OutMessageHWND
        This.HeaderHWND := OutHeaderHWND
    }

    ToggleNotificationWindow() {
        If(!WinExist()) {
            This.BuildNotificationWindow(Header, Message)
        } Else {
            Misc.FadeOutWindow(WinExist(), 100)
            Gui, Destroy
        }
    }

    UpdateNotificationWindow(ByRef Header, ByRef Message) {
        SetTimer, FadeOutWindow, Off
        Gui VMRNotificationWindow:+LastFoundExist
        If(!WinExist()) {
            This.BuildNotificationWindow(Header, Message)
        }
        GuiControl, Text, % This.HeaderHWND, % Header
        GuiControl, Text, % This.MessageHWND, % Message
        SetTimer, FadeOutWindow, -1
        Return
        
        FadeOutWindow:
            Misc.FadeOutWindowAfter(WinExist(), 5000, 1000)
            Gui, Destroy
        Return
    }

    PlayFile(ByRef Filepath) {
        This.SendScript(Format("recorder.load=""{}""", Filepath))
    }

    PlayRecorder() {
        This.SendScript("recorder.play=1")
    }

    StopPlayback() {
        This.SendScript("recorder.stop=1")
        This.SendScript("recorder.release")
    }

    SetPlaybackGain(ByRef Gain) {
        This.SendScript("recorder.gain=" . Gain)
    }

    ChangePlaybackGain(ByRef Change) {
        This.SendScript("recorder.gain += " . Change)
    }

    ZeroStripEQ(ByRef StripIndex) {
        This.SetStripEQ(StripIndex, 0, 0, 0)
    }

    SetStripEQ(ByRef StripIndex, ByRef Frequency*) {
        Loop, 3 {
            This.SendScript(Format("Strip[{}].eqgain{} = {}", StripIndex, Abs(A_Index - 4), Frequency[A_Index]))
            ; Abs(A_Index - 4) is a hacky... ish... solution to flip the order in which the parameters equate to the dials in Voicemeeter
        }
    }

    GetParameterFloat(ByRef Parameter) {
        VoicemeeterRemote.Init()
        returnValue := 0
        DllCall(VoicemeeterRemote.mFunctions["IsParametersDirty"], "Int")
        DllCall(VoicemeeterRemote.mFunctions["GetParameterFloat"], "AStr", Parameter, "Float*", returnValue)
        return returnValue
    }

    ToggleStripOutput(ByRef Strip, ByRef Output) {
        VoicemeeterRemote.Init()

        returnValue := 0
        parameter := "Strip[" . Strip . "]." . Output
        DllCall(VoicemeeterRemote.mFunctions["IsParametersDirty"], "Int")
        DllCall(VoicemeeterRemote.mFunctions["IsParametersDirty"], "Int")
        DllCall(VoicemeeterRemote.mFunctions["GetParameterFloat"], "AStr", parameter, "Float*", returnValue)
        DllCall(VoicemeeterRemote.mFunctions["SetParameterFloat"], "AStr", parameter, "Float", returnValue > 0 ? 0 : 1)
    }

    SendScript(ByRef ScriptString) {
        VoicemeeterRemote.Init()
        DllCall(VoicemeeterRemote.mFunctions["SetParameters"], "AStr", ScriptString)
    }

    Login() {
        Return DllCall(VoicemeeterRemote.mFunctions["Login"], "Int")
    }

    Init() {
        If (Not VoicemeeterRemote.IsInitialised)
        {
            DebugMessage("[VoicemeeterRemote Lib] Attempting to initialise and login...")
            VoicemeeterRemote.IsInitialised := True

            if (A_Is64bitOS) {
                VoicemeeterRemote.mDLLFullPath .= VoicemeeterRemote.mDLLFilename64
            } else {
                VoicemeeterRemote.mDLLFullPath .= VoicemeeterRemote.mDLLFilename32
            }

            ; Load the VoicemeeterRemote DLL:
            ; This returns a module handle
            VoicemeeterRemote.mModule := DllCall("LoadLibrary", "Str", VoicemeeterRemote.mDLLFullPath, "Ptr")
            if (ErrorLevel || VoicemeeterRemote.mModule == 0)
                VoicemeeterRemote.Die("`tAttempt to load VoicemeeterRemote DLL failed.")

            ; Populate VoicemeeterRemote.mFunctions
            VoicemeeterRemote.AddFunction("Login")
            VoicemeeterRemote.AddFunction("Logout")
            VoicemeeterRemote.AddFunction("SetParameterFloat")
            VoicemeeterRemote.AddFunction("GetParameterFloat") ; Causes all kinds of buggy stuff
            VoicemeeterRemote.AddFunction("SetParameters")
            VoicemeeterRemote.AddFunction("IsParametersDirty")

            ; "Login" to Voicemeeter, by calling the function in the DLL named 'VBVMR_Login()'...
            login_result := VoicemeeterRemote.Login()
            if (ErrorLevel || login_result < 0)
                VoicemeeterRemote.Die("VoiceMeeter Remote login failed: " . ErrorLevel)

            DebugMessage("`tVoicemeeterRemote successfully initialised and logged in.")
        }
    }

    ; == Functions ==
    ; ===============

    ; Redundant PTT functions
    ; ptt_on() {
    ;     DllCall(VoicemeeterRemote.mFunctions["SetParameterFloat"], "AStr", "Strip[0].B1", "Float", 1.0, "Int")
    ;     DllCall(VoicemeeterRemote.mFunctions["SetParameterFloat"], "AStr", "Strip[0].B2", "Float", 1.0, "Int")
    ; }

    ; ptt_off() {
    ;     DllCall(VoicemeeterRemote.mFunctions["SetParameterFloat"], "AStr", "Strip[0].B1", "Float", 0.0, "Int")
    ;     DllCall(VoicemeeterRemote.mFunctions["SetParameterFloat"], "AStr", "Strip[0].B2", "Float", 0.0, "Int")
    ; }

    AddFunction(func_name) {
        VoicemeeterRemote.mFunctions[func_name] := DllCall("GetProcAddress", "Ptr", VoicemeeterRemote.mModule, "AStr", "VBVMR_" . func_name, "Ptr")
        if (ErrorLevel || VoicemeeterRemote.mFunctions[func_name] == 0)
            VoicemeeterRemote.Die("Failed to register VMR function " . func_name . ".")
    }

    ExitCleanup() {
        If (!VoicemeeterRemote.IsInitialised)
            Return
        VoicemeeterRemote.IsInitialised := False
        DllCall(VoicemeeterRemote.mFunctions["Logout"], "Int", 0)
    }

    Die(Die_string:="UNSPECIFIED FATAL ERROR.", exit_status:=254) {
        MsgBox 16, FATAL ERROR, %Die_string%
    }
}