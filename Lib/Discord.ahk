class Discord {
    ToggleDeafen() {
        SendInput, !{F19} ; -- Toggle Discord deafen
    }

    ToggleMute() {
        SendInput, !{F20} ; -- Toggle Discord mic
    }

    TypeMessage(message) {
        ControlSend,, %message%, ahk_exe Discord.exe
    }

    TypeAndSendMessage(message) {
        This.TypeMessage(message)
        This.TypeMessage("{enter}")
        ; ControlSend,, {enter}, ahk_exe Discord.exe
    }
}