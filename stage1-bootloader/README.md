# Etapa 1: Bootloader Mínimo

## O que vamos construir

Um bootloader de **512 bytes** que:
1. É carregado pela BIOS do PC (via Master Boot Record - MBR)
2. Configura os registos de segmento
3. Imprime uma mensagem no ecrã usando interrupções da BIOS
4. Entra num loop infinito (ainda não temos nada mais para fazer)
5. Tem a assinatura mágica `0xAA55` nos últimos 2 bytes

## Conceitos Fundamentais

### O que é um Bootloader?

Quando ligas um computador x86, o processador começa a executar código em **modo real 16-bit**. A BIOS (Basic Input/Output System):

1. Faz o POST (Power-On Self Test)
2. Procura por um dispositivo bootável (disco, USB, etc.)
3. Lê os **primeiros 512 bytes** (1 setor) desse dispositivo para a memória no endereço `0x7C00`
4. Verifica se os últimos 2 bytes desse setor são `0x55 0xAA` (assinatura de boot)
5. Se sim, salta para `0x7C00` e começa a executar o nosso código!

### Por que 512 bytes?

512 bytes = 1 setor do disco. A BIOS só carrega automaticamente 1 setor. Este é o desafio: fazer algo útil em apenas 512 bytes, ou carregar mais setores (futuras etapas).

### Por que o endereço 0x7C00?

Este endereço é uma convenção histórica da IBM PC/AT (1981). Fica na memória RAM logo após a tabela de vetores de interrupção e a BIOS Data Area. É o local "padrão" onde a BIOS coloca o setor de boot.

### Modo Real vs Modo Protegido

- **Modo Real (16-bit):** O modo em que o CPU arranca. Tem acesso a 1MB de memória, usa segmentação (CS:IP), e pode usar as interrupções da BIOS. É "simples" mas limitado.
- **Modo Protegido (32-bit):** Ativado pelo nosso código (futuras etapas). Permite acesso a 4GB de memória, proteção de memória, multitasking, etc.

## Estrutura do Código

```
stage1-bootloader/
├── boot.asm      # Código Assembly do bootloader
├── Makefile      # Script de compilação
└── README.md     # Este ficheiro (explicações detalhadas)
```

## Compilação e Teste

```bash
cd stage1-bootloader

# Compilar o bootloader
make

# Executar no QEMU
make run

# Ou manualmente:
# nasm -f bin boot.asm -o boot.bin
# qemu-system-i386 -fda boot.bin
```

## Explicação Linha a Linha

O ficheiro `boot.asm` está extensivamente comentado. Aqui está um resumo do fluxo:

| Linha(s) | O que faz | Porquê |
|----------|-----------|--------|
| `[ORG 0x7C00]` | Define o endereço de origem | A BIOS carrega o bootloader aqui |
| `jmp 0x0000:start` | Salto longo para configurar CS=0x0000 | Garante que sabemos exatamente onde estamos |
| `cli` / `xor ax, ax` / `mov ds, ax` etc. | Configura registos de segmento para 0x0000 | Evita problemas de segmentação |
| `sti` | Reativa interrupções | Precisamos delas para a BIOS funcionar |
| `mov si, msg` | Carrega o endereço da mensagem | Prepara para imprimir |
| `call print_string` | Chama a função de impressão | Reutilização de código |
| `jmp $` | Loop infinito | O CPU precisa fazer algo; não há OS para retornar |
| `print_string:` | Função que imprime caractere a caractere | Usa `int 0x10` da BIOS |
| `times 510-($-$$) db 0` | Preenche com zeros até 510 bytes | O bootloader TEM de ter exatamente 512 bytes |
| `dw 0xAA55` | Assinatura mágica nos últimos 2 bytes | A BIOS verifica isto para confirmar que é bootável |

## A Interrupção 0x10 (Serviços de Vídeo da BIOS)

Usamos a função `0x0E` da BIOS via `int 0x10`:
- **AH = 0x0E** → "Teletype output" (imprimir caractere no ecrã)
- **AL = caractere** → O caractere a imprimir
- **BH = página de vídeo** → Normalmente 0
- **BL = cor** → No modo texto, atributo de cor (opcional)

## A Interrupção 0x16 (Teclado da BIOS)

*(Nesta etapa ainda não usamos, mas é importante saber que existe)*
- Permite ler input do teclado
- Usaremos nas etapas seguintes

## Verificação no QEMU

Se tudo correr bem, deves ver algo como:

```
+-------------------------------------------+
|                                           |
|  === Simple OS - Stage 1 Bootloader ===   |
|  Hello, World! Este e o meu primeiro OS.  |
|  A carregar o sistema...                  |
|                                           |
|  _ (cursor piscando)                      |
|                                           |
+-------------------------------------------+
```

## Diagrama de Memória

```
+------------------+  0xFFFFF  (1MB - limite do modo real)
|  BIOS ROM        |
+------------------+  0xF0000
|                  |
+------------------+  0xA0000
|  Video Memory    |   <- Aqui é onde o texto aparece no ecrã
+------------------+  0x9FC00
|  Extended BIOS   |
+------------------+  0x9F000
|  Our Bootloader  |   <- 0x7C00 (onde a BIOS nos coloca)
|  (512 bytes)     |
+------------------+  0x7A00
|  Stack (grows    |   <- Descemos o SP para ter stack space
|  downward)       |
+------------------+  0x7000  (SP inicial)
|  Boot Sector     |
+------------------+  0x0500
|  BIOS Data Area  |
+------------------+  0x0400
|  Interrupt Vectors|
+------------------+  0x0000
```

## Próxima Etapa

Na **Etapa 2**, vamos:
- Carregar mais setores do disco (para ter mais código)
- Ativar o **Modo Protegido 32-bit**
- Escrever um **kernel em C**
- Configurar a GDT (Global Descriptor Table)

---

**Dica:** Brinca com a mensagem, experimenta imprimir mais coisas, tenta usar cores diferentes (muda o registrador BL antes de cada `int 0x10`). Quando te sentires confortável com este código, avança para a Etapa 2!
