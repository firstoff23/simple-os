# Simple OS

Um sistema operativo simples construído do zero em x86, como projeto de aprendizagem de baixo nível.

## Objetivo

Este projeto documenta passo a passo a construção de um SO mínimo, desde um bootloader de 512 bytes até um sistema com kernel em C, gestão de memória, scheduler e shell.

## Etapas do Projeto

| Etapa | Descrição | Branch |
|-------|-----------|--------|
| 1 | Bootloader mínimo (512 bytes, MBR) - imprime mensagem no ecrã | [`stage1-bootloader`](https://github.com/firstoff23/simple-os/tree/stage1-bootloader) |
| 2 | Modo protegido 32-bit e kernel em C | *(em breve)* |
| 3 | Output de texto (VGA) e input de teclado (PS/2) | *(em breve)* |
| 4 | Gestão de memória (paging) e scheduler | *(em breve)* |
| 5 | Shell mínima com comandos básicos | *(em breve)* |
| 6 | Sistema de ficheiros FAT12 e user mode | *(opcional)* |

## Ambiente de Desenvolvimento

- **OS:** Windows com WSL (Ubuntu)
- **Assembler:** NASM
- **Emulador:** QEMU
- **Editor:** VS Code (recomendado)

## Setup Inicial (WSL Ubuntu)

```bash
# Atualizar pacotes
sudo apt update && sudo apt upgrade -y

# Instalar ferramentas necessárias
sudo apt install -y nasm qemu-system-x86 make gcc gdb

# Verificar instalacoes
nasm -v          # NASM version ...
qemu-system-i386 --version   # QEMU emulator version ...
make -v          # GNU Make ...
gcc --version    # gcc (Ubuntu) ...
```

## Como Usar Este Repositório

Cada etapa está numa branch separada. Para seguir o tutorial:

```bash
# Clonar o repositorio
git clone https://github.com/firstoff23/simple-os.git
cd simple-os

# Mudar para a etapa desejada
git checkout stage1-bootloader

# Seguir as instrucoes no README dessa etapa
```

---

> **Nota:** Este projeto é educacional. Cada etapa é testável incrementalmente no QEMU antes de avançar para a seguinte.
