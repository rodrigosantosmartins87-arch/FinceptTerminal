# Plano de separação tecnológica — plataforma brasileira

## Repositórios-alvo
1. `FinceptTerminal` (fork): referência preservada, atualizações upstream somente após revisão.
2. `mercado-br-intelligence` (novo, **a criar**): código próprio da plataforma, serviços, UI, testes e documentação. Preferir repositório privado até revisão de licenças.
3. Backup em armazenamento externo fora do GitHub com bundle completo, checksum e teste de restauração.

## Camadas no projeto próprio
- `services/market-data`: interfaces e adaptadores de dados com proveniência, licenças e limites;
- `services/economics`: indicadores BCB, IBGE, FMI e contexto;
- `services/politics`: legislativo, atos públicos, eleições;
- `services/news`: RSS, notícias, deduplicação, datas de publicação e recepção;
- `services/research`: fator de risco, análises históricas e modelos;
- `apps/web`: terminal web;
- `infra`: deploy, observabilidade, segredos e ingestão;
- `docs`: ADRs, cadastro de fontes, evidências e homologação.

## Princípios
- Nenhum segredo no Git.
- Não fazer scraping ou redistribuição vedados por contratos de dados.
- Considerar AGPL-3.0 e licenças transitivas antes de copiar/incorporar código Fincept em SaaS.
- Dado bruto imutável e séries normalizadas com fonte, carimbo temporal e frequência.
- Não confundir conector catalogado com conector homologado.
- Manter verificação automatizada de dependências e licenças.
