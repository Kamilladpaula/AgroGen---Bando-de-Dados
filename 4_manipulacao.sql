-- ========================================================
-- MANIPULAÇÃO
-- ========================================================

-- ========================================================
-- SEÇÃO 1: ATUALIZAÇÕES (UPDATE)
-- ========================================================

-- 1. CORREÇÃO DE CADASTRO 
-- Cenário: O agricultor João da Silva (USR-01) mudou de telefone.
UPDATE USUARIO 
SET telefone = '11977776666' 
WHERE codigo = 'USR-01';

-- 2. AJUSTE DE ESTOQUE 
-- Cenário: O Lote 'LOT-05' teve perda por umidade, reduzindo o estoque para 45kg.
UPDATE LOTE_SEMENTE 
SET quantidade = 45 
WHERE codigo = 'LOT-05';

-- 3. TRANSFERÊNCIA DE VÍNCULO INSTITUCIONAL
-- Cenário: A pesquisadora Maria (USR-02) saiu da Embrapa (INST-01) e foi para a Universidade (INST-03).
-- Como a tabela PESQUISADOR não tem código próprio, buscamos pelo código do USUÁRIO.
UPDATE PESQUISADOR 
SET instituicao_vinculada = (SELECT id_instituicao FROM INSTITUICAO WHERE codigo = 'INST-03')
WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE codigo = 'USR-02');

-- 4. CORREÇÃO DE NOME DE VARIEDADE
-- Cenário: O nome comercial da variedade VAR-04 precisa ser ajustado.
UPDATE VARIEDADE
SET nome_variedade = 'Mandioca Amarela de Mesa (Premium)'
WHERE codigo = 'VAR-04';

-- ========================================================
-- SEÇÃO 2: EXCLUSÕES (DELETE)
-- ========================================================

-- 1. CANCELAMENTO DE UMA TROCA ESPECÍFICA
-- Cenário: A troca TRC-70 foi lançada duplicada ou cancelada.
DELETE FROM TROCA 
WHERE codigo = 'TRC-70';

-- 2. REMOÇÃO DE UM LAUDO LABORATORIAL
-- Cenário: O laudo LAB-120 contém erros de digitação e será refeito.
DELETE FROM ANALISE_LABORATORIAL 
WHERE codigo = 'LAB-120';

-- 3. LIMPEZA DE MOVIMENTAÇÕES DE UMA AMOSTRA
-- Cenário: A amostra 'AMO-60' foi perdida/destruída e precisamos apagar seu histórico.
-- (Como Movimentação não tem código externo, buscamos pelo código da Amostra)
DELETE FROM MOVIMENTACAO 
WHERE id_amostra = (SELECT id_amostra FROM AMOSTRA WHERE codigo = 'AMO-60');

-- 4. EXCLUSÃO DE UMA COLHEITA VINCULADA A UM PLANTIO
-- Cenário: O registro de colheita do plantio PLT-46 foi inserido errado.
DELETE FROM COLHEITA
WHERE id_plantio = (SELECT id_plantio FROM PLANTIO WHERE codigo = 'PLT-46');