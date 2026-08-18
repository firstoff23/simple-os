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
  <a href="#-estado-do-repositório">Estado</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Arquitetura-x86-1F2937?style=for-the-badge&logo=intel&logoColor=white" alt="Arquitetura x86" />
  <img src="https://img.shields.io/badge/Nível-Baixo-2DD4BF?style=for-the-badge" alt="Programação de baixo nível" />
  <img src="https://img.shields.io/badge/Estado-Em%20construção-F59E0B?style=for-the-badge" alt="Em construção" />
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

O projeto encontra-se numa fase inicial de documentação e planeamento. Ainda não existem fontes de implementação ou instruções de compilação publicadas neste repositório. Esta transparência é intencional: os passos práticos serão documentados apenas quando houver código que possa ser executado e verificado.

| Atualmente disponível | Próxima atualização esperada |
| --- | --- |
| Visão, objetivo de aprendizagem e identidade visual do projeto. | Código de arranque, ferramentas necessárias e instruções de compilação. |

## Princípios de desenvolvimento

O Simple OS privilegiará progresso incremental, experimentação em ambiente isolado e documentação junto de cada componente. Qualquer instrução futura deverá indicar ferramentas, arquitetura de destino, modo de teste e limitações conhecidas, para que o projeto seja útil tanto como exercício pessoal como como material de estudo.

## Autor

Desenvolvido por [Alexandre Santos Inácio](https://github.com/firstoff23).
