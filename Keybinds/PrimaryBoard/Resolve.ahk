Class Resolve {

    F1(Modifiers) {
    }
    F2(Modifiers) {
    }
    F3(Modifiers) {
    }
    F4(Modifiers) {
    }
    F5(Modifiers) {
    }
    F6(Modifiers) {
    }
    F7(Modifiers) {
    }
    F8(Modifiers) {
    }
    F9(Modifiers) {
    }
    F10(Modifiers) {
    }
    F11(Modifiers) {
    }
    F12(Modifiers) {
    }


    1(Modifiers) {
    }
    2(Modifiers) {
    }
    3(Modifiers) {
    }
    4(Modifiers) {
    }
    5(Modifiers) {
    }
    6(Modifiers) {
    }
    7(Modifiers) {
    }
    8(Modifiers) {
    }
    9(Modifiers) {
    }
    0(Modifiers) {
    }


    A(Modifiers) {
    }
    B(Modifiers) {
    }
    C(Modifiers) {
    }
    D(Modifiers) {
    }
    E(Modifiers) {
    }
    F(Modifiers) {
    }
    G(Modifiers) {
    }
    H(Modifiers) {
    }
    I(Modifiers) {
        SendInput, % "D:\Video\Renders\Intermediary Renders"
    }
    J(Modifiers) {
    }
    K(Modifiers) {
    }
    L(Modifiers) {
    }
    M(Modifiers) {
        SendInput, ^m
        Sleep, 10
        SendInput, Transition
        SendInput, {Enter}
    }
    N(Modifiers) {
    }
    O(Modifiers) {
    }
    P(Modifiers) {
    }
    Q(Modifiers) {
    }
    R(Modifiers) {
    }
    S(Modifiers) {
    }
    T(Modifiers) {
        If (Modifiers.IsPressed("Shift")) {
            SendInput, ^4 ; Focus Timeline
            Sleep, 50
            SendInput, +e
            SendInput, +t
            Sleep, 50
            SendInput, +{Down}
            SendInput, +{Down}
        } Else {
            SendInput, ^4 ; Focus Timeline
            Sleep, 50
            SendInput, +e
            SendInput, +t
            SendInput, {F10}
            Sleep, 50
            SendInput, +{Down}
            SendInput, +{Down}
        }
    }
    U(Modifiers) {
    }
    V(Modifiers) {
    }
    W(Modifiers) {
    }
    X(Modifiers) {
    }
    Y(Modifiers) {
    }
    Z(Modifiers) {
    }


    Left(Modifiers) {
    }
    Right(Modifiers) {
    }
    Up(Modifiers) {
        SendInput, ^4 ; Focus Timeline
            Sleep, 50
        SendInput, +{Up}
    }
    Down(Modifiers) {
        SendInput, ^4 ; Focus Timeline
            Sleep, 50
        SendInput, +{Down}
    }


    Tab(Modifiers) {
    }
    Escape(Modifiers) {
    }
    Tilde(Modifiers) {
    }
    Spacebar(Modifiers) {
    }
    Enter(Modifiers) {
    }
    RightBracket(Modifiers) {
    }
    LeftBracket(Modifiers) {
    }
    BackSlash(Modifiers) {
    }
    ForwardSlash(Modifiers) {
    }
    Backspace(Modifiers) {
    }
    Minus(Modifiers) {
    }
    Equals(Modifiers) {
    }


    Insert(Modifiers) {
    }
    Delete(Modifiers) {
    }
    Home(Modifiers) {
    }
    End(Modifiers) {
    }
    PrtScr(Modifiers) {
    }
    ScrollLock(Modifiers) {
    }
    Pause(Modifiers) {
    }
    PgUp(Modifiers) {
    }
    PgDn(Modifiers) {
    }


    AppsKey(Modifiers) {
    }
    Apostrophe(Modifiers) {
    }
    Semicolon(Modifiers) {
    }
    Comma(Modifiers) {
    }
    Dot(Modifiers) {
    }


    NumpadIns(Modifiers) {
    }
    NumpadEnd(Modifiers) {
    }
    NumpadDown(Modifiers) {
    }
    NumpadPgDn(Modifiers) {
    }
    NumpadLeft(Modifiers) {
    }
    NumpadClear(Modifiers) {
    }
    NumpadRight(Modifiers) {
    }
    NumpadHome(Modifiers) {
    }
    NumpadUp(Modifiers) {
    }
    NumpadPgUp(Modifiers) {
    }
    NumpadAdd(Modifiers) {
    }
    NumpadDiv(Modifiers) {
    }
    NumpadMult(Modifiers) {
    }
    NumpadDel(Modifiers) {
    }
    NumpadEnter(Modifiers) {
    }


    ; Numlock and Pause\Break both trigger as "Pause". God knows why. Go find Pause(Modifiers) instead if you want to bind Numlock.
    ; NumLock(Modifiers) {
    ; }


    ; Below are keys that are used for modifiers and won't function unless you remove them from the modifier list.

    LWin(Modifiers) {
    }
    RWin(Modifiers) {
    }
    LControl(Modifiers) {
    }
    RControl(Modifiers) {
    }
    LShift(Modifiers) {
    }
    RShift(Modifiers) {
    }
    LAlt(Modifiers) {
    }
    RAlt(Modifiers) {
    }
    NumpadSub(Modifiers) {
    }
}