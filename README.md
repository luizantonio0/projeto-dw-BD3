# 📊 Projeto Data Warehouse - BD3# Projeto BD3 - Data Warehouse e Migração PostgreSQL


## 🎯 Visão GeralEste repositório contém todos os arquivos relacionados ao projeto BD3, incluindo scripts de Data Warehouse e migração do banco de dados para PostgreSQL (Supabase).



Este projeto implementa uma **migração completa de MySQL para PostgreSQL** seguida da construção de um **Data Warehouse (DW)** para análises de negócio.


## 🚀 Implementação Passo a Passo

### 2. Migração Manual
Se preferir fazer manualmente, use os arquivos da pasta `03-migracao-postgresql/`:

### **FASE 1: Migração do Backup Original**
1. Execute primeiro `BD_VAREJO_PostgreSQL_DDL.sql` (estrutura)

2. Depois execute `BD_VAREJO_PostgreSQL_DML.sql` (dados)

#### 1️⃣ Conversão Automática MySQL → PostgreSQL

```bash

cd 04-ferramentas

python converter_sql.py

```

**O que faz:**

- Converte sintaxe SQL Server/MySQL para PostgreSQL

- Gera `BD_VAREJO_PostgreSQL_DDL.sql` (estrutura)

- Gera `BD_VAREJO_PostgreSQL_DML.sql` (dados)


#### 2️⃣ Implementar no Supabase

```sql

-- 1. Executar estrutura

\i BD_VAREJO_PostgreSQL_DDL.sql


-- 2. Inserir dados

### Principais tabelas:

\i BD_VAREJO_PostgreSQL_DML.sql

- `tb001_uf` - Estados brasileiros

```- `tb002_cidades` - Cidades

- `tb003_enderecos` - Endereços completos

**Resultado:** Sistema operacional básico funcionando

- `tb004_lojas` - Lojas da rede

- `tb005_funcionarios` - Funcionários

---- `tb006_cargos` - Cargos e funções

- `tb010_clientes` - Clientes

### **FASE 2: Sistema Operacional Melhorado (OLTP)**- `tb012_produtos` - Produtos

- `tb013_categorias` - Categorias de produtos

#### 3️⃣ Estrutura OLTP Profissional- `tb010_012_vendas` - Vendas realizadas

```sql- `tb012_017_compras` - Compras de fornecedores

\i bd3_projeto_dw_tables_creating.sql- `tb017_fornecedores` - Fornecedores

```

## 🔧 Tecnologias

**Cria:** 19 tabelas normalizadas (3NF)

- `tb001_uf` - Estados- **Banco Original**: MySQL/SQL Server

- `tb002_cidades` - Municípios- **Banco Destino**: PostgreSQL (Supabase)

- `tb003_enderecos` - Endereços- **Ferramentas**: Python 3.x

- `tb004_lojas` - Filiais- **Controle de Versão**: Git

- `tb005_funcionarios` - Colaboradores

- `tb006_cargos` - Hierarquia## 📋 Principais Conversões Realizadas

- `tb010_clientes` - Base clientes

- `tb012_produtos` - Catálogo- `NUMERIC(n) IDENTITY` → `SERIAL`

- `tb013_categorias` - Classificação- `NUMERIC(n,m)` → `DECIMAL(n,m)`

- E mais...- `datetime` → `TIMESTAMP`

- Remoção de comandos `GO` e `USE`

#### 4️⃣ Dados de Exemplo- Conversão de formato de datas

```sql- Ajuste de sintaxe de constraints

\i bd3_projeto_dw_tables_inserts.sql

```## 🆘 Suporte



**Insere:**Para dúvidas ou problemas:

- 27 UFs brasileiras1. Consulte o arquivo `INSTRUCOES_EXECUCAO.md`

- 50+ cidades2. Verifique os logs de erro no Supabase

- 40 funcionários3. Execute os scripts em partes menores se necessário

- 68 produtos

- Centenas de vendas/compras---



---**Última atualização**: Setembro 2025

**Versão**: 1.0
### **FASE 3: Data Warehouse (OLAP)**

#### 5️⃣ Estrutura Analítica (Star Schema)
```sql
\i bd3_projeto_dw_ddl_creating.sql
```

**Cria Dimensões:**
- `dim_tempo` - Calendário completo
- `dim_localidade` - Geografia agregada
- `dim_funcionario` - Dados funcionários
- `dim_cliente` - Base clientes
- `dim_produto` - Catálogo produtos

**Cria Tabelas Fato:**
- `fato_vendas` - Transações vendas
- `fato_atendimentos` - Histórico atendimentos

#### 6️⃣ Popular Dimensão Tempo
```sql
\i bd3_projeto_dw_etl_dim_tempo_insert.sql
```
**731 registros** (2020-2022) com metadados:
- Trimestre, semana do ano
- Feriados, fins de semana
- Formato YYYYMMDD para joins

#### 7️⃣ ETL das Dimensões
```sql
\i bd3_projeto_dw_etl_dim_funcionario.sql
\i bd3_projeto_dw_etl_dim_localidade.sql
```

**Transforma:** Dados OLTP → Formato analítico

---

## 🏗️ Arquitetura de Dados

### **OLTP (Sistema Operacional)**
```sql
-- Exemplo: Registrar venda
INSERT INTO tb010_012_vendas 
VALUES ('12345678901', 25, 1, '2025-09-22', 2, 1299.99);
```
**Foco:** Transações rápidas, integridade

### **OLAP (Data Warehouse)**
```sql
-- Exemplo: Análise trimestral
SELECT 
    dt.trimestre,
    dt.ano,
    SUM(fv.valor_total) as faturamento
FROM fato_vendas fv
JOIN dim_tempo dt ON fv.id_tempo = dt.id_tempo
WHERE dt.ano = 2025
GROUP BY dt.trimestre, dt.ano;
```
**Foco:** Consultas analíticas, relatórios

---

## 🎯 Casos de Uso

### **📈 Análises Possíveis:**

1. **Vendas por Período**
   - Faturamento mensal/trimestral
   - Sazonalidade de produtos

2. **Performance Regional**
   - Vendas por UF/cidade
   - Ranking de lojas

3. **Gestão de Pessoas**
   - Produtividade por funcionário
   - Análise de comissões

4. **Inteligência de Produtos**
   - Produtos mais vendidos
   - Margem por categoria

---

## 📋 Validação

Execute para verificar implementação:
```sql
\i bd3_projeto_dw_selects.sql
```

**Valida:**
- Integridade dos dados
- Contagem de registros
- Consistência entre OLTP/DW