format elf64 executable
entry _start

SYS_READ  = 0
SYS_WRITE = 0x01
SYS_OPEN  = 0x02
SYS_CLOSE = 0x03
SYS_EXIT  = 0x3C

macro syscall sys_code, [arg] {
common
    match any, sys_code \{ mov eax, sys_code \}
    match =0, sys_code \{ xor eax, eax \}
forward
    match register =:==     =0,  arg \{ xor register, register \}
    match register =:==  value,  arg \{ mov register,    value \}
    match register =:== [value], arg \{ mov register,  [value] \}
    match register =&== [value], arg \{ lea register,  [value] \}
common
    syscall
}

macro ifx expr*, identifier* {
    local matched
    matched equ FALSE
    match a == b, expr \{
        cmp a, b
        jne identifier
        matched equ TRUE
    \}
    match a =~== b, expr \{
        cmp a, b
        je identifier
        matched equ TRUE
    \}
    match =FALSE, matched \{
        err
    \}
}
macro endifx identifier* {
    label identifier
}

macro forever identifier* {
    label identifier
}
macro endforever identifier* {
    jmp identifier
}

macro strdef name*, [arg] {
common
    label name
    dd @f-$-4
forward
    db arg
common
    @@:
}

segment readable executable
_start:
    ; argc == 2 or err
    cmp qword [rsp], 0x02
    jne .err_argc
    ; Open file
    syscall SYS_OPEN, rdi := [rsp+0x10], esi := 0, edx := 777o
    mov qword [fd], rax
    
    ; Setup stack
    push rbp
    mov rbp, rsp
    sub rsp, 0x100
   
    ; Read file
    syscall SYS_READ, rdi := qword [fd], rsi := rsp, edx := 0x100

    ; Setup rbx and registers
    xor ebx, ebx
    xor edx, edx
    mov byte [rsp+0xFC], 0x00
    mov byte [rsp+0xFB], 0x00
    mov byte [rsp+0xFA], 0x01
    mov byte [rsp+0xF9], 0xFF

    ; main loop
    forever .loop
        ifx byte[rsp+rbx] = -1, .notip
            ifx byte[rsp+rbx+1] = -1, .notipip
                add bl, bl
                add bl, 0x02
                jmp .loop
            endifx .notipip
            ifx byte[rsp+rbx+1] = -2, .notipin
                dec rsp
                syscall SYS_READ, edi := 0, rsi := rsp, edx := 0x01
                add bl, byte [rsp]
                inc rsp
                add bl, 0x02
                jmp .loop
            endifx .notipin
            ifx byte[rsp+rbx+1] = -3, .notipot
                add bl, 0x02
                jmp .loop
            endifx .notipot
            mov dl, [rsp+rbx+1]
            mov dl, [rsp+rdx]
            add bl, dl
            add bl, 0x02
            jmp .loop
        endifx .notip
        ifx byte[rsp+rbx] = -2, .notin
            add bl, 0x02
            jmp .loop
        endifx .notin
        ifx byte[rsp+rbx] = -3, .notot
            ifx byte[rsp+rbx+1] = -1, .nototip
                dec rsp
                mov [rsp], bl
                syscall SYS_WRITE, edi := eax, rsi := rsp, edx := edi
                inc rsp
                add bl, 0x02
                jmp .loop
            endifx .nototip
            ifx byte[rsp+rbx+1] = -2, .nototin
                dec rsp
                syscall  SYS_READ, edi :=   0, rsi := rsp, edx := 0x01
                syscall SYS_WRITE, edi := eax, rsi := rsp, edx := edi
                inc rsp
                add bl, 0x02
                jmp .loop
            endifx .nototin
            ifx byte[rsp+rbx+1] = -3, .nototot
                add bl, 0x02
                jmp .loop
            endifx .nototot
            mov dl, [rsp+rbx+1]
            mov dl, [rsp+rdx]
            dec rsp
            mov [rsp], dl
            syscall SYS_WRITE, edi := eax, rsi := rsp, edx := edi
            inc rsp
            add bl, 0x02
            jmp .loop
        endifx .notot
        ifx byte[rsp+rbx] = -4, .notrs
            ifx byte[rsp+rbx+1] = -1, .notrsip
                add [rsp+0xFC], bl
                add bl, 0x02
                jmp .loop
            endifx .notrsip
            ifx byte[rsp+rbx+1] = -2, .notrsin
                dec rsp
                syscall SYS_READ, edi := 0, rsi := rsp, edx := 0x01
                mov dl, byte [rsp]
                add [rsp+0xFC], dl
                inc rsp
                add bl, 0x02
                jmp .loop
            endifx .notrsin
            ifx byte[rsp+rbx+1] = -3, .notrsot
                add bl, 0x02
                jmp .loop
            endifx .notrsot
            mov dl, [rsp+rbx+1]
            mov dl, [rsp+rdx]
            add [rsp+0xFC], dl
            add bl, 0x02
            jmp .loop
        endifx .notrs
        ifx byte[rsp+rbx] = -5, .notr0
            add bl, 0x02
            jmp .loop
        endifx .notr0
        ifx byte[rsp+rbx] = -6, .notr1
            add bl, 0x02
            jmp .loop
        endifx .notr1
        ifx byte[rsp+rbx] = -7, .notrn
            add bl, 0x02
            jmp .loop
        endifx .notrn
        ifx byte[rsp+rbx] = -8, .notex
            syscall SYS_EXIT, edi := 0
        endifx .notex

        ifx byte[rsp+rbx+1] = -1, .notnoip
            mov dl, [rsp+rbx]
            add [rsp+rdx], bl
            add bl, 0x02
            jmp .loop
        endifx .notnoip
        ifx byte[rsp+rbx+1] = -2, .notnoin
            mov dl, byte [rsp+rbx]
            mov r12, rdx
            dec rsp
            syscall SYS_READ, edi := 0, rsi := rsp, edx := 0x01
            mov dl, [rsp]
            inc rsp
            add [rsp+r12], dl
            add bl, 0x02
            jmp .loop
        endifx .notnoin
        ifx byte[rsp+rbx+1] = -3, .notnoot
            add bl, 0x02
            jmp .loop
        endifx .notnoot
        ifx byte[rsp+rbx+1] = -8, .notnoet
            syscall SYS_EXIT, edi := 0
        endifx .notnoet
        mov dl, [rsp+rbx+1]
        mov dl, [rsp+rdx]
        xor rax, rax
        mov al, [rsp+rbx]
        add [rsp+rax], dl
        add bl, 0x02
    endforever .loop

    syscall SYS_EXIT, edi := 0

.err_argc:
    ; display error message equiv to: printf("Usage: %s <input binary>", argv[0]) and exit
    syscall SYS_WRITE, edi := eax, rsi &= [ERR_argc_1+4], edx := [ERR_argc_1]
    mov rsi, [rsp+0x08]
    xor edx, edx
    .err_argc.strlen:
        cmp byte [rsi], 0x00
        je .err_argc.strlen.end
        inc edx
        inc rsi
        jmp .err_argc.strlen
    .err_argc.strlen.end:
    syscall SYS_WRITE, edi := eax, rsi := [rsp+0x08]
    syscall SYS_WRITE, edi := eax, rsi &= [ERR_argc_2+4], edx := [ERR_argc_1]
    syscall SYS_EXIT, edi := 0x01

segment readable

strdef ERR_argc_1, "Usage: "
strdef ERR_argc_2, " <input binary>", 0x0A

segment readable writeable

fd: dq ?
