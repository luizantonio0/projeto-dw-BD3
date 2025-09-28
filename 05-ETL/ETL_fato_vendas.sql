INSERT INTO fato_vendas (
    id_venda_origem,
    id_tempo,
    id_funcionario,
    id_cliente,
    id_produto,
    quantidade_vendida,
    valor_total_venda
)
SELECT
    v.tb010_012_cod_venda,
    t.id_tempo,
    f.id_funcionario,
    c.id_cliente,
    p.id_produto,
    SUM(v.tb010_012_quantidade) AS quantidade_vendida,
    SUM(v.tb010_012_quantidade * v.tb010_012_valor_unitario) AS valor_total_venda
FROM tb010_012_vendas v
JOIN dim_funcionario f 
    ON v.tb005_matricula = f.id_funcionario
JOIN dim_cliente c 
    ON v.tb010_cpf = c.id_cliente_origem::bigint
JOIN dim_produto p 
    ON v.tb012_cod_produto = p.id_produto_origem
JOIN dim_tempo t 
    ON v.tb010_012_data::date = t.data_completa
WHERE NOT EXISTS (
    SELECT 1
    FROM fato_vendas f_v
    WHERE f_v.id_venda_origem = v.tb010_012_cod_venda
)
GROUP BY
    v.tb010_012_cod_venda,
    t.id_tempo,
    f.id_funcionario,
    c.id_cliente,
    p.id_produto;