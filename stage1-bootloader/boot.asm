; ============================================================================
; Simple OS - Stage 1: Bootloader Minimo (512 bytes, MBR)
; ============================================================================
; Este e o PRIMEIRO codigo que executa quando o PC arranca.
; A BIOS carrega estes 512 bytes da memoria para o endereco 0x7C00 e salta
; para la.
;
; Ambiente: Modo Real 16-bit (o unico modo disponivel quando o CPU arranca)
; Assembler: NASM (Netwide Assembler)
; ============================================================================

; ----------------------------------------------------------------------------
; [ORG 0x7C00] - Diretiva do NASM
; ----------------------------------------------------------------------------
; Diz ao assembler que este codigo vai ser carregado para o endereco 0x7C00.
; Isto e ESSENCIAL porque todas as referencias a labels (como 'msg') serao
; calculadas relativamente a este endereco.
;
; Sem isto, o NASM calcularia os enderecos como se o codigo comecasse em 0x0000,
; e 'msg' apontaria para o lugar errado.
;
; 0x7C00 = 31744 em decimal. Porque este endereco especifico?
; Porque a IBM decidiu assim em 1981 com o PC original, e mantem-se ate hoje
; por compatibilidade.
; ----------------------------------------------------------------------------
[ORG 0x7C00]

; ============================================================================
; SECAO: Codigo Principal
; ============================================================================

; ----------------------------------------------------------------------------
; jmp 0x0000:start
; ----------------------------------------------------------------------------
; Faz um "salto longo" (far jump) para o label 'start'.
;
; O que e um salto longo? Em vez de so mudar o IP (Instruction Pointer),
; mudamos tambem o CS (Code Segment).
;
; CS:IP sao os registos que determinam QUAL instrucao executar.
; O endereco fisico e calculado como: (CS * 16) + IP
;
; Porque fazemos isto? Porque nao controlamos o valor de CS quando a BIOS
; nos chama. Diferentes BIOS podem ter CS=0x0000 ou CS=0x07C0 (ambos dao
; o mesmo endereco fisico: 0x07C0 * 16 = 0x7C00).
;
; Com este salto longo, GARANTIMOS que CS=0x0000 e IP aponta para 'start'.
; Assim, os nossos calculos de endereco estao sempre corretos.
; ----------------------------------------------------------------------------
jmp 0x0000:start

; ============================================================================
; start: Ponto de entrada principal
; ============================================================================
start:
    ; ------------------------------------------------------------------------
    ; cli - Clear Interrupt Flag
    ; ------------------------------------------------------------------------
    ; Desativa as interrupcoes temporariamente.
    ;
    ; Porque? Porque vamos mexer nos registos de segmento (DS, ES, SS) e na
    ; stack pointer (SP). Se uma interrupcao ocorresse a meio deste processo,
    ; a BIOS poderia ficar confusa com valores inconsistentes.
    ;
    ; E como desligar temporariamente o telefone enquanto arrumas a casa.
    ; ------------------------------------------------------------------------
    cli

    ; ------------------------------------------------------------------------
    ; Configuracao dos registos de segmento
    ; ------------------------------------------------------------------------
    ; Os segmentos sao uma "caracteristica" do modo real x86 que permite
    ; aceder a 1MB de memoria com ponteiros de 16-bit.
    ;
    ; Endereco fisico = (Segmento * 16) + Offset
    ;
    ; Exemplo: DS=0x0000, SI=0x7C00 -> Endereco = 0x0000*16 + 0x7C00 = 0x7C00
    ;          DS=0x07C0, SI=0x0000 -> Endereco = 0x07C0*16 + 0x0000 = 0x7C00
    ;
    ; Ambos dao o MESMO endereco fisico! Mas para simplicidade, usamos tudo a 0.

    xor ax, ax          ; AX = 0  (xor de um registo com si proprio = 0)
                        ; Porque XOR e nao MOV AX, 0?
                        ; XOR e mais rapido (1 byte vs 3 bytes) e e um idoma
                        ; comum em Assembly x86.

    mov ds, ax          ; DS (Data Segment) = 0x0000
                        ; Usado para aceder a dados (como a nossa string 'msg')

    mov es, ax          ; ES (Extra Segment) = 0x0000
                        ; Segmento extra, usado por algumas instrucoes

    mov ss, ax          ; SS (Stack Segment) = 0x0000
                        ; Define onde a stack vive na memoria

    ; ------------------------------------------------------------------------
    ; Configuracao da Stack Pointer (SP)
    ; ------------------------------------------------------------------------
    ; A stack e uma regiao de memoria LIFO (Last In, First Out).
    ; E usada para:
    ;   - Guardar o endereco de retorno das chamadas CALL
    ;   - Passar argumentos para funcoes
    ;   - Guardar registos temporariamente
    ;
    ; A stack "cresce para baixo" na memoria (de enderecos altos para baixos).
    ; SP aponta para o TOPO da stack.
    ;
    ; Colocamos SP em 0x7C00 (mesmo onde comeca o nosso bootloader).
    ; Isto significa que a stack vai usar a memoria de 0x7BFF para baixo.
    ; Temos ~30KB de espaco (ate 0x0000), mais que suficiente.
    ;
    ; Nota: O bootloader ocupa 0x7C00 a 0x7DFF (512 bytes). A stack comeca
    ; logo antes (0x7BFF) e desce. Nao ha conflito desde que a stack nao
    ; cresca demais.
    ; ------------------------------------------------------------------------
    mov sp, 0x7C00      ; Stack Pointer = 0x7C00

    ; ------------------------------------------------------------------------
    ; sti - Set Interrupt Flag
    ; ------------------------------------------------------------------------
    ; Reativa as interrupcoes.
    ; Agora que tudo esta configurado, e seguro receber interrupcoes novamente.
    ; ------------------------------------------------------------------------
    sti

