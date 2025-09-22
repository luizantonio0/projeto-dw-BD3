CREATE TABLE IF NOT EXISTS tb001_uf (
    tb001_sigla_uf VARCHAR(2) NOT NULL,
    tb001_nome_estado VARCHAR(255) NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb001_uf'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb001_uf
            ADD CONSTRAINT XPKtb001_uf PRIMARY KEY (tb001_sigla_uf);
    END IF;
END
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS tb002_cidades (
    tb002_cod_cidade SERIAL,
    tb001_sigla_uf VARCHAR(2) NOT NULL,
    tb002_nome_cidade VARCHAR(255) NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb002_cidades'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb002_cidades
            ADD CONSTRAINT XPKtb002_cidades PRIMARY KEY (tb002_cod_cidade, tb001_sigla_uf);
    END IF;
END
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS tb003_enderecos (
    tb003_cod_endereco SERIAL,
    tb001_sigla_uf VARCHAR(2) NOT NULL,
    tb002_cod_cidade INTEGER NOT NULL,
    tb003_nome_rua VARCHAR(255) NOT NULL,
    tb003_numero_rua VARCHAR(10) NOT NULL,
    tb003_complemento VARCHAR(255) NULL,
    tb003_ponto_referencia VARCHAR(255) NULL,
    tb003_bairro VARCHAR(255) NOT NULL,
    tb003_CEP VARCHAR(15) NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb003_enderecos'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb003_enderecos
            ADD CONSTRAINT XPKtb003_enderecos PRIMARY KEY (tb003_cod_endereco);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para Lojas
CREATE TABLE IF NOT EXISTS tb004_lojas (
    tb004_cod_loja SERIAL,
    tb003_cod_endereco INTEGER NULL,
    tb004_matriz INTEGER NULL,
    tb004_cnpj_loja VARCHAR(20) NOT NULL,
    tb004_inscricao_estadual VARCHAR(20) NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb004_lojas'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb004_lojas
            ADD CONSTRAINT XPKtb004_lojas PRIMARY KEY (tb004_cod_loja);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela de relacionamento entre Funcionários e Cargos
CREATE TABLE IF NOT EXISTS tb005_006_funcionarios_cargos (
    tb005_matricula INTEGER NOT NULL,
    tb006_cod_cargo INTEGER NOT NULL,
    tb005_006_valor_cargo NUMERIC(10,2) NOT NULL,
    tb005_006_perc_comissao_cargo NUMERIC(5,2) NOT NULL,
    tb005_006_data_promocao TIMESTAMP NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb005_006_funcionarios_cargos'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb005_006_funcionarios_cargos
            ADD CONSTRAINT XPKtb005_006_funcionarios_cargos PRIMARY KEY (tb005_matricula, tb006_cod_cargo);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para Funcionários
CREATE TABLE IF NOT EXISTS tb005_funcionarios (
    tb005_matricula SERIAL,
    tb004_cod_loja INTEGER NOT NULL,
    tb003_cod_endereco INTEGER NOT NULL,
    tb005_nome_completo VARCHAR(255) NOT NULL,
    tb005_data_nascimento DATE NOT NULL,
    tb005_CPF VARCHAR(17) NOT NULL,
    tb005_RG VARCHAR(15) NOT NULL,
    tb005_status VARCHAR(20) NOT NULL,
    tb005_data_contratacao DATE NOT NULL,
    tb005_data_demissao DATE NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb005_funcionarios'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb005_funcionarios
            ADD CONSTRAINT XPKtb005_funcionarios PRIMARY KEY (tb005_matricula);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para Cargos
CREATE TABLE IF NOT EXISTS tb006_cargos (
    tb006_cod_cargo SERIAL,
    tb006_nome_cargo VARCHAR(255) NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb006_cargos'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb006_cargos
            ADD CONSTRAINT XPKtb006_cargos PRIMARY KEY (tb006_cod_cargo);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para Vendas
CREATE TABLE IF NOT EXISTS tb010_012_vendas (
    tb010_012_cod_venda SERIAL,
    tb010_cpf VARCHAR(15) NOT NULL,
    tb012_cod_produto INTEGER NOT NULL,
    tb005_matricula INTEGER NOT NULL,
    tb010_012_data TIMESTAMP NOT NULL,
    tb010_012_quantidade INTEGER NOT NULL,
    tb010_012_valor_unitario NUMERIC(12,4) NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb010_012_vendas'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb010_012_vendas
            ADD CONSTRAINT XPKtb010_012_vendas PRIMARY KEY (tb010_012_cod_venda, tb005_matricula, tb010_cpf, tb012_cod_produto);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para Clientes
CREATE TABLE IF NOT EXISTS tb010_clientes (
    tb010_cpf VARCHAR(15) NOT NULL,
    tb010_nome VARCHAR(255) NOT NULL,
    tb010_fone_residencial VARCHAR(255) NOT NULL,
    tb010_fone_celular VARCHAR(255) NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb010_clientes'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb010_clientes
            ADD CONSTRAINT XPKtb010_clientes PRIMARY KEY (tb010_cpf);
    END IF;
END
$$ LANGUAGE plpgsql;


-- Tabela para clientes antigos
CREATE TABLE IF NOT EXISTS tb010_clientes_antigos (
    tb010_cpf VARCHAR(15) NOT NULL,
    tb010_nome VARCHAR(255) NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb010_clientes_antigos'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb010_clientes_antigos
            ADD CONSTRAINT XPKtb010_clientes_antigos PRIMARY KEY (tb010_cpf);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para logins
CREATE TABLE IF NOT EXISTS tb011_logins (
    tb011_logins VARCHAR(255) NOT NULL,
    tb010_cpf VARCHAR(15) NOT NULL,
    tb011_senha VARCHAR(255) NOT NULL,
    tb011_data_cadastro TIMESTAMP NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb011_logins'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb011_logins
            ADD CONSTRAINT XPKtb011_logins PRIMARY KEY (tb011_logins);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para compras
CREATE TABLE IF NOT EXISTS tb012_017_compras (
    tb012_017_cod_compra SERIAL,
    tb012_cod_produto INTEGER NOT NULL,
    tb017_cod_fornecedor INTEGER NOT NULL,
    tb012_017_data TIMESTAMP NULL,
    tb012_017_quantidade INTEGER NULL,
    tb012_017_valor_unitario NUMERIC(12,2) NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb012_017_compras'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb012_017_compras
            ADD CONSTRAINT XPKtb017_compras PRIMARY KEY (tb012_017_cod_compra, tb012_cod_produto, tb017_cod_fornecedor);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para produtos
CREATE TABLE IF NOT EXISTS tb012_produtos (
    tb012_cod_produto SERIAL,
    tb013_cod_categoria INTEGER NOT NULL,
    tb012_descricao VARCHAR(255) NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb012_produtos'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb012_produtos
            ADD CONSTRAINT XPKtb012_produtos PRIMARY KEY (tb012_cod_produto);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para categorias
CREATE TABLE IF NOT EXISTS tb013_categorias (
    tb013_cod_categoria SERIAL,
    tb013_descricao VARCHAR(255) NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb013_categorias'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb013_categorias
            ADD CONSTRAINT XPKtb013_categorias PRIMARY KEY (tb013_cod_categoria);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para produtos alimentícios
CREATE TABLE IF NOT EXISTS tb014_prd_alimentos (
    tb014_cod_prd_alimentos SERIAL,
    tb012_cod_produto INTEGER NOT NULL,
    tb014_detalhamento VARCHAR(255) NOT NULL,
    tb014_unidade_medida VARCHAR(255) NOT NULL,
    tb014_num_lote VARCHAR(255) NULL,
    tb014_data_vencimento TIMESTAMP NULL,
    tb014_valor_sugerido NUMERIC(10,2) NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb014_prd_alimentos'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb014_prd_alimentos
            ADD CONSTRAINT XPKtb014_prd_alimentos PRIMARY KEY (tb014_cod_prd_alimentos, tb012_cod_produto);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para produtos eletrônicos
CREATE TABLE IF NOT EXISTS tb015_prd_eletros (
    tb015_cod_prd_eletro SERIAL,
    tb012_cod_produto INTEGER NOT NULL,
    tb015_detalhamento VARCHAR(255) NOT NULL,
    tb015_tensao VARCHAR(255) NULL,
    tb015_nivel_consumo_procel CHAR(1) NULL,
    tb015_valor_sugerido NUMERIC(10,2) NULL
);

-- Tabela para produtos eletrônicos (continuação)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb015_prd_eletros'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb015_prd_eletros
            ADD CONSTRAINT XPKtb015_prd_eletros PRIMARY KEY (tb015_cod_prd_eletro, tb012_cod_produto);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para produtos de vestuário
CREATE TABLE IF NOT EXISTS tb016_prd_vestuarios (
    tb016_cod_prd_vestuario SERIAL,
    tb012_cod_produto INTEGER NOT NULL,
    tb016_detalhamento VARCHAR(255) NOT NULL,
    tb016_sexo CHAR(1) NOT NULL,
    tb016_tamanho VARCHAR(255) NULL,
    tb016_numeracao INTEGER NULL,
    tb016_valor_sugerido NUMERIC(10,2) NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb016_prd_vestuarios'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb016_prd_vestuarios
            ADD CONSTRAINT XPKtb016_prd_vestuarios PRIMARY KEY (tb016_cod_prd_vestuario, tb012_cod_produto);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela para fornecedores
CREATE TABLE IF NOT EXISTS tb017_fornecedores (
    tb017_cod_fornecedor SERIAL,
    tb017_razao_social VARCHAR(255) NULL,
    tb017_nome_fantasia VARCHAR(255) NULL,
    tb017_fone VARCHAR(15) NULL,
    tb003_cod_endereco INTEGER NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb017_fornecedores'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb017_fornecedores
            ADD CONSTRAINT XPKtb017_fornecedores PRIMARY KEY (tb017_cod_fornecedor);
    END IF;
END
$$ LANGUAGE plpgsql;

-- Tabela de log
CREATE TABLE IF NOT EXISTS tb999_log (
    tb999_cod_log SERIAL,
    tb099_objeto VARCHAR(100) NOT NULL,
    tb999_dml VARCHAR(25) NOT NULL,
    tb999_data TIMESTAMP NOT NULL
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'tb999_log'::regclass
          AND contype = 'p'
    ) THEN
        ALTER TABLE tb999_log
            ADD CONSTRAINT XPKtb999_log PRIMARY KEY (tb999_cod_log);
    END IF;
END
$$ LANGUAGE plpgsql;


DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb002_cidades'::regclass
                    AND lower(conname) = lower('CONST_UF_CIDADE')
        ) THEN
        ALTER TABLE tb002_cidades
            ADD CONSTRAINT CONST_UF_CIDADE FOREIGN KEY (tb001_sigla_uf) REFERENCES tb001_uf(tb001_sigla_uf)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb003_enderecos'::regclass
                    AND lower(conname) = lower('CONST_CIDADE_END')
        ) THEN
        ALTER TABLE tb003_enderecos
            ADD CONSTRAINT CONST_CIDADE_END FOREIGN KEY (tb002_cod_cidade,tb001_sigla_uf) REFERENCES tb002_cidades(tb002_cod_cidade,tb001_sigla_uf)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb004_lojas'::regclass
                    AND lower(conname) = lower('CONST_END_LOJAS')
        ) THEN
        ALTER TABLE tb004_lojas
            ADD CONSTRAINT CONST_END_LOJAS FOREIGN KEY (tb003_cod_endereco) REFERENCES tb003_enderecos(tb003_cod_endereco)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb005_006_funcionarios_cargos'::regclass
                    AND lower(conname) = lower('CONST_FUNC_FUNCCARGO')
        ) THEN
        ALTER TABLE tb005_006_funcionarios_cargos
            ADD CONSTRAINT CONST_FUNC_FUNCCARGO FOREIGN KEY (tb005_matricula) REFERENCES tb005_funcionarios(tb005_matricula)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb005_006_funcionarios_cargos'::regclass
                    AND lower(conname) = lower('CONST_CARGO_FUNCCARGO')
        ) THEN
        ALTER TABLE tb005_006_funcionarios_cargos
            ADD CONSTRAINT CONST_CARGO_FUNCCARGO FOREIGN KEY (tb006_cod_cargo) REFERENCES tb006_cargos(tb006_cod_cargo)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb005_funcionarios'::regclass
                    AND lower(conname) = lower('CONST_END_FUNC')
        ) THEN
        ALTER TABLE tb005_funcionarios
            ADD CONSTRAINT CONST_END_FUNC FOREIGN KEY (tb003_cod_endereco) REFERENCES tb003_enderecos(tb003_cod_endereco)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb005_funcionarios'::regclass
                    AND lower(conname) = lower('CONST_LOJAS_FUNC')
        ) THEN
        ALTER TABLE tb005_funcionarios
            ADD CONSTRAINT CONST_LOJAS_FUNC FOREIGN KEY (tb004_cod_loja) REFERENCES tb004_lojas(tb004_cod_loja)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb010_012_vendas'::regclass
                    AND lower(conname) = lower('CONST_FUNC_VENDAS')
        ) THEN
        ALTER TABLE tb010_012_vendas
            ADD CONSTRAINT CONST_FUNC_VENDAS FOREIGN KEY (tb005_matricula) REFERENCES tb005_funcionarios(tb005_matricula)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb010_012_vendas'::regclass
                    AND lower(conname) = lower('CONST_CLI_VENDAS')
        ) THEN
        ALTER TABLE tb010_012_vendas
            ADD CONSTRAINT CONST_CLI_VENDAS FOREIGN KEY (tb010_cpf) REFERENCES tb010_clientes(tb010_cpf)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb010_012_vendas'::regclass
                    AND lower(conname) = lower('CONST_PRD_VENDAS')
        ) THEN
        ALTER TABLE tb010_012_vendas
            ADD CONSTRAINT CONST_PRD_VENDAS FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb011_logins'::regclass
                    AND lower(conname) = lower('CONST_CLI_LOGIN')
        ) THEN
        ALTER TABLE tb011_logins
            ADD CONSTRAINT CONST_CLI_LOGIN FOREIGN KEY (tb010_cpf) REFERENCES tb010_clientes(tb010_cpf)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb012_017_compras'::regclass
                    AND lower(conname) = lower('CONST_PRD_COMPRAS')
        ) THEN
        ALTER TABLE tb012_017_compras
            ADD CONSTRAINT CONST_PRD_COMPRAS FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb012_017_compras'::regclass
                    AND lower(conname) = lower('CONST_FORN_COMPRAS')
        ) THEN
        ALTER TABLE tb012_017_compras
            ADD CONSTRAINT CONST_FORN_COMPRAS FOREIGN KEY (tb017_cod_fornecedor) REFERENCES tb017_fornecedores(tb017_cod_fornecedor)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb012_produtos'::regclass
                    AND lower(conname) = lower('CONST_CAT_PRD')
        ) THEN
        ALTER TABLE tb012_produtos
            ADD CONSTRAINT CONST_CAT_PRD FOREIGN KEY (tb013_cod_categoria) REFERENCES tb013_categorias(tb013_cod_categoria)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb014_prd_alimentos'::regclass
                    AND lower(conname) = lower('CONST_PRD_ALIM')
        ) THEN
        ALTER TABLE tb014_prd_alimentos
            ADD CONSTRAINT CONST_PRD_ALIM FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb015_prd_eletros'::regclass
                    AND lower(conname) = lower('CONST_PRD_ELET')
        ) THEN
        ALTER TABLE tb015_prd_eletros
            ADD CONSTRAINT CONST_PRD_ELET FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb016_prd_vestuarios'::regclass
                    AND lower(conname) = lower('CONST_PRD_VEST')
        ) THEN
        ALTER TABLE tb016_prd_vestuarios
            ADD CONSTRAINT CONST_PRD_VEST FOREIGN KEY (tb012_cod_produto) REFERENCES tb012_produtos(tb012_cod_produto)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        IF NOT EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = 'tb017_fornecedores'::regclass
                    AND lower(conname) = lower('CONST_END_FORN')
        ) THEN
        ALTER TABLE tb017_fornecedores
            ADD CONSTRAINT CONST_END_FORN FOREIGN KEY (tb003_cod_endereco) REFERENCES tb003_enderecos(tb003_cod_endereco)
                ON DELETE NO ACTION
                ON UPDATE NO ACTION;
    END IF;
END
$$ LANGUAGE plpgsql;
