/*
KeyList := [  "Escape", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "PrintScreen", "ScrollLock", "Pause"
            , "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "Backspace", "Insert", "Home", "PageUp"
            , "Tab", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "Delete", "End", "PageDown"
            , "Capslock", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Enter"
            , "Shift", "Z", "X", "C", "V", "B", "N", "M"
            , "LWin", "Spacebar", "RWin", "AppsKey"

            ; -- Numpad + arrow controls
            , "NumpadDot", "NumpadDel", "NumpadDiv", "NumpadMult", "NumpadAdd", "NumpadSub", "NumpadEnter"
            , "Numpad0", "Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9"
            , "Right", "Left", "Up", "Down" ]

; -- Loop through KeyList and subscribe them.
For Key, Val in KeyList {
    Try {
        AHI.SubscribeKey(secondKeyboardID, GetKeySC(Val), true, Func(Val))
        ; fn := Func("GlobalBsinds."Val)
        ; Msgbox % "Func(" . Val . ")`n" . fn.Name . "`nExists: " . Func("this."Val)
    } Catch, e {
        MsgBox, % "Error while subscribing keys", % "Iteration: " . key . "`nKey: " . Val . "`n`nError:`n" . e
    }
}

; -- Below are all the keys that need custom subscriptions to call a correct callback.
AHI.SubscribeKey(secondKeyboardID, GetKeySC("/"), true, Func("ForwardSlash")) ; /
AHI.SubscribeKey(secondKeyboardID, GetKeySC("'"), true, Func("Apostrophe")) ; '
AHI.SubscribeKey(secondKeyboardID, GetKeySC(";"), true, Func("Semicolon")) ; ;
AHI.SubscribeKey(secondKeyboardID, GetKeySC(","), true, Func("Comma")) ; ,
AHI.SubscribeKey(secondKeyboardID, GetKeySC("."), true, Func("Dot")) ; .
AHI.SubscribeKey(secondKeyboardID, GetKeySC("-"), true, Func("Minus")) ; -
AHI.SubscribeKey(secondKeyboardID, GetKeySC("="), true, Func("Equals")) ; =
AHI.SubscribeKey(secondKeyboardID, GetKeySC("``"), true, Func("Tilde")) ; `
AHI.SubscribeKey(secondKeyboardID, 69, true, Func("NumLock")) ; -- NUMLOCK
AHI.SubscribeKey(secondKeyboardID, GetKeySC("["), true, Func("RightBracket")) ; [
AHI.SubscribeKey(secondKeyboardID, GetKeySC("]"), true, Func("LeftBracket")) ; ]
AHI.SubscribeKey(secondKeyboardID, GetKeySC("\"), true, Func("Backslash")) ; \
*/

; #Include KEYBIND TEMPLATE.ahk

; -- Subscribes all keys to the keyboard's respective predicate function
SubscribeAllKeys() {
    ; outputArray := []
    ; For each keyboard that is wanted to be a macro board
    For deviceName, deviceHandle in MacroKeyboards {
        deviceID := AHI.GetKeyboardIdFromHandle(deviceHandle)
        Loop 512 {
            code := Format("{:x}", A_Index)
            name := GetKeyName("sc" code)


            If (name != "" && code != 41) {
            ;     If (!outputArray.HasKey(name))
            ;         outputArray.Push(name)

                callback := Func("MacroBroker").Bind(deviceName, code, name, skipKeyUp := True)
                AHI.SubscribeKey(deviceID, A_Index, true, callback)
            }
        }
    }
    OutputDebug, Finished subscribing all keys.
    ; For Key, Val in outputArray {
    ;     outputString := val . " " . outputString
    ; }
    ; msgbox %outputString%
}

