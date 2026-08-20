# Arquitetura inicial

## Marco 0: sector de arranque BIOS

O primeiro artefacto executável do Simple OS é um único sector de arranque para BIOS em arquitetura x86. O objetivo deste marco não é criar ainda um núcleo completo: é validar uma cadeia de trabalho reproduzível desde o código Assembly até ao arranque controlado num emulador.

| Decisão | Escolha | Motivo |
|---|---|---|
| Arquitetura inicial | x86 em modo real de 16 bits | É o estado em que a BIOS transfere controlo para o sector de arranque. |
| Endereço de carga | `0x7c00` | Convenção do arranque BIOS para o primeiro sector. |
| Formato | Binário cru de 512 bytes | Corresponde a um sector de arranque mínimo. |
| Assinatura | `0xAA55` nos dois últimos bytes | Permite à BIOS e ao QEMU reconhecerem o sector como arrancável. |
| Assembler | NASM | Tem sintaxe explícita e saída binária direta, adequada ao primeiro passo pedagógico. |
| Emulador | QEMU x86 | Permite validar o arranque sem escrever em hardware real. |

## Sequência de execução

```text
BIOS
  ↓ carrega o primeiro sector em 0x7c00
Simple OS boot sector
  ↓ inicializa segmentos e pilha
  ↓ escreve mensagem na BIOS e na porta 0xE9 de depuração
  ↓ entra em halt seguro
QEMU
  ↓ expõe a mensagem ao teste automatizado
```

O código escreve `Simple OS boot sector OK` através da interrupção BIOS de teletipo e da porta de depuração `0xE9`. A segunda saída permite testar o arranque em CI sem uma janela gráfica.

## Garantias do teste

O comando `make test` verifica quatro propriedades:

1. O binário existe e tem exatamente 512 bytes.
2. Os últimos dois bytes são `0x55` e `0xAA`.
3. O QEMU consegue iniciar a imagem sem uma falha inesperada.
4. A mensagem de confirmação chega ao canal de depuração.

O timeout de três segundos é esperado, porque o sector termina num ciclo `hlt` e não deve reiniciar nem desligar a máquina. Um timeout controlado é, neste caso, o comportamento correto depois de a mensagem ser emitida.

## Limites deste marco

Este sector ainda não lê um segundo estágio, não entra em modo protegido, não configura tabela de descritores, não trata interrupções e não possui kernel, memória virtual, processos ou sistema de ficheiros. Essas responsabilidades serão adicionadas apenas depois de este marco permanecer estável no emulador e no CI.

## Próximo marco técnico

O próximo passo recomendado é separar a rotina de escrita em consola e introduzir uma tabela GDT mínima para mudar de modo real de 16 bits para modo protegido de 32 bits. Essa mudança deve incluir uma nova imagem de teste, documentação de memória e uma asserção observável no QEMU.

## Referências

- [OSDev Wiki — Your first boot sector](https://wiki.osdev.org/Babystep1)
- [NASM documentation](https://www.nasm.us/doc/)
- [QEMU documentation](https://www.qemu.org/documentation/)
