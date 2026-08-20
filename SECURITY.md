# Política de segurança

## Comunicação responsável

A segurança de utilizadores, dados e serviços é importante. Se identificares uma vulnerabilidade, **não publiques detalhes exploráveis numa issue pública** enquanto o impacto não tiver sido avaliado.

Para reportar uma vulnerabilidade, utiliza uma *private vulnerability reporting* do GitHub quando essa opção estiver disponível neste repositório. Se não estiver disponível, contacta o responsável através do perfil GitHub indicado no README e inclui no assunto “Relato de segurança”.

O relatório deve conter uma descrição objetiva do problema, versões ou componentes afetados, passos mínimos de reprodução, impacto potencial e, se possível, uma proposta de mitigação. Não incluas tokens, palavras-passe, dados reais de utilizadores ou instruções que facilitem abuso desnecessário.

## Âmbito e prioridade

São especialmente relevantes problemas que afetem autenticação, autorização, exposição de dados, dependências vulneráveis, processamento de ficheiros, integrações de terceiros, execução de código, configuração de deploy ou segredos. Problemas de qualidade sem impacto de segurança podem ser abertos como *issue* normal.

| Severidade indicativa | Exemplo | Tratamento esperado |
|---|---|---|
| **Crítica** | Acesso não autorizado a dados ou execução remota de código. | Avaliação prioritária e correção antes de divulgação pública. |
| **Alta** | Escalada de privilégios, contorno de autenticação ou exposição significativa de informação. | Triagem célere, mitigação e correção coordenada. |
| **Moderada** | Condição que exige pré-requisitos específicos ou tem impacto limitado. | Correção planeada e acompanhamento público após avaliação. |
| **Baixa** | Boa prática em falta sem vetor explorável confirmado. | Registo em backlog técnico ou contribuição normal. |

## Atualizações e reconhecimento

A confirmação de receção e o estado da triagem serão comunicados através do canal usado para o reporte. Depois de uma correção estar disponível, a divulgação pode ser coordenada de forma a proteger os utilizadores. Agradecimentos podem ser incluídos nas notas de release, mediante consentimento da pessoa que reportou o problema.
