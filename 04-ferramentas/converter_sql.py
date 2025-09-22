#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Conversor Automático de SQL Server para PostgreSQL
Migração do BD_VAREJO para Supabase
"""

import re
import os
from datetime import datetime

def converter_sql_server_para_postgresql(arquivo_origem, pasta_destino):
    """
    Converte automaticamente um arquivo SQL do SQL Server para PostgreSQL
    """
    
    # Ler o arquivo original
    try:
        with open(arquivo_origem, 'r', encoding='utf-8') as f:
            conteudo = f.read()
    except UnicodeDecodeError:
        with open(arquivo_origem, 'r', encoding='latin-1') as f:
            conteudo = f.read()
    
    print(f"✅ Arquivo {arquivo_origem} lido com sucesso!")
    
    # Separar DDL (CREATE TABLE) e DML (INSERT)
    ddl_content, dml_content = separar_ddl_dml(conteudo)
    
    # Converter DDL
    ddl_postgresql = converter_ddl(ddl_content)
    
    # Converter DML
    dml_postgresql = converter_dml(dml_content)
    
    # Criar os arquivos de saída
    criar_arquivos_saida(ddl_postgresql, dml_postgresql, pasta_destino)
    
    # Criar script de execução
    criar_script_execucao(pasta_destino)
    
    print("\n🎉 Conversão concluída com sucesso!")
    print(f"📁 Arquivos criados na pasta: {pasta_destino}")

def separar_ddl_dml(conteudo):
    """Separa comandos DDL (CREATE TABLE) dos DML (INSERT)"""
    
    # Encontrar onde começam os INSERTs
    insert_inicio = conteudo.find('INSERT INTO')
    
    if insert_inicio == -1:
        # Se não encontrou INSERT, procura por outros padrões
        patterns = [
            'BEGIN TRANSACTION DELETE FROM',
            'INSERT INTO ADS.dbo',
            'VALUES('
        ]
        
        for pattern in patterns:
            pos = conteudo.find(pattern)
            if pos != -1:
                insert_inicio = pos
                break
    
    if insert_inicio == -1:
        # Se ainda não encontrou, assume que tudo é DDL
        return conteudo, ""
    
    ddl_content = conteudo[:insert_inicio]
    dml_content = conteudo[insert_inicio:]
    
    return ddl_content, dml_content

def converter_ddl(ddl_content):
    """Converte comandos DDL do SQL Server para PostgreSQL"""
    
    resultado = []
    resultado.append("-- =========================================")
    resultado.append("-- MIGRAÇÃO BD_VAREJO para PostgreSQL (Supabase)")
    resultado.append("-- Script DDL - Gerado automaticamente")
    resultado.append("-- =========================================\n")
    
    # Remover comandos específicos do SQL Server
    ddl_content = re.sub(r'--USE master.*?GO', '', ddl_content, flags=re.DOTALL)
    ddl_content = re.sub(r'USE \w+.*?GO', '', ddl_content, flags=re.DOTALL)
    ddl_content = re.sub(r'SET dateformat.*?;', '', ddl_content)
    ddl_content = re.sub(r'go\s*$', '', ddl_content, flags=re.MULTILINE | re.IGNORECASE)
    ddl_content = re.sub(r'\sGO\s*$', '', ddl_content, flags=re.MULTILINE)
    
    # Extrair e ordernar DROP TABLEs
    drops = re.findall(r'DROP TABLE\s+(\w+)', ddl_content, re.IGNORECASE)
    if drops:
        resultado.append("-- Removendo tabelas existentes")
        for table in reversed(drops):  # Reverter ordem para respeitar FK
            resultado.append(f"DROP TABLE IF EXISTS {table} CASCADE;")
        resultado.append("")
    
    # Extrair CREATE TABLEs
    create_tables = re.finditer(
        r'CREATE TABLE\s+(\w+)\s*\((.*?)\)', 
        ddl_content, 
        re.DOTALL | re.IGNORECASE
    )
    
    tables_sql = []
    
    for match in create_tables:
        table_name = match.group(1)
        table_def = match.group(2)
        
        # Converter definições de colunas
        table_def_converted = converter_definicoes_colunas(table_def)
        
        sql = f"CREATE TABLE {table_name} (\n{table_def_converted}\n);"
        tables_sql.append((table_name, sql))
    
    # Adicionar CREATE TABLEs
    for table_name, sql in tables_sql:
        resultado.append(f"-- Tabela: {table_name}")
        resultado.append(sql)
        resultado.append("")
    
    # Extrair e converter ALTER TABLEs (PKs e FKs)
    constraints = re.finditer(
        r'ALTER TABLE\s+(\w+)\s+ADD CONSTRAINT\s+(\w+)\s+(.*?)(?=ALTER TABLE|$)',
        ddl_content,
        re.DOTALL | re.IGNORECASE
    )
    
    resultado.append("-- Adicionando constraints")
    for match in constraints:
        table_name = match.group(1)
        constraint_name = match.group(2)
        constraint_def = match.group(3).strip()
        
        constraint_converted = converter_constraint(constraint_def)
        
        sql = f"ALTER TABLE {table_name}\n    ADD CONSTRAINT {constraint_name} {constraint_converted};"
        resultado.append(sql)
        resultado.append("")
    
    return "\n".join(resultado)

def converter_definicoes_colunas(table_def):
    """Converte definições de colunas do SQL Server para PostgreSQL"""
    
    linhas = []
    for linha in table_def.split(','):
        linha = linha.strip()
        if not linha:
            continue
            
        # Converter tipos de dados
        linha = re.sub(r'NUMERIC\((\d+)\)\s+IDENTITY\s*\(\s*\d+\s*,\s*\d+\s*\)', r'SERIAL', linha)
        linha = re.sub(r'NUMERIC\((\d+),(\d+)\)', r'DECIMAL(\1,\2)', linha)
        linha = re.sub(r'NUMERIC\((\d+)\)', r'INTEGER', linha)
        linha = re.sub(r'\bdatetime\b', 'TIMESTAMP', linha, flags=re.IGNORECASE)
        linha = re.sub(r'\bchar\((\d+)\)', r'CHAR(\1)', linha, flags=re.IGNORECASE)
        
        linhas.append(f"    {linha}")
    
    return ',\n'.join(linhas)

def converter_constraint(constraint_def):
    """Converte definição de constraint"""
    
    constraint_def = re.sub(r'\s+', ' ', constraint_def)
    constraint_def = re.sub(r'ON DELETE NO ACTION\s*ON UPDATE NO ACTION', '', constraint_def)
    
    return constraint_def

def converter_dml(dml_content):
    """Converte comandos DML (INSERT) do SQL Server para PostgreSQL"""
    
    if not dml_content.strip():
        return "-- Nenhum dado para inserir encontrado"
    
    resultado = []
    resultado.append("-- =========================================")
    resultado.append("-- MIGRAÇÃO BD_VAREJO para PostgreSQL (Supabase)")
    resultado.append("-- Script DML - Gerado automaticamente")
    resultado.append("-- =========================================\n")
    
    # Remover comandos específicos do SQL Server
    dml_content = re.sub(r'USE \w+.*?GO', '', dml_content, flags=re.DOTALL)
    dml_content = re.sub(r'BEGIN TRANSACTION DELETE FROM.*?COMMIT.*?GO', '', dml_content, flags=re.DOTALL)
    dml_content = re.sub(r'go\s*$', '', dml_content, flags=re.MULTILINE | re.IGNORECASE)
    dml_content = re.sub(r'\sGO\s*$', '', dml_content, flags=re.MULTILINE)
    
    # Extrair e converter INSERTs
    inserts = re.finditer(
        r'INSERT INTO\s+(?:ADS\.dbo\.)?(\w+)(?:\s+\([^)]+\))?\s+VALUES\s*\(([^)]+)\)',
        dml_content,
        re.IGNORECASE
    )
    
    tabela_atual = ""
    
    for match in inserts:
        table_name = match.group(1)
        values = match.group(2)
        
        if table_name != tabela_atual:
            if tabela_atual:
                resultado.append("")
            resultado.append(f"-- Dados para tabela: {table_name}")
            tabela_atual = table_name
        
        # Converter valores
        values_converted = converter_valores(values)
        
        # Determinar se precisa especificar colunas para SERIAL
        if precisa_colunas_explicitas(table_name):
            colunas = obter_colunas_tabela(table_name, dml_content)
            if colunas:
                sql = f"INSERT INTO {table_name} ({colunas}) VALUES({values_converted});"
            else:
                sql = f"INSERT INTO {table_name} VALUES({values_converted});"
        else:
            sql = f"INSERT INTO {table_name} VALUES({values_converted});"
        
        resultado.append(sql)
    
    return "\n".join(resultado)

def converter_valores(values):
    """Converte valores dos INSERTs"""
    
    # Converter datas no formato M/D/YYYY para YYYY-MM-DD
    values = re.sub(
        r"'(\d{1,2})/(\d{1,2})/(\d{4})'",
        lambda m: f"'{m.group(3)}-{m.group(1).zfill(2)}-{m.group(2).zfill(2)}'",
        values
    )
    
    return values

def precisa_colunas_explicitas(table_name):
    """Verifica se a tabela tem campos SERIAL que precisam de especificação de colunas"""
    
    tables_with_serial = [
        'tb002_cidades', 'tb003_enderecos', 'tb004_lojas', 'tb005_funcionarios',
        'tb006_cargos', 'tb010_012_vendas', 'tb012_017_compras', 'tb013_categorias',
        'tb014_prd_alimentos', 'tb015_prd_eletros', 'tb016_prd_vestuarios',
        'tb017_fornecedores', 'tb999_log'
    ]
    
    return table_name in tables_with_serial

def obter_colunas_tabela(table_name, dml_content):
    """Obtém as colunas de uma tabela baseado nos INSERTs"""
    
    # Mapeamento de colunas por tabela (excluindo campos SERIAL)
    colunas_map = {
        'tb002_cidades': 'tb001_sigla_uf, tb002_nome_cidade',
        'tb003_enderecos': 'tb001_sigla_uf, tb002_cod_cidade, tb003_nome_rua, tb003_numero_rua, tb003_complemento, tb003_ponto_referencia, tb003_bairro, tb003_CEP',
        'tb004_lojas': 'tb003_cod_endereco, tb004_matriz, tb004_cnpj_loja, tb004_inscricao_estadual',
        'tb005_funcionarios': 'tb004_cod_loja, tb003_cod_endereco, tb005_nome_completo, tb005_data_nascimento, tb005_CPF, tb005_RG, tb005_status, tb005_data_contratacao, tb005_data_demissao',
        'tb006_cargos': 'tb006_nome_cargo',
        'tb013_categorias': 'tb013_descricao',
        'tb017_fornecedores': 'tb017_razao_social, tb017_nome_fantasia, tb017_fone, tb003_cod_endereco',
        'tb014_prd_alimentos': 'tb012_cod_produto, tb014_detalhamento, tb014_unidade_medida, tb014_num_lote, tb014_data_vencimento, tb014_valor_sugerido',
        'tb015_prd_eletros': 'tb012_cod_produto, tb015_detalhamento, tb015_tensao, tb015_nivel_consumo_procel, tb015_valor_sugerido',
        'tb016_prd_vestuarios': 'tb012_cod_produto, tb016_detalhamento, tb016_sexo, tb016_tamanho, tb016_numeracao, tb016_valor_sugerido',
        'tb010_012_vendas': 'tb010_cpf, tb012_cod_produto, tb005_matricula, tb010_012_data, tb010_012_quantidade, tb010_012_valor_unitario',
        'tb012_017_compras': 'tb012_cod_produto, tb017_cod_fornecedor, tb012_017_data, tb012_017_quantidade, tb012_017_valor_unitario'
    }
    
    return colunas_map.get(table_name, '')

def criar_arquivos_saida(ddl_content, dml_content, pasta_destino):
    """Cria os arquivos de saída"""
    
    # Criar pasta se não existir
    os.makedirs(pasta_destino, exist_ok=True)
    
    # Arquivo DDL
    with open(os.path.join(pasta_destino, 'BD_VAREJO_PostgreSQL_DDL.sql'), 'w', encoding='utf-8') as f:
        f.write(ddl_content)
    
    # Arquivo DML
    with open(os.path.join(pasta_destino, 'BD_VAREJO_PostgreSQL_DML.sql'), 'w', encoding='utf-8') as f:
        f.write(dml_content)
    
    print("✅ Arquivos SQL criados:")
    print("  - BD_VAREJO_PostgreSQL_DDL.sql (estrutura das tabelas)")
    print("  - BD_VAREJO_PostgreSQL_DML.sql (dados)")

def criar_script_execucao(pasta_destino):
    """Cria um script com instruções de execução"""
    
    instrucoes = """
