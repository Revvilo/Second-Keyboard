Class KEYBINDSTEMPLATE {

    ; List of keys that will be considered modifiers instead of hotkeys along with their respective aliases to use when retreiving modifiers. Eg { "RAlt": "Alt" } - 'RAlt' becomes 'Alt'
    Static modifierKeys := { "LControl": "Control"
                    , "RControl": "Control"
                    , "LShift": "Shift"
                    , "RShift": "Shift"
                    , "LAlt": "Alt"
                    , "RAlt": "Alt"
                    ; , "NumpadSub": "NumpadSub" ; This is an example of a key that isn't normally considered a modifier. I use this as a "shift" or "control" for the numpad.
                    , "LWin": "WinKey"
                    , "RWin": "WinKey" }

    F1() {
    }
    F2() {
    }
    F3() {
    }
    F4() {
    }
    F5() {
    }
    F6() {
    }
    F7() {
    }
    F8() {
    }
    F9() {
    }
    F10() {
    }
    F11() {
    }
    F12() {
    }


    1() {
    }
    2() {
    }
    3() {
    }
    4() {
    }
    5() {
    }
    6() {
    }
    7() {
    }
    8() {
    }
    9() {
    }
    0() {
    }


    A() {
    }
    B() {
    }
    C() {
    }
    D() {
    }
    E() {
    }
    F() {
    }
    G() {
    }
    H() {
    }
    I() {
    }
    J() {
    }
    K() {
    }
    L() {
    }
    M() {
    }
    N() {
    }
    O() {
    }
    P() {
    }
    Q() {
    }
    R() {
    }
    S() {
    }
    T() {
    }
    U() {
    }
    V() {
    }
    W() {
    }
    X() {
    }
    Y() {
    }
    Z() {
    }


    Left() {
    }
    Right() {
    }
    Up() {
    }
    Down() {
    }


    Tab() {
    }
    Escape() {
    }
    Tilde() {
    }
    Spacebar() {
    }
    Enter() {
    }
    RightBracket() {
    }
    LeftBracket() {
    }
    BackSlash() {
    }
    ForwardSlash() {
    }
    Backspace() {
    }
    Minus() {
    }
    Equals() {
    }


    Insert() {
    }
    Delete() {
    }
    Home() {
    }
    End() {
    }
    PrtScr() {
    }
    ScrollLock() {
    }
    Pause() {
    }
    PgUp() {
    }
    PgDn() {
    }


    AppsKey() {
    }
    Apostrophe() {
    }
    Semicolon() {
    }
    Comma() {
    }
    Dot() {
    }


    NumpadIns() {
    }
    NumpadEnd() {
    }
    NumpadDown() {
    }
    NumpadPgDn() {
    }
    NumpadLeft() {
    }
    NumpadClear() {
    }
    NumpadRight() {
    }
    NumpadHome() {
    }
    NumpadUp() {
    }
    NumpadPgUp() {
    }
    NumpadAdd() {
    }
    NumpadDiv() {
    }
    NumpadMult() {
    }
    NumpadDel() {
    }
    NumpadEnter() {
    }


    ; Numlock and Pause\Break both trigger as "Pause". God knows why. Go find Pause() instead if you want to bind Numlock.

    ; NumLock() {
    ; }


    ; Below are keys that are used for modifiers and won't function unless you remove them from the modifier list.

    LWin() {
    }
    RWin() {
    }
    LControl() {
    }
    RControl() {
    }
    LShift() {
    }
    RShift() {
    }
    LAlt() {
    }
    RAlt() {
    }
    NumpadSub() {
    }
}