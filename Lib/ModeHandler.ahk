; Mode change handling
Class ModeHandler
{
    Static ModeList
    Static ModeIndex
    Static CurrentMode

    Cycle() {
        ModeHandler.Mode++
    }

    Mode {
        get {
            Return ModeHandler.CurrentMode
        }

        ; TODO: This seriously needs optimising. Like really. I just made it "work" when I changed from a monolithic system.
        set {
            DebugMessage("Requested Mode: " . value)

            If ((value is integer) && (value > 0)) { ; If value is an integer that is above 0: set CurrentMode to that mode out of the list
                this.ModeIndex := value
                this.CurrentMode := this.ModeList[this.ModeIndex]
                SoundPlay, % Sounds[this.CurrentMode], Wait
            } Else { ; Otherwise just cycle it through
                If (this.CurrentMode == "") { ; Failsafe for in case CurrentMode isn't set yet
                    this.ModeIndex := 1
                    this.CurrentMode := this.ModeList[this.ModeIndex]
                } Else {
                    If (this.ModeIndex >= this.ModeList.MaxIndex()) { ; If at the end of the list of modes, go back to the start
                        this.ModeIndex := 1
                        this.CurrentMode := this.ModeList[this.ModeIndex]
                    } Else { ; Otherwise cycle by one
                        this.ModeIndex++
                        this.CurrentMode := this.ModeList[this.ModeIndex]
                    }
                }
                SoundPlay, % Sounds[this.CurrentMode]
            }
        }
    }
}
