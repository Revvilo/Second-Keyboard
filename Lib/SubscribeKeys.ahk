; #Include KEYBIND TEMPLATE.ahk

; -- Subscribes all keys to the keyboard's respective predicate function
SubscribeAllKeys() {
    ; outputArray := []
    ; For each keyboard that is wanted to be a macro board
    For deviceName, deviceHandle in MacroKeyboards {
        Try {
            deviceID := AHI.GetKeyboardIdFromHandle(deviceHandle)
        } Catch e {
            ; Msgbox, % "Device " deviceHandle " not found. `nCannot subscribe keys. Will skip device..."
            Continue
        }
        If (deviceName)
        Loop 512 {
            ; TODO: Make system for allocating an entire keyboard to be a pedal. Needs a way to check if the "pedal" is held
            ; TODO: Check each key to see if it is an exception in a list stored within the device's class
            code := Format("{:x}", A_Index)
            name := GetKeyName("sc" code)

            If (name != "") {
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

