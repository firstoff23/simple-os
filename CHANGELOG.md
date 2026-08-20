# Notas de versão

O Simple OS documenta cada marco como parte do seu percurso de aprendizagem. Uma versão só deve ser etiquetada quando a imagem pode ser compilada e testada de forma reproduzível.

## 0.1.0 — Primeiro marco de arranque

### Adicionado

- Sector de arranque BIOS x86 em NASM, com exatamente 512 bytes e assinatura `0xAA55`.
- Inicialização mínima de segmentos e pilha, seguida de uma mensagem de confirmação e paragem segura.
- `Makefile` com comandos para compilar, testar, executar no QEMU e limpar artefactos locais.
- Teste não gráfico que verifica o tamanho da imagem, a assinatura BIOS e a confirmação recebida pela porta de depuração do QEMU.
- Workflow de CI que instala NASM e QEMU, executa `make test` e guarda a imagem como artefacto temporário.
- Documento de arquitetura inicial em [`docs/architecture.md`](./docs/architecture.md).

## Política de versões

| Tipo de alteração | Próxima versão recomendada |
|---|---|
| Correção no Assembly, teste ou documentação sem alterar o marco | Patch (`0.1.Z`) |
| Novo marco compatível, como consola ou modo protegido | Minor (`0.Y.0`) |
| Alteração de arquitetura, formato de imagem ou contrato de boot | Major (`X.0.0`) |

Cada release deve declarar as ferramentas utilizadas e incluir a saída bem-sucedida de `make test`. Imagens binárias geradas não são versionadas; o artefacto de CI é a referência reproduzível para cada execução validada.
