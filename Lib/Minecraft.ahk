Class Minecraft {
    ; -- Required funcs
    SendCommand(param)
    {
        SetKeyDelay,, 2
        Sendinput, t
        Sleep, 100
        Sendinput, %param%
        Sendinput, {Enter}
        SetKeyDelay,,
    }

    ; -- Niche funcs
    FoolCraft_PatternTransfer() {
        MouseGetPos, mouseX, mouseY
        MouseMove, 729, 659, 0
        MouseClick, Left
        MouseMove, %mouseX%, %mouseY%
        MouseClick, Left
    }

    AutoFishing() {
        FishDetected := False
        IfWinActive, Minecraft
        {
            WinGet, mcInstances, List, Minecraft
            Loop %mcInstances% {
                mcInstanceID := mcInstances%A_Index%

                ; WinActivate, ahk_id %mcInstanceID%

                WinGetPos, X, Y, Width, Height, ahk_id %mcInstanceID%
                X1 := Width / 2 - 50 + X
                Y1 := Height / 2 - 10 + Y
                X2 := Width / 2 + 50 + X
                Y2 := Height / 2 + 60 + Y

                ; ToolTip, ., % X1, % Y1
                ; Sleep, 50
                ; ToolTip, ., % X2, % Y2
                ; ToolTip, % Format("{}`n{}`n{}`n{}`n`n{}`n{}`n{}`n{}", X, Y, Width, Height, X1, Y1, X2, Y2), 500, 500

                ; 50F6FC
                PixelSearch, OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, FF0000, 1, Fast
                ; 51F9FF
                If (ErrorLevel == 1) {
                    ; SoundPlay, % Sounds.Disconnected, wait
                    ControlClick,, ahk_id %mcInstanceID%,, Right
                    ; Random, rand, 50, 150
                    Sleep, %rand%
                    ControlClick,, ahk_id %mcInstanceID%,, Right
                    FishDetected := True
                } Else If (ErrorLevel == 2) {
                    SoundPlay, Sounds.Asterisk, wait
                }
            }
            If (FishDetected)
                Sleep, 100
            ; Sleep, 50
        } Else {
            ToggleTimer("AutoFishing")
        }
    }

    Vanilla_Autocraft() {
        SendInput, {Shift down}
        ; Sleep, 10
        MouseClick, Left, 549, 417
        ; Sleep, 75
        MouseClick, Left, 1321, 420
        ; Sleep, 10
        ; SendInput, {Shift up}
    }

    Vanilla_Plankcraft() {
        SendInput, {Shift down}
        MouseClick, Left, 549, 417
        MouseClick, Left, 1321, 420
        ; Sleep, 1000
        PosX := 1137
        PosY := 741
        Sleep, 300
        Loop 4 {
            MouseMove, %PosX%, %PosY%
            SendInput, {Control down}
            SendInput, q
            Sleep 50
            PosX += 54
            ; Sleep, 1000
        }
        ; Sleep, 1000
    }

    FoolCraft_PrismCraft() {
        SetBatchLines, 1
        
        MouseMove, 969, 404, 0
        SendInput, 6
            Sleep, 10
        MouseMove, 961, 455, 0
        SendInput, 5
        SendInput, e
            Sleep, 100
        SendInput, 4
            Sleep, 50
        SendInput, {Click Right}

        ;     Sleep, 100
        SendInput, 5
        ; MouseMoveMouseMove(-2100, -350)
        SendInput, {Click Right}
        ;     Sleep, 50
        ; MouseMoveMouseMove(2100, 350)
        ; SendInput, {Click Right}

        SetBatchLines -1
    }

    MouseMove(moveX, moveY) {
        oldBatchLines := A_BatchLines
        SetBatchLines, -1

        amtX := Ceil(Abs(moveX) / 500)
        Loop, % amtX
        {
            MouseMove, % moveX / amtX, 0, 0, R
            Sleep, 1
        }

        amtY := Ceil(Abs(moveY) / 250)
        Loop, % amtY
        {
            MouseMove, 0, % moveY / amtY, 0, R
            Sleep, 1
        }

        SetBatchLines, %oldBatchLines%
    }


    ; -- TIMERS FOR USE WITH ToggleTimer
    ; FORMAT: GameName_WhateverTheTimerIsOrDoes
    ; Underscores separate game names from other naming.
    ; Example: MouseMovePO2_SieveSpin - for minecraft's project ozone 2 modpack.

    MouseMovePO2_SieveSpin() {
        MouseGetPos, mouseX, mouseY
        MouseMove, mouseX + 100, mouseY
    }

    Sevtech_Stirring() {
        ControlSend,, 6, Minecraft
        Sleep, 50
        ControlSend,, {' down}, Minecraft
        Sleep, 50
        ControlSend,, {' up}, Minecraft
        Sleep, 50
        ControlSend,, 5, Minecraft
        Loop, 5 {
            Sleep, 50
            ControlSend,, {' down}, Minecraft
            Sleep, 50
            ControlSend,, {' up}, Minecraft
        }
        Sleep, 50
        ControlSend,, 4, Minecraft
        Sleep, 50
        ControlSend,, {' down}, Minecraft
        Sleep, 5000
        ControlSend,, {' up}, Minecraft
        Sleep, 2500
    }

    SevTech_Hammer() {
        ControlSend,, 6, Minecraft
        Sleep, 50
        ControlClick,, Minecraft,, Right
        Sleep, 50
        ControlSend,, 5, Minecraft
        Sleep, 50
        ControlClick,, Minecraft,, Right, 4
        Sleep, 50
    }

    SevTech_PickaxeLevel() {
        ControlSend,, 4, Minecraft
        ControlClick,, Minecraft,, Right
        Sleep, 100
        ControlSend,, 2, Minecraft
        Sleep, 50
        ControlClick,, Minecraft,, Left
        Sleep, 60
    }


}