-- =========================================
-- MIGRAÇÃO BD_VAREJO para PostgreSQL (Supabase)
-- Script DDL - Estrutura das Tabelas
-- =========================================

-- Remover tabelas se existirem (em ordem de dependências)
DROP TABLE IF EXISTS tb010_012_vendas CASCADE;
DROP TABLE IF EXISTS tb012_017_compras CASCADE;
DROP TABLE IF EXISTS tb014_prd_alimentos CASCADE;
DROP TABLE IF EXISTS tb015_prd_eletros CASCADE;
DROP TABLE IF EXISTS tb016_prd_vestuarios CASCADE;
DROP TABLE IF EXISTS tb011_logins CASCADE;
DROP TABLE IF EXISTS tb010_clientes_antigos CASCADE;
DROP TABLE IF EXISTS tb010_clientes CASCADE;
DROP TABLE IF EXISTS tb012_produtos CASCADE;
DROP TABLE IF EXISTS tb013_categorias CASCADE;
DROP TABLE IF EXISTS tb017_fornecedores CASCADE;
DROP TABLE IF EXISTS tb005_006_funcionarios_cargos CASCADE;
DROP TABLE IF EXISTS tb005_funcionarios CASCADE;
DROP TABLE IF EXISTS tb006_cargos CASCADE;
DROP TABLE IF EXISTS tb004_lojas CASCADE;
DROP TABLE IF EXISTS tb003_enderecos CASCADE;
DROP TABLE IF EXISTS tb002_cidades CASCADE;
DROP TABLE IF EXISTS tb001_uf CASCADE;
DROP TABLE IF EXISTS tb999_log CASCADE;

-- =========================================
-- CRIANDO TABELAS
-- =========================================

-- Tabela: tb001_uf
CREATE TABLE tb001_uf (
    tb001_sigla_uf       VARCHAR(2)  NOT NULL,
    tb001_nome_estado    VARCHAR(255)  NOT NULL
);

-- Tabela: tb002_cidades
CREATE TABLE tb002_cidades (
    tb002_cod_cidade     INTEGER  IDENTITY ( 1,
    1 ),
    tb001_sigla_uf       VARCHAR(2)  NOT NULL,
    tb002_nome_cidade    VARCHAR(255)  NOT NULL
);

-- Tabela: tb003_enderecos
CREATE TABLE tb003_enderecos (
    tb003_cod_endereco   INTEGER  IDENTITY ( 1,
    1 ),
    tb001_sigla_uf       VARCHAR(2)  NOT NULL,
    tb002_cod_cidade     INTEGER  NOT NULL,
    tb003_nome_rua       VARCHAR(255)  NOT NULL,
    tb003_numero_rua     VARCHAR(10)  NOT NULL,
    tb003_complemento    VARCHAR(255)  NULL,
    tb003_ponto_referencia VARCHAR(255)  NULL,
    tb003_bairro         VARCHAR(255)  NOT NULL,
    tb003_CEP            VARCHAR(15)  NOT NULL
);

-- Tabela: tb004_lojas
CREATE TABLE tb004_lojas (
    tb004_cod_loja       INTEGER  IDENTITY ( 1,
    1 ),
    tb003_cod_endereco   INTEGER  NULL,
    tb004_matriz         INTEGER  NULL,
    tb004_cnpj_loja      VARCHAR(20)  NOT NULL,
    tb004_inscricao_estadual VARCHAR(20)  NULL
);

-- Tabela: tb005_006_funcionarios_cargos
CREATE TABLE tb005_006_funcionarios_cargos (
    tb005_matricula      INTEGER  NOT NULL,
    tb006_cod_cargo      INTEGER  NOT NULL,
    tb005_006_valor_cargo NUMERIC(10,
    2)  NOT NULL,
    tb005_006_perc_comissao_cargo NUMERIC(5,
    2)  NOT NULL,
    tb005_006_data_promocao TIMESTAMP  NOT NULL
);

-- Tabela: tb005_funcionarios
CREATE TABLE tb005_funcionarios (
    tb005_matricula      INTEGER  IDENTITY ( 1,
    1 ),
    tb004_cod_loja       INTEGER  NOT NULL,
    tb003_cod_endereco   INTEGER  NOT NULL,
    tb005_nome_completo  VARCHAR(255)  NOT NULL,
    tb005_data_nascimento TIMESTAMP  NOT NULL,
    tb005_CPF            VARCHAR(17)  NOT NULL,
    tb005_RG             VARCHAR(15)  NOT NULL,
    tb005_status         VARCHAR(20)  NOT NULL,
    tb005_data_contratacao TIMESTAMP  NOT NULL,
    tb005_data_demissao  TIMESTAMP  NULL
);

