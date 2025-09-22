# 📊 Projeto BD3 — Data Warehouse em PostgreSQL

## 🎯 Visão geral
Este repositório contém a migração do banco de dados transacional BD_VAREJO para PostgreSQL e a construção de um Data Warehouse (DW) em esquema estrela para análises. Os scripts foram pensados para execução local (psql) ou em serviços compatíveis (ex.: Supabase SQL Editor).

---

## 🗂️ Estrutura do repositório
- `01-backup-original/BD_VAREJO.sql` — backup original (referência; não executar no PostgreSQL)
- `02-scripts-dw/`
  - `1_bd3_projeto_dw_tables_creating.sql` — alternativa de DDL OLTP (opcional)
  - `2_bd3_projeto_dw_tables_inserts.sql` — carga de dados OLTP (com reset seguro via TRUNCATE CASCADE)
  - `3_bd3_projeto_dw_ddl_creating.sql` — DDL do DW (dimensões e fatos)
  - `4_bd3_projeto_dw_etl_dim_tempo_insert.sql` — carga da dimensão tempo (2020–2022)
  - `5_bd3_projeto_dw_etl_dim_funcionario.sql` — ETL p/ dimensão funcionário
  - `6_bd3_projeto_dw_etl_dim_localidade.sql` — ETL p/ dimensão localidade
  - `bd3_projeto_dw_selects.sql` — consultas de validação do DW
- `03-migracao-postgresql/`
  - `BD_VAREJO_PostgreSQL_DDL.sql` — DDL migrado do BD_VAREJO (autoridade para OLTP)
  - `BD_VAREJO_PostgreSQL_DML.sql` — DML migrado com dados de exemplo
- `04-ferramentas/converter_sql.py` — conversor (MySQL/SQL Server → PostgreSQL)

---

## � Ordem de execução sugerida

Você tem duas formas de preparar o OLTP (BD_VAREJO). Escolha uma única opção (A ou B):

### Opção A) Migração oficial do BD_VAREJO (recomendado)
1. Execute `03-migracao-postgresql/BD_VAREJO_PostgreSQL_DDL.sql` (estrutura)
2. Execute `03-migracao-postgresql/BD_VAREJO_PostgreSQL_DML.sql` (dados)

Notas:
- Esses arquivos são a “fonte da verdade” do esquema OLTP migrado. Não altere o DDL gerado pelo conversor.
- Se preferir recriar os dados do zero, pule o DML e utilize a Opção B.

### Opção B) Criar e popular OLTP via scripts do projeto
1. (Opcional) `02-scripts-dw/1_bd3_projeto_dw_tables_creating.sql` — cria o esquema OLTP (caso não use o DDL da pasta 03)
2. `02-scripts-dw/2_bd3_projeto_dw_tables_inserts.sql` — reseta e insere dados de exemplo

Importante sobre o arquivo 2_bd3_projeto_dw_tables_inserts.sql:
- Inicia com `TRUNCATE ... RESTART IDENTITY CASCADE` para limpar com segurança respeitando FKs.
- Garante que `tb012_produtos.tb012_cod_produto` funcione como identity se necessário (evita erro de NOT NULL ao inserir sem PK).

### Fase DW (OLAP)
3. `02-scripts-dw/3_bd3_projeto_dw_ddl_creating.sql` — cria as dimensões e fatos:
   - Dimensões: `dim_tempo`, `dim_localidade`, `dim_funcionario`, `dim_cliente`, `dim_produto`
   - Fatos: `fato_vendas`, `fato_atendimentos` (com índices para chaves de dimensão)
4. Popular dimensões (na ordem abaixo):
   - `02-scripts-dw/4_bd3_projeto_dw_etl_dim_tempo_insert.sql`
   - `02-scripts-dw/5_bd3_projeto_dw_etl_dim_funcionario.sql`
   - `02-scripts-dw/6_bd3_projeto_dw_etl_dim_localidade.sql`
5. Consultas de validação do DW:
   - `02-scripts-dw/bd3_projeto_dw_selects.sql`


---

## 🧪 Validação rápida
Após criar o DW e popular as dimensões, execute o conteúdo do arquivo: 

   - `02-scripts-dw/bd3_projeto_dw_selects.sql`
