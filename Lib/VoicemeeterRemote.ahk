class VoicemeeterRemote {
    static IsInitialised := False
    static mModule
    static mFunctions := {}
    static mDLLDrive := "C:"
    static mDLLPath := "Program Files (x86)\VB\Voicemeeter"
    static mDLLFilename32 := "VoicemeeterRemote.dll"
    static mDLLFilename64 := "VoicemeeterRemote64.dll"

    static mDLLFullPath := VoicemeeterRemote.mDLLDrive . "\" . VoicemeeterRemote.mDLLPath . "\"

    SetStripGain(ByRef StripIndex, ByRef Gain) {
        VoicemeeterRemote.Init()
        ; DllCall(VoicemeeterRemote.mFunctions["SetParameterFloat"], "AStr", Format("Strip[{}].gain", StripIndex), "Float", Gain, "Int")
        DllCall(VoicemeeterRemote.mFunctions["SetParameters"], "AStr", Format("Strip[{}].gain = {}", StripIndex, Gain))
    }

    ChangeStripGain(ByRef StripIndex, ByRef Gain) {
        VoicemeeterRemote.Init()
        ; If (Gain > 0) {
            DllCall(VoicemeeterRemote.mFunctions["SetParameters"], "AStr", Format("Strip[{}].gain += {}", StripIndex, Gain))
        ; } Else {
        ;     DllCall(VoicemeeterRemote.mFunctions["SetParameters"], "AStr", Format("Strip[{}].gain -= {}", StripIndex, Gain))
        ; }
    }

    Login() {
        return DllCall(VoicemeeterRemote.mFunctions["Login"], "Int")
    }

    Init() {
        If (Not VoicemeeterRemote.IsInitialised)
        {
            DebugMessage("Attempting to initialise and log in VoicemeeterRemote from Second Keyboard...")
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
                VoicemeeterRemote.Die("Attempt to load VoiceMeeter Remote DLL failed.")

            ; Populate VoicemeeterRemote.mFunctions
            VoicemeeterRemote.AddFunction("Login")
            VoicemeeterRemote.AddFunction("Logout")
            VoicemeeterRemote.AddFunction("SetParameterFloat")
            VoicemeeterRemote.AddFunction("SetParameters")

            ; "Login" to Voicemeeter, by calling the function in the DLL named 'VBVMR_Login()'...
            login_result := VoicemeeterRemote.Login()
            if (ErrorLevel || login_result < 0)
                VoicemeeterRemote.Die("VoiceMeeter Remote login failed: " . ErrorLevel)

            DebugMessage("`tVoicemeeterRemote Successfully Initialised and logged in.")
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

    ExitCleanup(exit_reason, exit_code) {
        DllCall(VoicemeeterRemote.mFunctions["Logout"], "Int")
        ; OnExit functions must return 0 to allow the app to exit.
        return 0
    }

    Die(Die_string:="UNSPECIFIED FATAL ERROR.", exit_status:=254) {
        MsgBox 16, FATAL ERROR, %Die_string%
    }
}