# 🚀 Como executar a migração no Supabase

## Passo 1: Acessar o Supabase
1. Entre no seu projeto Supabase (https://supabase.com)
2. Vá em "SQL Editor" no menu lateral

## Passo 2: Executar DDL (Estrutura)
1. Abra o arquivo `BD_VAREJO_PostgreSQL_DDL.sql`
2. Copie todo o conteúdo
3. Cole no SQL Editor do Supabase
4. Clique em "RUN" para executar
5. Verifique se todas as tabelas foram criadas

## Passo 3: Executar DML (Dados)
1. Abra o arquivo `BD_VAREJO_PostgreSQL_DML.sql`
2. Copie todo o conteúdo
3. Cole no SQL Editor do Supabase
4. Clique em "RUN" para executar
5. Verifique se os dados foram inseridos

## Passo 4: Verificação
Execute estas consultas para verificar:

```sql
-- Ver todas as tabelas criadas
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Contar registros por tabela
SELECT 'tb001_uf' as tabela, COUNT(*) as registros FROM tb001_uf
UNION ALL
SELECT 'tb002_cidades', COUNT(*) FROM tb002_cidades
UNION ALL
SELECT 'tb003_enderecos', COUNT(*) FROM tb003_enderecos
UNION ALL
SELECT 'tb004_lojas', COUNT(*) FROM tb004_lojas
UNION ALL
SELECT 'tb005_funcionarios', COUNT(*) FROM tb005_funcionarios
UNION ALL
SELECT 'tb006_cargos', COUNT(*) FROM tb006_cargos;
```

## ⚠️ Dicas importantes:
- Execute primeiro o DDL, depois o DML
- Se houver erro, verifique as mensagens no console
- Você pode executar os scripts em partes menores se necessário
- Use transações se quiser poder reverter: BEGIN; ... COMMIT; ou ROLLBACK;

## 🆘 Resolução de problemas comuns:
- **Erro de FK**: Execute DDL antes do DML
- **Erro de SERIAL**: Os campos auto-incremento são gerados automaticamente
- **Erro de data**: Verifique o formato YYYY-MM-DD
- **Erro de encoding**: Certifique-se que está usando UTF-8

✅ Migração concluída com sucesso!
"""
    
    with open(os.path.join(pasta_destino, 'INSTRUCOES_EXECUCAO.md'), 'w', encoding='utf-8') as f:
        f.write(instrucoes)
    
    print("✅ Arquivo de instruções criado:")
    print("  - INSTRUCOES_EXECUCAO.md (como executar no Supabase)")

def main():
    """Função principal"""
    
    print("🔄 Conversor Automático SQL Server → PostgreSQL")
    print("=" * 50)
    
    # Caminhos dos arquivos
    arquivo_origem = r"c:\Users\787203\Downloads\BD3\BD_VAREJO.sql"
    pasta_destino = r"c:\Users\787203\Downloads\BD3\postgresql_converted"
    
    # Verificar se arquivo existe
    if not os.path.exists(arquivo_origem):
        print(f"❌ Erro: Arquivo não encontrado: {arquivo_origem}")
        return
    
    # Executar conversão
    converter_sql_server_para_postgresql(arquivo_origem, pasta_destino)
    
    print("\n📋 Próximos passos:")
    print("1. Abra a pasta 'postgresql_converted'")
    print("2. Leia o arquivo 'INSTRUCOES_EXECUCAO.md'")
    print("3. Execute os scripts no Supabase SQL Editor")
    print("\n🎯 Migração automatizada concluída!")

if __name__ == "__main__":
    main()