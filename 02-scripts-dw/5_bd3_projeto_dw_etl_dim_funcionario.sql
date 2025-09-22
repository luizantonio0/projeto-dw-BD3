INSERT INTO dim_funcionario (id_funcionario_origem, funcionario_nome, funcionario_cpf, id_cargo_origem, cargo_nome)
SELECT
    f.tb005_matricula AS id_funcionario_origem,
    f.tb005_nome_completo AS funcionario_nome,
    f.tb005_CPF AS funcionario_cpf,
    c.tb006_cod_cargo AS id_cargo_origem,
    c.tb006_nome_cargo AS cargo_nome
FROM
    tb005_funcionarios f
LEFT JOIN
    tb005_006_funcionarios_cargos fc ON f.tb005_matricula = fc.tb005_matricula
LEFT JOIN
    tb006_cargos c ON fc.tb006_cod_cargo = c.tb006_cod_cargo;


