<p align="center">
  <img src="./assets/simple-os-banner.png" alt="Arquitetura abstrata de processador com sinais de baixo nível" width="100%" />
</p>

<h1 align="center">Simple OS</h1>

<p align="center">
  <strong>Um projeto de aprendizagem para compreender os fundamentos de um sistema operativo x86, camada a camada.</strong>
</p>

<p align="center">
  <a href="#-objetivo">Objetivo</a> ·
  <a href="#-percurso-de-aprendizagem">Percurso</a> ·
  <a href="#-começar">Começar</a> ·
  <a href="#-estado-do-repositório">Estado</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Arquitetura-x86-1F2937?style=for-the-badge&logo=intel&logoColor=white" alt="Arquitetura x86" />
  <img src="https://img.shields.io/badge/Nível-Baixo-2DD4BF?style=for-the-badge" alt="Programação de baixo nível" />
  <img src="https://img.shields.io/badge/Estado-Em%20construção-F59E0B?style=for-the-badge" alt="Em construção" />
</p>

<p align="center">
  <a href="https://github.com/firstoff23/simple-os/actions/workflows/readme-check.yml">
    <img src="https://github.com/firstoff23/simple-os/actions/workflows/readme-check.yml/badge.svg" alt="Estado do workflow README checks" />
  </a>
</p>

---

## Objetivo

O **Simple OS** é um projeto pessoal de aprendizagem dedicado à construção de um sistema operativo simples para arquitetura x86. O foco está em compreender, de forma prática, a ligação entre o *boot*, a memória, o processador e as primeiras abstrações de um sistema operativo.

> **Princípio do projeto:** aprender os fundamentos ao reduzir cada camada a um problema compreensível, verificável e documentado.

## Percurso de aprendizagem

| Etapa | Questões a explorar |
| --- | --- |
| **Arranque** | Como passa a execução do *firmware* para o código do sistema? |
| **Processador** | Como funcionam os modos de execução, interrupções e exceções? |
| **Memória** | Como organizar acesso, regiões e proteção de memória? |
| **Núcleo** | Como criar as bases de gestão de processos, entradas e saídas? |
| **Interface** | Como expor uma forma simples de interagir com o sistema? |

Este repositório serve também como um registo do processo: decisões técnicas, limitações encontradas e notas de implementação serão adicionadas à medida que o sistema evoluir.

## Estado do repositório

O projeto inclui agora o seu primeiro marco executável: um **sector de arranque BIOS x86 de 512 bytes**. A imagem inicializa o ambiente de modo real, escreve uma mensagem de confirmação e entra num estado seguro de paragem. É um ponto de partida pequeno, mas totalmente reproduzível e testado em emulador.

| Atualmente disponível | Próximo marco planeado |
| --- | --- |
| Sector de arranque em NASM, `Makefile`, teste não gráfico em QEMU e workflow de CI. | Consola reutilizável, GDT mínima e transição documentada para modo protegido de 32 bits. |

## Começar

### Pré-requisitos

É necessário instalar **NASM**, **Make** e **QEMU para x86**. Em Ubuntu ou Debian:

```bash
sudo apt install nasm make qemu-system-x86
```

### Compilar e testar

```bash
# Produz build/simple-os.img (512 bytes)
make build

# Verifica tamanho, assinatura BIOS e arranque não gráfico no QEMU
make test

# Abre a imagem no emulador gráfico
make run
```

O teste não escreve em discos reais nem exige hardware físico. A imagem e os artefactos de compilação permanecem em `build/`, que está excluído do controlo de versões.

A explicação detalhada do modelo de arranque encontra-se em [`docs/architecture.md`](./docs/architecture.md).

## Princípios de desenvolvimento

O Simple OS privilegiará progresso incremental, experimentação em ambiente isolado e documentação junto de cada componente. Qualquer instrução futura deverá indicar ferramentas, arquitetura de destino, modo de teste e limitações conhecidas, para que o projeto seja útil tanto como exercício pessoal como como material de estudo.

## Autor

Desenvolvido por [Alexandre Santos Inácio](https://github.com/firstoff23).
