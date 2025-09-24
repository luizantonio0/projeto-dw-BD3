INSERT INTO dim_cliente (
    id_cliente_origem,
    cliente_nome,
    cliente_fone_residencial,
    cliente_fone_celular,
    cliente_data_cadastro,
    id_login_origem,
    login_usuario,
    login_ultimo_acesso
)
SELECT 
    CAST(c.tb010_cpf AS varchar(15)) AS id_cliente_origem,
    c.tb010_nome                     AS cliente_nome,
    c.tb010_fone_residencial         AS cliente_fone_residencial,
    c.tb010_fone_celular             AS cliente_fone_celular,
    NOW()                            AS cliente_data_cadastro,
    NULL                             AS id_login_origem,
    NULL                             AS login_usuario,
    NULL                             AS login_ultimo_acesso
FROM tb010_clientes c;