-- Tabela: tb006_cargos
CREATE TABLE tb006_cargos (
    tb006_cod_cargo      INTEGER  IDENTITY ( 1,
    1 ),
    tb006_nome_cargo     VARCHAR(255)  NOT NULL
);

-- Tabela: tb010_012_vendas
CREATE TABLE tb010_012_vendas (
    tb010_012_cod_venda  INTEGER  IDENTITY (1,
    1),
    tb010_cpf            INTEGER  NOT NULL,
    tb012_cod_produto    INTEGER  NOT NULL,
    tb005_matricula      INTEGER  NOT NULL,
    tb010_012_data       TIMESTAMP  NOT NULL,
    tb010_012_quantidade INTEGER  NOT NULL,
    tb010_012_valor_unitario NUMERIC(12,
    4)  NOT NULL
);

-- Tabela: tb010_clientes
CREATE TABLE tb010_clientes (
    tb010_cpf            INTEGER  NOT NULL,
    tb010_nome           VARCHAR(255)  NOT NULL,
    tb010_fone_residencial VARCHAR(255)  NOT NULL,
    tb010_fone_celular   VARCHAR(255)  NULL
);

-- Tabela: tb010_clientes_antigos
CREATE TABLE tb010_clientes_antigos (
    tb010_cpf            NUMERIC(15,
    0)  NOT NULL,
    tb010_nome           VARCHAR(255)  NULL
);

-- Tabela: tb011_logins
CREATE TABLE tb011_logins (
    tb011_logins         VARCHAR(255)  NOT NULL,
    tb010_cpf            INTEGER  NOT NULL,
    tb011_senha          VARCHAR(255)  NOT NULL,
    tb011_data_cadastro  TIMESTAMP  NULL
);

-- Tabela: tb012_017_compras
CREATE TABLE tb012_017_compras (
    tb012_017_cod_compra INTEGER IDENTITY ( 1,
    1 ),
    tb012_cod_produto    INTEGER  NOT NULL,
    tb017_cod_fornecedor INTEGER  NOT NULL,
    tb012_017_data       TIMESTAMP  NULL,
    tb012_017_quantidade INTEGER  NULL,
    tb012_017_valor_unitario NUMERIC(12,
    2)  NULL
);

-- Tabela: tb012_produtos
CREATE TABLE tb012_produtos (
    tb012_cod_produto    INTEGER  NOT NULL,
    tb013_cod_categoria  INTEGER  NOT NULL,
    tb012_descricao      VARCHAR(255)  NOT NULL
);

-- Tabela: tb013_categorias
CREATE TABLE tb013_categorias (
    tb013_cod_categoria  INTEGER  IDENTITY ( 1,
    1 ),
    tb013_descricao      VARCHAR(255)  NOT NULL
);

-- Tabela: tb014_prd_alimentos
CREATE TABLE tb014_prd_alimentos (
    tb014_cod_prd_alimentos INTEGER  IDENTITY ( 1,
    1 ),
    tb012_cod_produto    INTEGER  NOT NULL,
    tb014_detalhamento   VARCHAR(255)  NOT NULL,
    tb014_unidade_medida VARCHAR(255)  NOT NULL,
    tb014_num_lote       VARCHAR(255)  NULL,
    tb014_data_vencimento TIMESTAMP  NULL,
    tb014_valor_sugerido numeric(10,
    2)  NULL
);

-- Tabela: tb015_prd_eletros
CREATE TABLE tb015_prd_eletros (
    tb015_cod_prd_eletro INTEGER  IDENTITY ( 1,
    1 ),
    tb012_cod_produto    INTEGER  NOT NULL,
    tb015_detalhamento   VARCHAR(255)  NOT NULL,
    tb015_tensao         VARCHAR(255)  NULL,
    tb015_nivel_consumo_procel char(1)  NULL,
    tb015_valor_sugerido numeric(10,
    2)  NULL
);

-- Tabela: tb016_prd_vestuarios
CREATE TABLE tb016_prd_vestuarios (
    tb016_cod_prd_vestuario INTEGER  IDENTITY ( 1,
    1 ),
    tb012_cod_produto    INTEGER  NOT NULL,
    tb016_detalhamento   VARCHAR(255)  NOT NULL,
    tb016_sexo           CHAR(1)  NOT NULL,
    tb016_tamanho        VARCHAR(255)  NULL,
    tb016_numeracao      INTEGER  NULL,
    tb016_valor_sugerido numeric(10,
    2)  NULL
);