; ============================================================================
; SECAO: Imprimir mensagens
; ============================================================================

    ; ------------------------------------------------------------------------
    ; call print_string
    ; ------------------------------------------------------------------------
    ; CALL faz duas coisas:
    ;   1. Coloca o endereco da PROXIMA instrucao na stack (endereco de retorno)
    ;   2. Salta para a funcao indicada
    ;
    ; Quando a funcao acaba, RET pega esse endereco da stack e volta.
    ; ------------------------------------------------------------------------

    mov si, msg_title   ; SI = endereco da mensagem do titulo
    call print_string   ; Chama a funcao de impressao

    mov si, msg_hello   ; SI = endereco da mensagem principal
    call print_string   ; Chama novamente (reutilizacao!)

    mov si, msg_loading ; SI = endereco da mensagem de loading
    call print_string

; ============================================================================
; SECAO: Loop infinito
; ============================================================================

    ; ------------------------------------------------------------------------
    ; jmp $
    ; ------------------------------------------------------------------------
    ; '$' em NASM representa o endereco da instrucao atual.
    ; Portanto, isto salta para si proprio - um loop infinito.
    ;
    ; Porque precisamos disto? Porque depois do bootloader, nao ha nada.
    ; Nao ha sistema operativo para retornar. Se deixassemos o CPU continuar,
    ; ele executaria lixo na memoria.
    ;
    ; Futuramente, aqui carregaremos mais setores ou o kernel.
    ; ------------------------------------------------------------------------
halt:
    jmp halt            ; Loop infinito (halt e so um label para claridade)

; ============================================================================
; SECAO: Funcoes
; ============================================================================

; ----------------------------------------------------------------------------
; print_string
; ----------------------------------------------------------------------------
; Imprime uma string terminada em NULL (0) no ecra usando BIOS int 0x10.
;
; INPUT:
;   DS:SI -> ponteiro para a string (terminada em 0)
;
; DESTROI:
;   AX, BX, SI (registos que sao modificados)
;
; A interrupcao 0x10 e o servico de video da BIOS.
; AH=0x0E significa "Teletype Output" - imprime um caractere no cursor
; e avanca o cursor.
; ----------------------------------------------------------------------------
print_string:
    pusha               ; Guarda TODOS os registos gerais na stack
                        ; (AX, CX, DX, BX, SP, BP, SI, DI)
                        ; Assim a funcao nao "suja" os registos do chamador

