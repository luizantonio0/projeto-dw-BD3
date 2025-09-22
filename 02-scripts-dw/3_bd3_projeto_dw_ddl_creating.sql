-- Dimensão Tempo
CREATE TABLE dim_tempo (
    id_tempo INT PRIMARY KEY, -- Formato YYYYMMDD
    data_completa DATE NOT NULL,
    dia_do_mes SMALLINT NOT NULL,
    dia_da_semana SMALLINT NOT NULL,
    nome_dia_da_semana VARCHAR(15) NOT NULL,
    dia_do_ano SMALLINT NOT NULL,
    semana_do_ano SMALLINT NOT NULL,
    mes SMALLINT NOT NULL,
    nome_mes VARCHAR(15) NOT NULL,
    trimestre SMALLINT NOT NULL,
    ano SMALLINT NOT NULL,
    feriado BOOLEAN NOT NULL DEFAULT FALSE,
    fim_de_semana BOOLEAN NOT NULL DEFAULT FALSE
);

-- Dimensão Localidade
CREATE TABLE dim_localidade (
    id_localidade SERIAL PRIMARY KEY,
    id_uf_origem VARCHAR(2),
    uf_nome VARCHAR(50),
    uf_sigla VARCHAR(2),
    id_cidade_origem INT,
    cidade_nome VARCHAR(100),
    id_endereco_origem INT,
    endereco_logradouro VARCHAR(255),
    endereco_numero VARCHAR(20),
    endereco_bairro VARCHAR(100),
    endereco_cep VARCHAR(15),
    id_loja_origem INT,
    loja_cnpj VARCHAR(20) -- Usando CNPJ como identificador da loja
);

-- Dimensão Funcionário
CREATE TABLE dim_funcionario (
    id_funcionario SERIAL PRIMARY KEY,
    id_funcionario_origem INT NOT NULL,
    funcionario_nome VARCHAR(255) NOT NULL,
    funcionario_cpf VARCHAR(17),
    funcionario_email VARCHAR(255),
    funcionario_telefone VARCHAR(20),
    id_cargo_origem INT,
    cargo_nome VARCHAR(100),
    cargo_descricao TEXT
    -- id_supervisor e supervisor_nome removidos devido à ausência no BD de origem
);

-- Dimensão Cliente
CREATE TABLE dim_cliente (
    id_cliente SERIAL PRIMARY KEY,
    id_cliente_origem VARCHAR(15) NOT NULL, -- CPF do cliente
    cliente_nome VARCHAR(255) NOT NULL,
    cliente_fone_residencial VARCHAR(255),
    cliente_fone_celular VARCHAR(255),
    cliente_data_cadastro TIMESTAMP, -- Data de cadastro do login
    id_login_origem VARCHAR(255), -- Login do cliente
    login_usuario VARCHAR(255),
    login_ultimo_acesso TIMESTAMP
);

-- Dimensão Produto
CREATE TABLE dim_produto (
    id_produto SERIAL PRIMARY KEY,
    id_produto_origem INT NOT NULL,
    produto_descricao VARCHAR(255) NOT NULL,
    id_categoria_origem INT,
    categoria_nome VARCHAR(100),
    tipo_produto VARCHAR(50) -- e.g., 'Alimento', 'Eletrônico', 'Vestuário'
);

-- Fato Vendas
CREATE TABLE fato_vendas (
    id_venda SERIAL PRIMARY KEY,
    id_venda_origem INT NOT NULL,
    id_tempo INT NOT NULL,
    id_localidade INT NOT NULL,
    id_funcionario INT NOT NULL,
    id_cliente INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade_vendida INT NOT NULL,
    valor_unitario_venda NUMERIC(12,4) NOT NULL,
    valor_total_venda NUMERIC(12,4) NOT NULL, -- Calculado como quantidade * valor_unitario
    data_venda TIMESTAMP NOT NULL,
    FOREIGN KEY (id_tempo) REFERENCES dim_tempo(id_tempo),
    FOREIGN KEY (id_localidade) REFERENCES dim_localidade(id_localidade),
    FOREIGN KEY (id_funcionario) REFERENCES dim_funcionario(id_funcionario),
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES dim_produto(id_produto)
);

-- Fato Atendimentos
CREATE TABLE fato_atendimentos (
    id_atendimento SERIAL PRIMARY KEY,
    id_atendimento_origem INT, -- Pode ser o id_venda_origem se for derivado de vendas
    id_tempo INT NOT NULL,
    id_localidade INT NOT NULL,
    id_funcionario INT NOT NULL,
    quantidade_atendimentos INT NOT NULL DEFAULT 1,
    data_atendimento TIMESTAMP NOT NULL,
    FOREIGN KEY (id_tempo) REFERENCES dim_tempo(id_tempo),
    FOREIGN KEY (id_localidade) REFERENCES dim_localidade(id_localidade),
    FOREIGN KEY (id_funcionario) REFERENCES dim_funcionario(id_funcionario)
);

-- Índices para as tabelas de fatos para otimização de consultas
CREATE INDEX idx_fato_vendas_tempo ON fato_vendas (id_tempo);
CREATE INDEX idx_fato_vendas_localidade ON fato_vendas (id_localidade);
CREATE INDEX idx_fato_vendas_funcionario ON fato_vendas (id_funcionario);
CREATE INDEX idx_fato_vendas_cliente ON fato_vendas (id_cliente);
CREATE INDEX idx_fato_vendas_produto ON fato_vendas (id_produto);

CREATE INDEX idx_fato_atendimentos_tempo ON fato_atendimentos (id_tempo);
CREATE INDEX idx_fato_atendimentos_localidade ON fato_atendimentos (id_localidade);
CREATE INDEX idx_fato_atendimentos_funcionario ON fato_atendimentos (id_funcionario);


