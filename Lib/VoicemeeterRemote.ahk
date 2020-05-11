class VoicemeeterRemote {
    static IsInitialised := False
    static mModule
    static mFunctions := {}
    static mDLLDrive := "C:"
    static mDLLPath := "Program Files (x86)\VB\Voicemeeter"
    static mDLLFilename32 := "VoicemeeterRemote.dll"
    static mDLLFilename64 := "VoicemeeterRemote64.dll"
    static strips := {"Spotify" : "5", "Mic" : "0"}

    static mDLLFullPath := VoicemeeterRemote.mDLLDrive . "\" . VoicemeeterRemote.mDLLPath . "\"

    SetStripGain(ByRef StripIndex, ByRef Gain) {
        This.SendScript(Format("Strip[{}].gain = {}", StripIndex, Gain))
    }

    PlayFile(ByRef Filepath) {
        This.SendScript(Format("recorder.load=""{}""", Filepath))
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

    ChangeStripGain(ByRef StripIndex, ByRef Gain) {
        ; Supports negative values due to adding a negative number being the same as subtraction
        This.SendScript(Format("Strip[{}].gain += {}", StripIndex, Gain))
    }

    FadeStripTo(ByRef StripIndex, ByRef TargetGain, ByRef FadeTime) {
        This.SendScript(Format("Strip[{}].FadeTo = ({}, {})", StripIndex, TargetGain, FadeTime))
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
            ; VoicemeeterRemote.AddFunction("GetParameterFloat") ; Causes all kinds of buggy stuff
            VoicemeeterRemote.AddFunction("SetParameters")

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