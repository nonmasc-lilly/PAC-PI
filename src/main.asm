format elf64 executable
entry _start

segment readable executable
_start:
    ; argc == 2 or err
    cmp qword [rsp], 0x02
    jne .err_argc
    ; Open file
    mov eax, 0x02
    mov rdi, [rsp+0x10]
    mov esi, 0x00
    mov edx, 777o
    syscall
    mov qword [fd], rax
    
    ; Setup stack
    push rbp
    mov rbp, rsp
    sub rsp, 0x100
   
    ; Read file
    mov eax, 0x00
    mov rdi, qword [fd]
    mov rsi, rsp
    mov edx, 0x100
    syscall

    ; Setup rbx and registers
    xor ebx, ebx
    xor edx, edx
    mov byte [rsp+0xFC], 0x00
    mov byte [rsp+0xFB], 0x00
    mov byte [rsp+0xFA], 0x01
    mov byte [rsp+0xF9], 0xFF

    ; main loop
    .loop:
        cmp byte [rsp+rbx], -1
        jne .notip
            cmp byte [rsp+rbx+1], -1
            jne .notipip
                add bl, bl
                add bl, 0x02
                jmp .loop
            .notipip:
            cmp byte [rsp+rbx+1], -2
            jne .notipin
                dec rsp
                xor eax, eax
                xor edx, edx
                mov rsi, rsp
                mov edx, 0x01
                syscall
                add bl, byte [rsp]
                add bl, 0x02
                inc rsp
                jmp .loop
            .notipin:
            cmp byte [rsp+rbx+1], -3
            jne .notipot
                add bl, 0x02
                jmp .loop
            .notipot:
            mov dl, [rsp+rbx+1]
            mov dl, [rsp+rdx]
            add bl, dl
            add bl, 0x02
            jmp .loop
        .notip:
        cmp byte [rsp+rbx], -2
        jne .notin
            add bl, 0x02
            jmp .loop
        .notin:
        cmp byte [rsp+rbx], -3
        jne .notot
            cmp byte [rsp+rbx+1], -1
            jne .nototip
                dec rsp
                mov [rsp], bl
                mov eax, 0x01
                mov edi, eax
                mov rsi, rsp
                mov edx, edi
                syscall
                inc rsp
                add bl, 0x02
                jmp .loop
            .nototip:
            cmp byte [rsp+rbx+1], -2
            jne .nototin
                dec rsp
                xor eax, eax
                xor edx, edx
                mov rsi, rsp
                mov edx, 0x01
                syscall
                mov eax, 0x01
                mov edi, eax
                mov rsi, rsp
                mov edx, edi
                syscall
                inc rsp
                add bl, 0x02
                jmp .loop
            .nototin:
            cmp byte [rsp+rbx+1], -3
            jne .nototot
                add bl, 0x02
                jmp .loop
            .nototot:
            mov dl, [rsp+rbx+1]
            mov dl, [rsp+rdx]
            dec rsp
            mov [rsp], dl
            mov eax, 0x01
            mov edi, eax
            mov rsi, rsp
            mov edx, edi
            syscall
            inc rsp
            add bl, 0x02
            jmp .loop
        .notot:
        cmp byte [rsp+rbx], -4
        jne .notrs
            cmp byte [rsp+rbx+1], -1
            jne .notrsip
                add [rsp+0xFC], bl
                add bl, 0x02
                jmp .loop
            .notrsip:
            cmp byte [rsp+rbx+1], -2
            jne .notrsin
                dec rsp
                xor eax, eax
                xor edx, edx
                mov rsi, rsp
                mov edx, 0x01
                syscall
                mov dl, byte [rsp]
                add [rsp+0xFC], dl
                inc rsp
                add bl, 0x02
                jmp .loop
            .notrsin:
            cmp byte [rsp+rbx+1], -3
            jne .notrsot
                add bl, 0x02
                jmp .loop
            .notrsot:
            mov dl, [rsp+rbx+1]
            mov dl, [rsp+rdx]
            add [rsp+0xFC], dl
            add bl, 0x02
            jmp .loop
        .notrs:
        cmp byte [rsp+rbx], -5
        jne .notr0
            add bl, 0x02
            jmp .loop
        .notr0:
        cmp byte [rsp+rbx], -6
        jne .notr1
            add bl, 0x02
            jmp .loop
        .notr1:
        cmp byte [rsp+rbx], -7
        jne .notrn
            add bl, 0x02
            jmp .loop
        .notrn:
        cmp byte [rsp+rbx], -8
        jne .notex
            mov eax, 0x3C
            xor edi, edi
            syscall
        .notex:
        cmp byte [rsp+rbx+1], -1
        jne .notnoip
            mov dl, [rsp+rbx]
            add [rsp+rdx], bl
            add bl, 0x02
            jmp .loop
        .notnoip:
        cmp byte [rsp+rbx+1], -2
        jne .notnoin
            mov dl, byte [rsp+rbx]
            mov r12, rdx
            dec rsp
            mov eax, 0x00
            mov edi, 0x00
            mov rsi, rsp
            mov edx, 0x01
            syscall
            mov dl, [rsp]
            inc rsp
            add [rsp+r12], dl
            add bl, 0x02
            jmp .loop
        .notnoin:
        cmp byte [rsp+rbx+1], -3
        jne .notnoot
            add bl, 0x02
            jmp .loop
        .notnoot:
        cmp byte [rsp+rbx+1], -8
        jne .notnoet
            mov eax, 0x3C
            xor edi, edi
            syscall
        .notnoet:
        mov dl, [rsp+rbx+1]
        mov dl, [rsp+rdx]
        xor rax, rax
        mov al, [rsp+rbx]
        add [rsp+rax], dl
        add bl, 0x02
        jmp .loop

    mov eax, 0x3C
    xor edi, edi
    syscall
.err_argc:
    mov eax, 0x01
    mov edi, eax
    lea rsi, [ERR_argc_1+4]
    mov edx, [ERR_argc_1]
    syscall
    mov rsi, [rsp+0x08]
    xor edx, edx
    .err_argc.strlen:
        cmp byte [rsi], 0x00
        je .err_argc.strlen.end
        inc edx
        inc rsi
        jmp .err_argc.strlen
    .err_argc.strlen.end:
    mov eax, 0x01
    mov edi, eax
    mov rsi, [rsp+0x08]
    syscall
    mov eax, 0x01
    mov edi, eax
    lea rsi, [ERR_argc_2+4]
    mov edx, [ERR_argc_2]
    syscall
    mov eax, 0x3C
    mov edi, 0x01
    syscall
    


segment readable

ERR_argc_1:
    dd @f-$-4
    db "Usage: "
@@:
ERR_argc_2:
    dd @f-$-4
    db " <input binary>", 0x0A
@@:

segment readable writeable

fd: dq ?
