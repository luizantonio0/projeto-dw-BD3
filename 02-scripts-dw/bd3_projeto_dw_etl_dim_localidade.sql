INSERT INTO dim_localidade (id_uf_origem, uf_nome, uf_sigla, id_cidade_origem, cidade_nome, id_endereco_origem, endereco_logradouro, endereco_numero, endereco_bairro, endereco_cep, id_loja_origem, loja_cnpj)
SELECT
    uf.tb001_sigla_uf AS id_uf_origem,
    uf.tb001_nome_estado AS uf_nome,
    uf.tb001_sigla_uf AS uf_sigla,
    c.tb002_cod_cidade AS id_cidade_origem,
    c.tb002_nome_cidade AS cidade_nome,
    e.tb003_cod_endereco AS id_endereco_origem,
    e.tb003_nome_rua AS endereco_logradouro,
    e.tb003_numero_rua AS endereco_numero,
    e.tb003_bairro AS endereco_bairro,
    e.tb003_CEP AS endereco_cep,
    l.tb004_cod_loja AS id_loja_origem,
    l.tb004_cnpj_loja AS loja_cnpj
FROM
    tb004_lojas l
LEFT JOIN
    tb003_enderecos e ON l.tb003_cod_endereco = e.tb003_cod_endereco
LEFT JOIN
    tb002_cidades c ON e.tb002_cod_cidade = c.tb002_cod_cidade AND e.tb001_sigla_uf = c.tb001_sigla_uf
LEFT JOIN
    tb001_uf uf ON c.tb001_sigla_uf = uf.tb001_sigla_uf;


