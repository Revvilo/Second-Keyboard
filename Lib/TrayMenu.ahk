Class TrayMenu {
    Class Names {
        Static MainHotkeys := "Enable Main Keyboard Binds"
        Static ToggleDebug := "Toggle Debug Mode"
        Static Reload := "Reload Script"
        Static CycleMode := "Cycle Mode"
        Static Open := "Open"
        Static Exit := "Exit"
    }

    Reload() {
        Reload
    }

    ToggleMainHotkeys() {
        If (mainKeyboardHotkeys) {
            mainKeyboardHotkeys := False
            Menu, Tray, Uncheck, %tray_mainHotkeysName%
            SoundPlay, % sounds.disconnected
        } Else {
            mainKeyboardHotkeys := True
            Menu, Tray, Check, %tray_mainHotkeysName%
            SoundPlay, % Sounds.connected
        }
    }

    CycleMode() {
        ModeHandler.Cycle()
    }

    ListLines() {
        ListLines
    }

    ToggleDebug() {
        ToggleDebug()
    }

    Exit() {
        ExitApp
    }
}