# Preservação do Fincept Terminal — 2026-11-14

Fonte original: https://github.com/Fincept-Corporation/FinceptTerminal
Fork sob controle do titular: https://github.com/rodrigosantosmartins87-arch/FinceptTerminal
Commit inicial de referência: `68691b7577ce642009cdf2c1b4b0766ca9e37999`
Árvore do commit de referência: `1e09057487d293d1d5f712c911531e70eec2cbc9`
Licença encontrada: GNU AGPL-3.0 (consultar LICENSE e avisos dos componentes).
Branch de documentação: `preservacao-independente-2026-11`. Não confundir esta branch com o upstream original.

## Estado real
- Fork verificado via API GitHub, proprietário `rodrigosantosmartins87-arch`, branch `main` com mesmo SHA da origem na verificação.
- Branch de preservação criada sem alterar `main`.
- Espelho completo Git fora do GitHub do autor: **NÃO EXECUTADO**.
- Bundle Git e backup fora do GitHub: **NÃO EXECUTADOS**.
- Repositório próprio independente para a plataforma brasileira: **NÃO CRIADO**.
- Instalação reproduzível e teste de restauração: **NÃO EXECUTADOS**.
Acesso por ferramentas desta conversa não oferece criação de repositório GitHub/fork nem execução de `git clone` com acesso à rede. Os arquivos desta pasta são procedimentos de preservação, não prova de backup.

## Regra de isolamento
Não alterar a branch `main` do fork de preservação. Trabalhar em repositório separado para o produto brasileiro; integrar componentes apenas após auditoria de licença, testes e revisão de direitos de dados.

## Ordem única de fechamento
1. Executar `scripts/preservar_fincept.sh` em máquina com Git, conexão GitHub e armazenamento suficiente.
2. Validar `git bundle verify`, contagem de refs e restauração em repositório temporário.
3. Guardar bundle em **duas localizações controladas distintas** e registrar checksums SHA-256.
4. Criar repositório privado independente para a plataforma brasileira; não copiar automaticamente todo o código AGPL para dentro dele.
5. Registrar inventário de dependências, versões, arquivos de licença, comandos e resultados dos testes.
6. Marcar preservação concluída somente após evidências em `PRESERVACAO/VERIFICACAO.md`.