-- Tabela: tb017_fornecedores
CREATE TABLE tb017_fornecedores (
    tb017_cod_fornecedor INTEGER IDENTITY ( 1,
    1 ),
    tb017_razao_social   VARCHAR(255)  NULL,
    tb017_nome_fantasia  VARCHAR(255)  NULL,
    tb017_fone           VARCHAR(15)  NULL,
    tb003_cod_endereco   INTEGER  NULL
);

-- Tabela: tb999_log
CREATE TABLE tb999_log (
    tb999_cod_log        INTEGER IDENTITY ( 1,
    1 ),
    tb099_objeto         VARCHAR(100)  NOT NULL,
    tb999_dml            VARCHAR(25)  NOT NULL,
    tb999_data           TIMESTAMP  NOT NULL
);

-- =========================================
-- ADICIONANDO PRIMARY KEYS
-- =========================================

ALTER TABLE tb001_uf ADD CONSTRAINT XPKtb001_uf PRIMARY KEY (tb001_sigla_uf ASC);
ALTER TABLE tb002_cidades ADD CONSTRAINT XPKtb002_cidades PRIMARY KEY (tb002_cod_cidade ASC,tb001_sigla_uf ASC);
ALTER TABLE tb003_enderecos ADD CONSTRAINT XPKtb003_enderecos PRIMARY KEY (tb003_cod_endereco ASC);
ALTER TABLE tb004_lojas ADD CONSTRAINT XPKtb004_lojas PRIMARY KEY (tb004_cod_loja ASC);
ALTER TABLE tb005_006_funcionarios_cargos ADD CONSTRAINT XPKtb005_006_funcionarios_cargos PRIMARY KEY (tb005_matricula ASC,tb006_cod_cargo ASC);
ALTER TABLE tb005_funcionarios ADD CONSTRAINT XPKtb005_funcionarios PRIMARY KEY (tb005_matricula ASC);
ALTER TABLE tb006_cargos ADD CONSTRAINT XPKtb006_cargos PRIMARY KEY (tb006_cod_cargo ASC);
ALTER TABLE tb010_012_vendas ADD CONSTRAINT XPKtb010_012_vendas PRIMARY KEY (tb010_012_cod_venda ASC,tb005_matricula ASC,tb010_cpf ASC,tb012_cod_produto ASC);
ALTER TABLE tb010_clientes ADD CONSTRAINT XPKtb010_clientes PRIMARY KEY (tb010_cpf ASC);
ALTER TABLE tb010_clientes_antigos ADD CONSTRAINT XPKtb010_clientes_antigos PRIMARY KEY (tb010_cpf ASC);
ALTER TABLE tb011_logins ADD CONSTRAINT XPKtb011_logins PRIMARY KEY (tb011_logins ASC);
ALTER TABLE tb012_017_compras ADD CONSTRAINT XPKtb017_compras PRIMARY KEY (tb012_017_cod_compra ASC,tb012_cod_produto ASC,tb017_cod_fornecedor ASC);
ALTER TABLE tb012_produtos ADD CONSTRAINT XPKtb012_produtos PRIMARY KEY (tb012_cod_produto ASC);
ALTER TABLE tb013_categorias ADD CONSTRAINT XPKtb013_categorias PRIMARY KEY (tb013_cod_categoria ASC);
ALTER TABLE tb014_prd_alimentos ADD CONSTRAINT XPKtb014_prd_alimentos PRIMARY KEY (tb014_cod_prd_alimentos ASC,tb012_cod_produto ASC);
ALTER TABLE tb015_prd_eletros ADD CONSTRAINT XPKtb015_prd_tvs PRIMARY KEY (tb015_cod_prd_eletro ASC,tb012_cod_produto ASC);
ALTER TABLE tb016_prd_vestuarios ADD CONSTRAINT XPKtb016_refrigeradores PRIMARY KEY (tb016_cod_prd_vestuario ASC,tb012_cod_produto ASC);
ALTER TABLE tb017_fornecedores ADD CONSTRAINT XPKtb017_fornecedor PRIMARY KEY (tb017_cod_fornecedor ASC);
ALTER TABLE tb999_log ADD CONSTRAINT XPKtb999_log PRIMARY KEY (tb999_cod_log ASC);

