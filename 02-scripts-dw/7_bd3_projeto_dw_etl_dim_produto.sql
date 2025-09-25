INSERT INTO dim_produto (
    id_produto_origem,
    produto_descricao,
    id_categoria_origem,
    categoria_nome,
    tipo_produto
)
SELECT 
    p.tb012_cod_produto      AS id_produto_origem,
    p.tb012_descricao        AS produto_descricao,
    p.tb013_cod_categoria    AS id_categoria_origem,
    c.tb013_descricao   AS categoria_nome,
    -- Defina a regra para tipo_produto 
    CASE 
        WHEN c.tb013_descricao ILIKE '%eletrônico%' THEN 'Eletrônico'
        WHEN c.tb013_descricao ILIKE '%alimento%'   THEN 'Alimento'
        ELSE 'Outros'
    END                     AS tipo_produto
FROM tb012_produtos p
JOIN tb013_categorias c 
  ON p.tb013_cod_categoria = c.tb013_cod_categoria;