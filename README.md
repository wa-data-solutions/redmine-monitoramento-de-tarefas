# redmine-monitoramento-de-tarefas - SQL
Scripts SQL para monitoramento de tarefas do Redmine. Pode ser adaptado de acordo com o SGBD em que o Redmine foi instalado, para posteriormente ser usado para criação de Dataset em DW e consumido por um Dataflow pelo Microsoft Fabric.

# informações técnicas
🔴 script-redmine-versoes-projetos-tarefas-vinculadas-baseline-origem.sql

- Essa consulta tem como objetivo mapear as versões (Versions) do Redmine, relacionando-as ao projeto, às tarefas vinculadas e ao campo personalizado "Versão Baseline Origem". Ela é muito útil para auditoria, governança de projetos e construção de dashboards.

- O que ela busca?

- A consulta percorre quatro entidades principais do Redmine:

versions → versões/releases do projeto.
projects → projeto ao qual a versão pertence.
issues → tarefas associadas à versão.
custom_values / custom_fields → campo personalizado "Versão Baseline Origem".

O relacionamento fica assim:

Projeto
   │
   └── Versão
          │
          ├── Campo Personalizado
          │      └── Versão Baseline Origem
          │
          └── Tarefas (Issues)

- Explicação de cada campo:

| Campo              | Descrição                                             |
| ------------------ | ----------------------------------------------------- |
| `v.id`             | ID da versão                                          |
| `v.name`           | Nome da versão (Sprint, Release, Marco etc.)          |
| `cv.value`         | Valor do campo personalizado "Versão Baseline Origem" |
| `v.effective_date` | Data planejada da versão                              |
| `p.id`             | ID do projeto                                         |
| `p.name`           | Nome do projeto                                       |
| `i.id`             | ID da tarefa vinculada                                |
| `i.subject`        | Nome da tarefa                                        |

------------------------------------------------------------------------------------------------------------------
🔴 script-redmine-monitoramento-de-tarefas.sql

- Essa consulta é bem mais completa e pode ser considerada um dataset operacional de tarefas do Redmine, ideal para Power BI ou para acompanhamento gerencial. O objetivo dela é consolidar informações de tarefas pai e subtarefas, juntamente com responsáveis, status, prioridades e campos customizados.

- O que essa consulta busca?

- Ela monta uma visão única contendo:

Projeto (Unidade)
Tarefa Pai
Subtarefa
Responsável
Status
Prioridade
Datas
Percentual concluído
Descrição
Campos personalizados ("Projeto Estratégico" e "Impedida")

- Em outras palavras:

Projeto
    │
    ├── Tarefa Pai
    │       │
    │       ├── Status
    │       ├── Prioridade
    │       ├── Datas
    │       ├── Projeto Estratégico
    │       └── Impedida
    │
    └── Subtarefas
            │
            ├── Responsável
            ├── Status
            ├── Datas
            ├── Projeto Estratégico
            └── Impedida





Desenvolvedor: WENDRIL ARAUJO FERREIRA (Engenheiro de Dados)








