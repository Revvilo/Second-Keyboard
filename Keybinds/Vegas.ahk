Class Vegas {
    #If (WinActive("Video Event FX") and Mode == "Animating")
    {
        Right::
        {
            ControlFocus, SonyCreativeSoftwareInc_TrackView1, Video Event FX
            SendInput, {Right}
        }
        Return
        
        Left::
        {
            ControlFocus, SonyCreativeSoftwareInc_TrackView1, Video Event FX
            SendInput, {Left}
        }
        Return
    }
    Return

    KeyframeLoop:
        {
            ControlFocus, SonyCreativeSoftwareInc_TrackView1, Video Event FX
            ControlFocus, SonyCreativeSoftwareInc_TrackView1, Track Motion - 
            SendInput, {Right}
        }
    Return

    #If Mode == "Animating" && (WinActive("Parent Track Motion") || WinActive("Track Motion - "))
    {
        +Right::
        {
            ControlClick, x205 y114
        }
        Return

        +Left::
        {
            ControlClick, x205 y119
        }
        Return

        +Up::
        {
            ControlClick, x205 y131
        }
        Return

        +Down::
        {
            ControlClick, x205 y136
        }
        Return

        ^Left::
        {
            InputBox, loopAmt, Vegas Animating Assistant, Enter Amount of frames to move BACKWARDS
            Sleep 250
            oldTMM := A_TitleMatchMode
            SetTitleMatchMode, 2        
            ControlFocus, SonyCreativeSoftwareInc_TrackView1, Track Motion

            If (ErrorLevel)
            Return
            Loop, %loopAmt%
            {
                SendInput, {Left}
            }

            SetTitleMatchMode, %A_TitleMatchMode%
        }
        Return

        ^Right::
        {
            InputBox, loopAmt, Vegas Animating Assistant, Enter Amount of frames to move FORWARDS
            Sleep 250
            oldTMM := A_TitleMatchMode
            SetTitleMatchMode, 2
            ControlFocus, SonyCreativeSoftwareInc_TrackView1, Track Motion

            If (ErrorLevel)
            Return
            Loop, %loopAmt%
            {
                SendInput, {Right}
            }

            SetTitleMatchMode, %A_TitleMatchMode%
        }
        Return

        Right::
        {
            oldTMM := A_TitleMatchMode
            SetTitleMatchMode, 2

            ControlFocus, SonyCreativeSoftwareInc_TrackView1, Track Motion
            SendInput, {Right}

            SetTitleMatchMode, %A_TitleMatchMode%
        }
        Return

        Left::
        {
            oldTMM := A_TitleMatchMode
            SetTitleMatchMode, 2

            ControlFocus, SonyCreativeSoftwareInc_TrackView1, Track Motion
            SendInput, {Left}
            
            SetTitleMatchMode, %A_TitleMatchMode%
        }
        Return

        Up::
        {
            ControlClick, x205 y200, Track Motion
        }
        Return

        Down::
        {
            ControlClick, x205 y205, Track Motion
        }
        Return
    }
    Return

    #If (Mode == "Animating" && WinActive("Enter Text For Subtitling"))
    ^Enter::
        VegasGui_Done()
    Return
}