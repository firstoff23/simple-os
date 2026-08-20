; Simple OS — primeiro sector de arranque BIOS x86.
; Este ficheiro é montado diretamente como um setor de 512 bytes.

[bits 16]
[org 0x7c00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov si, boot_message
    call print_string

halt:
    cli
    hlt
    jmp halt

; Imprime uma cadeia terminada em zero no ecrã BIOS e na porta de depuração
; 0xE9, que o QEMU expõe ao teste automatizado.
print_string:
    lodsb
    test al, al
    jz .done

    mov ah, 0x0e
    mov bh, 0x00
    mov bl, 0x0f
    int 0x10

    out 0xe9, al
    jmp print_string

.done:
    ret

boot_message db "Simple OS boot sector OK", 0

times 510 - ($ - $$) db 0
dw 0xaa55
