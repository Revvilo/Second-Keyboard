#If mainKeyboardHotkeys 

#IfWinActive, Voltz
~$^w::
    SendInput, {w down}
    sleep 100
    SendInput {w up}
    Sleep 50
    SendInput, {w down}
    KeyWait, w
    SendInput, {w up}
Return

#IfWinActive, ahk_exe Resolve.exe
*XButton1::
    If(GetKeyState("LShift")) {
        SendInput, ^+]
        Return
    }
    SendInput, ^+[
Return
#IfWinActive, Minecraft
*XButton1::
    ToggleTimer("AutoClicker")
Return
*XButton1 UP::
    ToggleTimer("AutoClicker")
Return

#IfWinActive Valheim
E::
    SendInput, e
    KeyWait, e, t0.25
    If(ErrorLevel == 0)
        return
    While GetKeyState("e", "P") {
        SendInput, e
        Sleep, 40
    }
Return

#IfWinActive, ahk_exe FactoryGame-Win64-Shipping.exe
*XButton1::
    ToggleTimer("Autoattack")
Return
*XButton1 UP::
    ToggleTimer("Autoattack")
Return
*XButton2::
    SendInput, {LControl down}
    SendInput, {Sleep 5000}
    SendInput, {LControl up}
Return

#IfWinActive Risk
*XButton1::
    Sendinput, {Click Down}
    Sendinput, {r Down}
Return
*XButton1 UP::
    Sendinput, {Click Up}
    Sendinput, {r Up}
Return