.print_loop:
    lodsb               ; Load String Byte
                        ; Faz: AL = [DS:SI], depois SI++
                        ; Ou seja, le um byte da string para AL e avanca o ponteiro

    test al, al         ; Testa se AL e zero
                        ; TEST faz um AND logico sem guardar o resultado,
                        ; so atualiza as flags.
                        ; Se AL=0 (fim da string), Zero Flag = 1

    jz .done            ; Jump if Zero - se chegamos ao fim da string, sai

    ; ------------------------------------------------------------------------
    ; int 0x10 - Interrupcao de Video da BIOS
    ; ------------------------------------------------------------------------
    ; AH = 0x0E -> Funcao "Teletype Output"
    ; AL = caractere a imprimir
    ; BH = pagina de video (0 para a pagina principal)
    ; BL = cor do texto (atributo - so relevante em modos graficos)
    ;
    ; A BIOS trata de tudo: coloca o caractere no ecra, move o cursor,
    ; faz scroll se necessario.
    ; ------------------------------------------------------------------------
    mov ah, 0x0E        ; Funcao: Teletype Output
    mov bh, 0x00        ; Pagina de video 0
    mov bl, 0x07        ; Cor: Light Gray (cinza claro) sobre fundo preto
    int 0x10            ; Chama a BIOS!

    jmp .print_loop     ; Proximo caractere

.done:
    popa                ; Restaura todos os registos guardados
    ret                 ; Return - volta para quem chamou CALL

; ============================================================================
; SECAO: Dados (Strings)
; ============================================================================

; ----------------------------------------------------------------------------
; db -> Define Byte (define bytes na memoria)
; 10 -> Codigo ASCII de Newline (\n)
; 13 -> Codigo ASCII de Carriage Return (\r)
; 0  -> NULL terminator (fim da string)
;
; Usamos CR+LF (13, 10) porque e o padrao DOS/Windows para nova linha.
; A BIOS int 0x10 com AH=0x0E interpreta alguns caracteres de controlo:
;   - 13 (CR): volta o cursor para o inicio da linha
;   - 10 (LF): desce uma linha
; ----------------------------------------------------------------------------

msg_title:
    db 10, 13, '========================================', 10, 13
    db '=== Simple OS - Stage 1 Bootloader ===', 10, 13
    db '========================================', 10, 13, 0

msg_hello:
    db 10, 13, 'Hello, World!'
    db 10, 13, 'Este e o meu primeiro sistema operativo.', 10, 13, 0

msg_loading:
    db 10, 13, 'A carregar o sistema...', 10, 13
    db '(Fase 1 completa - Bootloader minimo)', 10, 13, 0

; ============================================================================
; SECAO: Padding e Assinatura de Boot
; ============================================================================

; ----------------------------------------------------------------------------
; times 510-($-$$) db 0
; ----------------------------------------------------------------------------
; Esta e uma das linhas mais importantes do bootloader!
;
; '$'  = endereco atual
; '$$' = endereco de inicio da secao (0x7C00 neste caso)
; ($-$$) = tamanho do codigo ate agora em bytes
;
; 510 - ($-$$) = numero de bytes que faltam para chegar a 510
;
; 'times N db 0' repete 'db 0' N vezes - preenche com zeros.
;
; O bootloader DEVE ter EXATAMENTE 512 bytes.
; Os ultimos 2 bytes sao a assinatura 0xAA55.
; Logo, o codigo+dados+padding deve ocupar 510 bytes.
; ----------------------------------------------------------------------------
times 510-($-$$) db 0

; ----------------------------------------------------------------------------
; dw 0xAA55
; ----------------------------------------------------------------------------
; 'dw' = Define Word (2 bytes)
; 0xAA55 e a "assinatura magica" do setor de boot.
;
; A BIOS verifica os ULTIMOS 2 bytes do primeiro setor:
;   - Byte 510 = 0x55
;   - Byte 511 = 0xAA
;
; Se encontrar esta assinatura, considera o disco "bootavel" e executa.
; Se nao encontrar, mostra erro tipo "No bootable device".
;
; Nota: x86 e "little-endian", por isso 0xAA55 em memoria fica:
;   byte 510: 0x55
;   byte 511: 0xAA
; ----------------------------------------------------------------------------
dw 0xAA55

; ============================================================================
; FIM DO BOOTLOADER
; ============================================================================
; Total: exatamente 512 bytes (510 de padding/codigo + 2 de assinatura)
; ============================================================================
