.intel_syntax noprefix
.global _start
.text

match:
    lea rdi, [s_match]
    call print
    call exit
    
nomatch:
    lea rdi, [s_nomatch]
    call print
    call exit
strcmp: ;# arg1: rdi, arg2: rsi
    mov al, [rdi]
    mov dl, [rsi]
    cmp al, dl
    jne sc.done
    
    cmp al, 0
    je sc.done
    
    inc rdi
    inc rsi
    jmp strcmp
    
    sc.done:
        sub al, dl
        ret    
        
strncmp: ;# arg1: rdi, arg2: rsi, arg3: rdx
    mov rcx, rdx
    snc.loop:
        dec rcx
        mov al, [rdi]
        mov dl, [rsi]
        cmp al, dl
        jne snc.done
    
        cmp al, 0
        je snc.done
    
        cmp rcx, 0
        je snc.done
    
        inc rdi
        inc rsi
    jmp snc.loop
    
    snc.done:
        sub al, dl
        ret    
        
print:
        push rdi
        call strlen
        pop rsi
        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        syscall
        ret

itoa: 
    mov rax, rdi ;# move the input number into the division register
    dec rdx ;# becuase we are using the size to seek, we want to go to the last available address, not one over the end
    add rsi, rdx ;# add the supplied length to seek to the end of the buffer
    lea rdi, [rsi] ;# rdi is now our itoa-buffer writer head (ibuf)
    mov byte ptr [rdi], 0  ;# put a null byte at the end
    dec rdi

    .itoa_loop:
        xor rdx, rdx
        mov rcx, 10
        div rcx ;# rax /= rcx, rdx = rax % rcx
        add rdx, '0' ;# an ascii 0, 0x30
        mov byte ptr [rdi], dl ;# write a single byte (char) from into ibuf
        cmp rax, 0 ;# no quotient, only remainder
        je .itoa_done
        dec rdi ;# we are writing backwards
        jmp .itoa_loop

    .itoa_done:
        mov rax, rdi
        RET

htoa:
    mov rax, rdi ;# move the input number into the division register
    dec rdx ;# becuase we are using the size to seek, we want to go to the last available address, not one over the end
    add rsi, rdx ;# add the supplied length to seek to the end of the buffer
    lea rdi, [rsi] ;# rdi is now our itoa-buffer writer head (ibuf)
    mov byte ptr [rdi], 0  ;# put a null byte at the end
    dec rdi

    .htoa_loop:
        xor rdx, rdx 
        mov rcx, 16 ;# dividend
        div rcx ;# rax /= rcx, rdx = rax % rcx
        cmp rdx, 10
        jl .htoa_num
        jmp .htoa_letter

        .htoa_num:
            add rdx, '0' ;# an ascii 0, 0x30
            mov byte ptr [rdi], dl ;# write a single byte (char) from into ibuf
            cmp rax, 0 ;# no quotient, only remainder
            je .htoa_done
            dec rdi ;# we are writing backwards
            jmp .htoa_loop

        .htoa_letter:
            add rdx, 'a'
            sub rdx, 10
            mov [rdi], dl
            cmp rax, 0
            je .htoa_done
            dec rdi
            jmp .htoa_loop

    .htoa_done:
        mov rax, rdi
        RET


.data
s1: .asciz "Abc"
s2: .asciz "Ab"
s_match: .asciz "The strings match!\n"
s_nomatch: .asciz "The strings DO NOT match!\n"
