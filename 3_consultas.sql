-- ========================================================
-- CONSULTAS
-- ========================================================

-- 1. RELATÓRIO DE GUARDIÕES E COMUNIDADES
-- Lista quem são os agricultores, onde vivem e o tamanho de sua área de plantio.
SELECT 
    u.codigo AS Cod_Usuario,
    u.nome AS Nome_Guardiao,
    c.nome AS Comunidade,
    c.uf,
    g.area_plantio AS Hectares
FROM GUARDIAO g
JOIN USUARIO u ON g.id_usuario = u.id_usuario
JOIN COMUNIDADE c ON g.id_comunidade = c.id_comunidade
ORDER BY u.nome ASC;

-- 2. ESTOQUE TOTAL POR ESPÉCIE
-- Mostra quais espécies têm mais sementes armazenadas (soma dos pesos).
SELECT 
    e.nome_popular,
    e.nome_cientifico,
    COUNT(ls.id_lote) AS Qtd_Lotes,
    SUM(ls.quantidade) AS Estoque_Total_Kg
FROM LOTE_SEMENTE ls
JOIN VARIEDADE v ON ls.id_variedade = v.id_variedade
JOIN ESPECIE e ON v.id_especie = e.id_especie
GROUP BY e.nome_popular, e.nome_cientifico
ORDER BY Estoque_Total_Kg DESC;

-- 3. RASTREABILIDADE DE TROCAS
-- Identifica quem passou a semente para quem e qual foi a variedade trocada.
SELECT 
    t.codigo AS Recibo,
    t.data_troca,
    u_origem.nome AS Origem,
    u_destino.nome AS Destino,
    v.nome_variedade,
    t.quantidade AS Qtd_Trocada
FROM TROCA t
JOIN GUARDIAO g1 ON t.id_agricultor_origem = g1.id_agricultor
JOIN USUARIO u_origem ON g1.id_usuario = u_origem.id_usuario
JOIN GUARDIAO g2 ON t.id_agricultor_destino = g2.id_agricultor
JOIN USUARIO u_destino ON g2.id_usuario = u_destino.id_usuario
JOIN LOTE_SEMENTE ls ON t.id_lote_origem = ls.id_lote
JOIN VARIEDADE v ON ls.id_variedade = v.id_variedade
ORDER BY t.data_troca DESC;

-- 4. ANÁLISES DE ALERTA (SANITÁRIA)
-- Filtra resultados que indicam problemas (Fungos ou Transgênicos).
SELECT 
    al.codigo AS Laudo,
    a.codigo AS Amostra,
    u.nome AS Pesquisador_Responsavel,
    al.tipo_analise,
    al.resultado,
    al.data_analise
FROM ANALISE_LABORATORIAL al
JOIN AMOSTRA a ON al.id_amostra = a.id_amostra
JOIN PESQUISADOR p ON a.id_pesquisador = p.id_pesquisador
JOIN USUARIO u ON p.id_usuario = u.id_usuario
WHERE al.resultado LIKE '%Fungo%' 
   OR al.resultado LIKE '%Transgênico%'
ORDER BY al.data_analise DESC;

-- 5. MAPA FÍSICO DO BIOBANCO (SUL)
-- Lista exatamente onde cada amostra está guardada no Biobanco 'BIO-01'.
SELECT 
    b.nome AS Nome_Biobanco,
    lb.corredor,
    lb.prateleira,
    lb.caixa,
    a.codigo AS Amostra,
    e.nome_popular
FROM AMOSTRA a
JOIN LOCALIZACAO_BIOBANCO lb ON a.id_localizacao_atual = lb.id_localizacao
JOIN BIOBANCO b ON lb.id_biobanco = b.id_biobanco
JOIN ESPECIE e ON a.id_especie = e.id_especie
WHERE b.codigo = 'BIO-01'
ORDER BY lb.corredor, lb.prateleira;

-- 6. DISTRIBUIÇÃO GEOGRÁFICA (POR ESTADO)
-- Conta quantas comunidades cadastradas existem em cada UF.
SELECT 
    uf AS Estado,
    COUNT(id_comunidade) AS Total_Comunidades
FROM COMUNIDADE
GROUP BY uf
ORDER BY Total_Comunidades DESC;

-- 7. RANKING DE PRODUTIVIDADE CIENTÍFICA
-- Conta quantas amostras cada pesquisador coletou.
SELECT 
    u.nome AS Pesquisador,
    inst.nome AS Instituicao,
    COUNT(a.id_amostra) AS Total_Amostras_Coletadas
FROM AMOSTRA a
JOIN PESQUISADOR p ON a.id_pesquisador = p.id_pesquisador
JOIN USUARIO u ON p.id_usuario = u.id_usuario
JOIN INSTITUICAO inst ON p.instituicao_vinculada = inst.id_instituicao
GROUP BY u.nome, inst.nome
ORDER BY Total_Amostras_Coletadas DESC;

-- 8. ESTATÍSTICA DE ORIGEM DAS SEMENTES
-- Analisa de onde vêm os lotes (Próprio, Troca, Doação ou Compra).
SELECT 
    origem_lote AS Tipo_Origem,
    COUNT(id_lote) AS Quantidade_Lotes,
    AVG(quantidade) AS Media_Kg_Por_Lote
FROM LOTE_SEMENTE
GROUP BY origem_lote
ORDER BY Quantidade_Lotes DESC;

-- 9. CALENDÁRIO DE PLANTIOS (1º SEMESTRE 2024)
-- Lista os plantios realizados entre Janeiro e Junho de 2024.
SELECT 
    p.codigo AS Plantio,
    p.data_plantio,
    v.nome_variedade,
    p.area_plantada
FROM PLANTIO p
JOIN LOTE_SEMENTE ls ON p.id_lote = ls.id_lote
JOIN VARIEDADE v ON ls.id_variedade = v.id_variedade
WHERE p.data_plantio BETWEEN '2024-01-01' AND '2024-06-30'
ORDER BY p.data_plantio;

-- 10. HISTÓRICO DE MOVIMENTAÇÕES (AUDITORIA)
-- Mostra todas as entradas e saídas de amostras, ordenadas pela data.
SELECT 
    m.data_movimentacao,
    m.tipo_movimentacao,
    a.codigo AS Amostra,
    lb.caixa AS Local_Armazenado,
    u.nome AS Responsavel_Coleta
FROM MOVIMENTACAO m
JOIN AMOSTRA a ON m.id_amostra = a.id_amostra
JOIN LOCALIZACAO_BIOBANCO lb ON m.id_localizacao = lb.id_localizacao
JOIN PESQUISADOR p ON a.id_pesquisador = p.id_pesquisador
JOIN USUARIO u ON p.id_usuario = u.id_usuario
ORDER BY m.data_movimentacao DESC;