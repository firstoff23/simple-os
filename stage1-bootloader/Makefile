# ============================================================================
# Makefile - Etapa 1: Bootloader Minimo
# ============================================================================
# Um Makefile automatiza a compilacao. Em vez de memorizar comandos longos,
# escrevemos 'make' ou 'make run'.
#
# Sintaxe:
#   alvo: dependencias
#       comando
# ============================================================================

# Nome do ficheiro de saida
BOOT_BIN = boot.bin

# Ficheiro fonte
BOOT_ASM = boot.asm

# ============================================================================
# ALVO PADRAO (executado quando escreves apenas 'make')
# ============================================================================
# '$@' = nome do alvo (boot.bin)
# '$<' = primeira dependencia (boot.asm)
# ============================================================================
all: $(BOOT_BIN)

$(BOOT_BIN): $(BOOT_ASM)
	@echo "=== A compilar o bootloader ==="
	@echo "NASM: Assembling $(BOOT_ASM) -> $(BOOT_BIN)"
	# -f bin : formato de saida "raw binary" (sem headers, so bytes puros)
	# -o     : ficheiro de saida
	# -l     : ficheiro de listagem (opcional, util para debug)
	nasm -f bin $(BOOT_ASM) -o $(BOOT_BIN) -l boot.lst
	@echo "=== Compilacao concluida ==="
	@echo "Tamanho: $$(wc -c < $(BOOT_BIN)) bytes (deve ser 512)"

# ============================================================================
# EXECUTAR NO QEMU
# ============================================================================
# -fda : especifica um floppy disk (drive A)
# Tambem podemos usar: qemu-system-i386 -drive format=raw,file=boot.bin
#
# O QEMU e um emulador completo de PC. Simula:
#   - CPU x86 completo
#   - BIOS (SeaBIOS)
#   - Memoria RAM
#   - Placa grafica (Cirrus/VGA)
#   - Teclado, disco, etc.
#
# E mais rapido e pratico que testar em hardware real.
# ============================================================================
run: $(BOOT_BIN)
	@echo "=== A iniciar QEMU ==="
	qemu-system-i386 -fda $(BOOT_BIN)

# ============================================================================
# DEBUG COM QEMU (modo debug com GDB)
# ============================================================================
# -s : atende GDB na porta 1234 (localhost:1234)
# -S : PAUSA o CPU no inicio (espera pelo GDB para continuar)
#
# Num terminal separado:
#   gdb
#   (gdb) target remote localhost:1234
#   (gdb) set architecture i8086   (modo 16-bit)
#   (gdb) break *0x7C00
#   (gdb) continue
# ============================================================================
debug: $(BOOT_BIN)
	@echo "=== QEMU em modo debug (espera GDB na porta 1234) ==="
	qemu-system-i386 -fda $(BOOT_BIN) -s -S

# ============================================================================
# LIMPAR FICHEIROS GERADOS
# ============================================================================
clean:
	@echo "=== A limpar ficheiros ==="
	rm -f $(BOOT_BIN) boot.lst
	@echo "Limpo!"

# ============================================================================
# VERIFICAR TAMANHO (deve ser exatamente 512 bytes)
# ============================================================================
check: $(BOOT_BIN)
	@echo "=== Verificacao do bootloader ==="
	@SIZE=$$(wc -c < $(BOOT_BIN)); \
	echo "Tamanho: $$SIZE bytes"; \
	if [ "$$SIZE" -eq 512 ]; then \
		echo "✓ Tamanho correto (512 bytes)"; \
	else \
		echo "✗ ERRO: Tamanho deve ser 512 bytes"; \
		exit 1; \
	fi
	@echo "=== Verificacao da assinatura ==="
	@SIGNATURE=$$(xxd -l 2 -s 510 $(BOOT_BIN) | awk '{print $$2}'); \
	if [ "$$SIGNATURE" = "55aa" ]; then \
		echo "✓ Assinatura 0xAA55 presente (bytes 510-511)"; \
	else \
		echo "✗ ERRO: Assinatura incorreta: $$SIGNATURE"; \
		exit 1; \
	fi
	@echo "=== Bootloader valido! ==="

# ============================================================================
# HEX DUMP (ver o conteudo em hexadecimal)
# ============================================================================
hex: $(BOOT_BIN)
	@echo "=== Hex dump do bootloader ==="
	xxd $(BOOT_BIN) | head -40

# ============================================================================
# AJUDA
# ============================================================================
help:
	@echo "Comandos disponiveis:"
	@echo "  make       - Compila o bootloader"
	@echo "  make run   - Compila e executa no QEMU"
	@echo "  make debug - Inicia QEMU em modo debug (espera GDB)"
	@echo "  make check - Verifica tamanho (512 bytes) e assinatura"
	@echo "  make hex   - Mostra hex dump do binario"
	@echo "  make clean - Remove ficheiros compilados"
	@echo "  make help  - Mostra esta ajuda"
