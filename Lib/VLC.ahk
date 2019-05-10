class VLC {
    PlayTrack(trackName) {
        If (!this.DoesVLCExist())
            Return
        ControlSend,, %trackName%, VLC media player
        ControlSend,, {Enter}, VLC media player
    }

    Stop() {
        If (!this.DoesVLCExist())
            Return
        ControlSend,, s, VLC media player
    }

    DoesVLCExist() {
        IfWinExist, VLC media player
            Return True
        Else
            Return False
    }
}