-- =========================================
-- ADICIONANDO FOREIGN KEYS
-- =========================================

ALTER TABLE tb002_cidades
    ADD CONSTRAINT CONST_UF_CIDADE
    FOREIGN KEY (tb001_sigla_uf)
    REFERENCES tb001_uf(tb001_sigla_uf);

ALTER TABLE tb003_enderecos
    ADD CONSTRAINT CONST_CIDADE_END
    FOREIGN KEY (tb002_cod_cidade,tb001_sigla_uf)
    REFERENCES tb002_cidades(tb002_cod_cidade,tb001_sigla_uf);

ALTER TABLE tb004_lojas
    ADD CONSTRAINT CONST_END_LOJAS
    FOREIGN KEY (tb003_cod_endereco)
    REFERENCES tb003_enderecos(tb003_cod_endereco);

ALTER TABLE tb005_006_funcionarios_cargos
    ADD CONSTRAINT CONST_FUNC_FUNCCARGO
    FOREIGN KEY (tb005_matricula)
    REFERENCES tb005_funcionarios(tb005_matricula);

ALTER TABLE tb005_006_funcionarios_cargos
    ADD CONSTRAINT CONST_CARGO_FUNCCARGO
    FOREIGN KEY (tb006_cod_cargo)
    REFERENCES tb006_cargos(tb006_cod_cargo);

ALTER TABLE tb005_funcionarios
    ADD CONSTRAINT CONST_END_FUNC
    FOREIGN KEY (tb003_cod_endereco)
    REFERENCES tb003_enderecos(tb003_cod_endereco);

ALTER TABLE tb005_funcionarios
    ADD CONSTRAINT CONST_LOJAS_FUNC
    FOREIGN KEY (tb004_cod_loja)
    REFERENCES tb004_lojas(tb004_cod_loja);

ALTER TABLE tb010_012_vendas
    ADD CONSTRAINT CONST_FUNC_VENDAS
    FOREIGN KEY (tb005_matricula)
    REFERENCES tb005_funcionarios(tb005_matricula);

ALTER TABLE tb010_012_vendas
    ADD CONSTRAINT CONST_CLI_VENDAS
    FOREIGN KEY (tb010_cpf)
    REFERENCES tb010_clientes(tb010_cpf);

ALTER TABLE tb010_012_vendas
    ADD CONSTRAINT CONST_PRD_VENDAS
    FOREIGN KEY (tb012_cod_produto)
    REFERENCES tb012_produtos(tb012_cod_produto);

ALTER TABLE tb011_logins
    ADD CONSTRAINT CONST_CLI_LOGIN
    FOREIGN KEY (tb010_cpf)
    REFERENCES tb010_clientes(tb010_cpf);

ALTER TABLE tb012_017_compras
    ADD CONSTRAINT CONST_PRD_COMPRAS
    FOREIGN KEY (tb012_cod_produto)
    REFERENCES tb012_produtos(tb012_cod_produto);

ALTER TABLE tb012_017_compras
    ADD CONSTRAINT CONST_FORN_COMPRAS
    FOREIGN KEY (tb017_cod_fornecedor)
    REFERENCES tb017_fornecedores(tb017_cod_fornecedor);

ALTER TABLE tb012_produtos
    ADD CONSTRAINT CONST_CAT_PRD
    FOREIGN KEY (tb013_cod_categoria)
    REFERENCES tb013_categorias(tb013_cod_categoria);

ALTER TABLE tb014_prd_alimentos
    ADD CONSTRAINT CONST_PRD_ALIM
    FOREIGN KEY (tb012_cod_produto)
    REFERENCES tb012_produtos(tb012_cod_produto);

ALTER TABLE tb015_prd_eletros
    ADD CONSTRAINT CONST_PRD_ELET
    FOREIGN KEY (tb012_cod_produto)
    REFERENCES tb012_produtos(tb012_cod_produto);

ALTER TABLE tb016_prd_vestuarios
    ADD CONSTRAINT CONST_PRD_VEST
    FOREIGN KEY (tb012_cod_produto)
    REFERENCES tb012_produtos(tb012_cod_produto);

ALTER TABLE tb017_fornecedores
    ADD CONSTRAINT CONST_END_FORN
    FOREIGN KEY (tb003_cod_endereco)
    REFERENCES tb003_enderecos(tb003_cod_endereco);

-- =========================================
-- ESTRUTURA CRIADA COM SUCESSO!
-- =========================================