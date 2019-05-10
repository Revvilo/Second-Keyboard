Class Minecraft {
    Tab() {
        Msgbox, Minecraf Tab callback was triggered
    }
; If (WinActive("Minecraft")) {
;     If (key == "control+comma") {
;         SendMCCommand("/gamemode s")
;     } Else If (key == "l") {
;         MouseGetPos, OldMouseX, OldMouseY
;         MouseClick, Left, 1194, 466
;         MouseMove, % OldMouseX, % OldMouseY + 49
;         MouseClick, Left
;     } Else If (key == "control+l") {
;         MouseGetPos, OldMouseX, OldMouseY
;         MouseClick, Left, 907, 401
;         MouseMove, %OldMouseX%, %OldMouseY%
;     } Else If (key == "control+shift+l") {
;         MouseGetPos, OldMouseX, OldMouseY
;         MouseClick, Left, 1000, 401
;         MouseMove, %OldMouseX%, %OldMouseY%
;     } Else If (key == "alt+l") {
;         MouseGetPos, OldMouseX, OldMouseY
;         MouseClick, Left, 1092, 448
;         SendInput, 1
;         MouseMove, %OldMouseX%, %OldMouseY%
;     } Else If (key == "control+alt+l") {
;         MouseGetPos, OldMouseX, OldMouseY
;         MouseClick, Left, 1022, 448
;         SendInput, 1
;         MouseMove, %OldMouseX%, %OldMouseY%
;     } Else If (RegExMatch(key, "num.")) {
;         key_number := StrSplit(key, "num")[2]
;         If (not key_number > CommandList.MaxIndex()) {
;             SendMCCommand(CommandList[key_number])
;         }
;     } Else If (key == "control+p") {
;         FoolCraft_PrismCraft()
;     } Else If (key == "j") {
;         FoolCraft_PatternTransfer()
;     } Else If (key == "control+period") {
;         SendMCCommand("/gamemode c")
;     } Else If (key == "control+shift+s") {
;         ToggleTimer("Minecraft_PO2_SieveSpin")
;     } Else If (key == "h") {
;         InputBox, hammerAmt, Sevtech Hammering Macro, Place the item to hammer in slot 6`nAnd place the hammer in slot 5`n`nHow many items do you want to hammer?
;         If (ErrorLevel) ; -- Returns if you hit "cancel" on the inputbox
;         Return
;         Sleep, 150
;         Loop, %hammerAmt% {
;             SevTech_Hammer()
;         }
;     } Else If (key == "g") {
;         InputBox, loopAmt, Sevtech Pickaxe Levelling macro, Place the stones in slot 4`nAnd the pickaxe you want to level in slot 2`n`nHow much xp do you want to get?`n(1 Per)
;         If (ErrorLevel) {
;             WinActivate, Minecraft
;             Return
;         }
;         WinActivate, Minecraft
;         Sleep, 150
;         Loop, %loopAmt% {
;             SevTech_PickaxeLevel()
;         }
;     }
; } Else {
;     ; Msgbox, % "Minecraft not active.`n`nCurr. window hwnd: " + WinActive("A")
; }
}