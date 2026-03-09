## 📂 Pasta DDL

Esta pasta é utilizada para armazenar os arquivos relacionados à definição e evolução da estrutura do banco de dados do projeto **Security Equipment Management Database**.

Os arquivos aqui presentes representam o desenvolvimento progressivo das tabelas conforme o avanço da modelagem, permitindo organizar as alterações feitas ao longo do tempo.

A proposta é manter o versionamento da estrutura do banco de dados de forma incremental, acompanhando a evolução das entidades, atributos e ajustes necessários durante o projeto.

## Decisões Técnicas do Projeto

### Uso de `INT GENERATED ALWAYS AS IDENTITY`

Inicialmente os identificadores das tabelas foram definidos como `INT PRIMARY KEY`.
Durante a evolução do projeto, optou-se por utilizar:

`INT GENERATED ALWAYS AS IDENTITY`

Motivos da decisão:

- Garante geração automática e sequencial dos identificadores.
- Reduz risco de erro manual na atribuição de IDs.
- Segue padrão SQL moderno (substituindo o uso de `SERIAL`).

Essa abordagem mantém integridade referencial e melhora a escalabilidade do sistema.