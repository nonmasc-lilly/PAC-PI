macro ADD arg
    local matched
    matched equ FALSE
    match a <- b, arg
        match =IP, a
            matched equ TRUE
            db 0xFF
        end match
        match =IN, a
            matched equ TRUE
            db 0xFE
        end match
        match =OT, a
            matched equ TRUE
            db 0xFD
        end match
        match =RS, a
            matched equ TRUE
            db 0xFC
        end match
        match =R0, a
            matched equ TRUE
            db 0xFB
        end match
        match =R1, a
            matched equ TRUE
            db 0xFA
        end match
        match =RN, a
            matched equ TRUE
            db 0xF9
        end match
        match =EX, a
            matched equ TRUE
            db 0xF8
        end match
        match =FALSE, matched
            db a
        end match
        matched equ FALSE
        match =IP, b
            matched equ TRUE
            db 0xFF
        end match
        match =IN, b
            matched equ TRUE
            db 0xFE
        end match
        match =OT, b
            matched equ TRUE
            db 0xFD
        end match
        match =RS, b
            matched equ TRUE
            db 0xFC
        end match
        match =R0, b
            matched equ TRUE
            db 0xFB
        end match
        match =R1, b
            matched equ TRUE
            db 0xFA
        end match
        match =RN, b
            matched equ TRUE
            db 0xF9
        end match
        match =EX, b
            matched equ TRUE
            db 0xF8
        end match
        match =FALSE, matched
            db b
        end match
    end match
end macro

macro DATA x
    local matched
    matched equ FALSE
    match a b, x
        matched equ TRUE
        db a
        DATA b
    end match
    match =FALSE, matched
        db x
    end match
end macro

macro NOP
    ADD R0 <- R0
end macro
