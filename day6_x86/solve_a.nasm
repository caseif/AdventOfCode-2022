BITS 64

%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define SYS_EXIT 60

%define EOF -1

%define stdout 0

section .data
    inputfile db "input.txt", 0
    part1label db "Part A: ", 0
    newline db 0x0A

section .text
    global _start

_start:
    ; allocate stack space
    ; [rbp - 4]: file descriptor
    ; [rbp - 8]: current offset
    ; [rbp - 12]: char buffer
    push rbp
    mov rbp, rsp
    sub rsp, 12

    ; open file for reading
    mov rax, SYS_OPEN
    mov rdi, inputfile
    mov rsi, 0o4000 ; O_RDONLY | O_NONBLOCK
    syscall

    ; push file descriptor to stack
    mov [rbp - 4], eax

    ; set current offset in file so we can print it at the end
    mov dword [rbp - 8], 3 ; this one less than it should be so that the modulo math works out nicer

    ; read first three chars to get initial data
    mov rdi, [rbp - 4]
    mov rsi, rbp
    sub rsi, 12
    mov rdx, 3
    mov rax, SYS_READ
    syscall

    ; we assume that the first three chars are unique since we only need to operate on a specific set of input data

    read_loop:
        ; compute which slot of the buffer we read to
        mov rdx, 0
        mov eax, [rbp - 8] ; load current offset
        mov rbx, 4
        div rbx
        mov rsi, rbp
        sub rsi, 12
        add rsi, rdx

        ; read next char
        mov rdi, [rbp - 4] ; load file descriptor
        mov rdx, 1
        mov rax, SYS_READ
        syscall

        cmp eax, 0
        je exit

        mov al, [rbp - 12]
        cmp al, [rbp - 11]
        je copy_and_continue
        cmp al, [rbp - 10]
        je copy_and_continue
        cmp al, [rbp - 9]
        je copy_and_continue

        mov al, [rbp - 11]
        cmp byte al, [rbp - 10]
        je copy_and_continue
        cmp byte al, [rbp - 9]
        je copy_and_continue

        mov al, [rbp - 10]
        cmp byte al, [rbp - 9]
        je copy_and_continue

        jmp end_read_loop

        copy_and_continue:
        mov r12b, al

        inc dword [rbp - 8]

        jmp read_loop
    end_read_loop:

    mov rdi, stdout
    mov rsi, part1label
    mov rdx, 9
    mov rax, SYS_WRITE
    syscall

    mov edi, [rbp - 8]
    inc edi ; correct it being off by one for the sake of the modulo math
    call print_uint

    mov rdi, stdout
    mov rsi, newline
    mov rdx, 1
    mov rax, SYS_WRITE
    syscall

    call exit

exit:
    mov rax, SYS_EXIT
    mov rdi, 0 ; exit code
    syscall

print_char:
    push rbp
    mov rbp, rsp

    sub rsp, 1

    push rax
    push rdx
    push rdi
    push rsi

    mov [rsp - 1], dil

    mov rdi, stdout
    mov rsi, rsp
    sub rsi, 1
    mov rdx, 1
    mov rax, SYS_WRITE
    syscall

    pop rsi
    pop rdi
    pop rdx
    pop rax

    mov rsp, rbp
    pop rbp
    ret

print_uint:
    push rbp
    mov rbp, rsp

    sub rsp, 24 ; for the char buffer - this can't be exceeded with a 64-bit number

    push rax
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    push r12

    mov rcx, 0
    mov rbx, 10

    mov rax, rdi

    divide_by_10:
        mov rdx, 0
        inc rcx
        div rbx

        mov r12, rbp
        sub r12, rcx
        add rdx, 0x30 ; convert number to ascii code
        mov [r12], dl
        cmp eax, 0
        jne divide_by_10

    mov rdi, stdout
    mov rsi, r12
    mov rdx, rcx
    mov rax, SYS_WRITE
    syscall

    pop r12
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax

    mov rsp, rbp
    pop rbp
    ret
