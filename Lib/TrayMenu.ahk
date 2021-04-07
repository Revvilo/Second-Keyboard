Class TrayMenu {
    Class Names {
        Static EnableListLines := "Enable List Lines"
        Static ToggleDebug := "Toggle Debug Mode"
        Static Reload := "Reload Script"
        Static Open := "Open"
        Static Exit := "Exit"
    }

    Reload() {
        Reload
    }

    ToggleMainHotkeys() {
        If (mainKeyboardHotkeys) {
            mainKeyboardHotkeys := False
            Menu, Tray, Uncheck, % TrayMenu.Names.MainHotkeys
            SoundPlay, % sounds.disconnected
        } Else {
            mainKeyboardHotkeys := True
            Menu, Tray, Check, % TrayMenu.Names.MainHotkeys
            SoundPlay, % Sounds.connected
        }
    }

    ; Unused
    EnableListLines() {
        If (A_ListLines) {
            Menu, Tray, Uncheck, % TrayMenu.Names.EnableListLines
            ListLines, Off
            SoundPlay, % sounds.disconnected
        } Else {
            Menu, Tray, Check, % TrayMenu.Names.EnableListLines
            ListLines, On
            SoundPlay, % Sounds.connected
        }
    }

    CycleMode() {
        ModeHandler.Cycle()
    }

    ListLines() {
        ListLines
    }

    Exit() {
        ExitApp
    }
}