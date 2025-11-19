-- ========================================================
-- 0. LIMPEZA
-- ========================================================
DROP TABLE IF EXISTS MOVIMENTACAO CASCADE;
DROP TABLE IF EXISTS ANALISE_LABORATORIAL CASCADE;
DROP TABLE IF EXISTS AMOSTRA CASCADE;
DROP TABLE IF EXISTS TROCA CASCADE;
DROP TABLE IF EXISTS COLHEITA CASCADE;
DROP TABLE IF EXISTS PLANTIO CASCADE;
DROP TABLE IF EXISTS LOTE_SEMENTE CASCADE;
DROP TABLE IF EXISTS LOCALIZACAO_BIOBANCO CASCADE;
DROP TABLE IF EXISTS BIOBANCO CASCADE;
DROP TABLE IF EXISTS VARIEDADE CASCADE;
DROP TABLE IF EXISTS GUARDIAO CASCADE;
DROP TABLE IF EXISTS PESQUISADOR CASCADE;
DROP TABLE IF EXISTS USUARIO CASCADE;
DROP TABLE IF EXISTS ESPECIE CASCADE;
DROP TABLE IF EXISTS COMUNIDADE CASCADE;
DROP TABLE IF EXISTS INSTITUICAO CASCADE;

-- ========================================================
-- 1. TABELAS COM CÓDIGO EXTERNO (Etiquetas/Protocolos)
-- ========================================================

CREATE TABLE INSTITUICAO (
    id_instituicao SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(255),
    tipo VARCHAR(100)
);

CREATE TABLE COMUNIDADE (
    id_comunidade SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(255),
    localizacao TEXT,
    uf CHAR(2)
);

CREATE TABLE USUARIO (
    id_usuario SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL, -- O código ÚNICO da pessoa (Ex: USR-01)
    nome VARCHAR(255),
    email VARCHAR(255),
    perfil VARCHAR(50),
    telefone VARCHAR(20)
);

CREATE TABLE ESPECIE (
    id_especie SERIAL PRIMARY KEY,
    -- Sem código. Usaremos o nome científico.
    nome_cientifico VARCHAR(255) UNIQUE, 
    familia VARCHAR(255),
    nome_popular VARCHAR(255)
);

CREATE TABLE VARIEDADE (
    id_variedade SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL, -- Ex: VAR-01
    id_especie INT NOT NULL,
    nome_variedade VARCHAR(255),
    caracteristicas TEXT,
    FOREIGN KEY (id_especie) REFERENCES ESPECIE(id_especie)
);

CREATE TABLE BIOBANCO (
    id_biobanco SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL, -- Ex: BIO-01
    nome VARCHAR(255),
    instituicao_responsavel INT,
    FOREIGN KEY (instituicao_responsavel) REFERENCES INSTITUICAO(id_instituicao)
);

-- ========================================================
-- 2. TABELAS SEM CÓDIGO PRÓPRIO (Usam o de cima ou Interno)
-- ========================================================

CREATE TABLE PESQUISADOR (
    id_pesquisador SERIAL PRIMARY KEY,
    -- Sem código próprio. Usa o código do USUARIO.
    id_usuario INT NOT NULL,
    instituicao_vinculada INT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (instituicao_vinculada) REFERENCES INSTITUICAO(id_instituicao)
);

CREATE TABLE GUARDIAO (
    id_agricultor SERIAL PRIMARY KEY,
    -- Sem código próprio. Usa o código do USUARIO.
    id_usuario INT NOT NULL,
    id_comunidade INT,
    area_plantio DECIMAL(10,2),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_comunidade) REFERENCES COMUNIDADE(id_comunidade)
);

CREATE TABLE LOCALIZACAO_BIOBANCO (
    id_localizacao SERIAL PRIMARY KEY,
    -- Sem código. A chave é a posição física.
    id_biobanco INT NOT NULL,
    corredor VARCHAR(50),
    prateleira VARCHAR(50),
    caixa VARCHAR(50),
    FOREIGN KEY (id_biobanco) REFERENCES BIOBANCO(id_biobanco)
);

-- ========================================================
-- 3. TRANSAÇÕES (Algumas com código, outras sem)
-- ========================================================

CREATE TABLE LOTE_SEMENTE (
    id_lote SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL, -- Ex: LOT-01 (Etiqueta Saco)
    id_agricultor INT NOT NULL,
    id_variedade INT NOT NULL,
    quantidade INT,
    ano_colheita INT,
    origem_lote VARCHAR(100),
    FOREIGN KEY (id_agricultor) REFERENCES GUARDIAO(id_agricultor),
    FOREIGN KEY (id_variedade) REFERENCES VARIEDADE(id_variedade)
);

CREATE TABLE PLANTIO (
    id_plantio SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL, -- Ex: PLT-01 (Placa Campo)
    id_lote INT NOT NULL,
    data_plantio DATE,
    area_plantada DECIMAL(10,2),
    FOREIGN KEY (id_lote) REFERENCES LOTE_SEMENTE(id_lote)
);

CREATE TABLE COLHEITA (
    id_colheita SERIAL PRIMARY KEY,
    -- Sem código. Vinculada diretamente ao PLANTIO.
    id_plantio INT NOT NULL,
    qtd_colhida INT,
    data_colheita DATE,
    FOREIGN KEY (id_plantio) REFERENCES PLANTIO(id_plantio)
);

CREATE TABLE TROCA (
    id_troca SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL, -- Ex: TRC-01 (Recibo)
    id_lote_origem INT NOT NULL,
    id_agricultor_origem INT NOT NULL,
    id_agricultor_destino INT NOT NULL,
    quantidade INT,
    data_troca DATE,
    FOREIGN KEY (id_lote_origem) REFERENCES LOTE_SEMENTE(id_lote),
    FOREIGN KEY (id_agricultor_origem) REFERENCES GUARDIAO(id_agricultor),
    FOREIGN KEY (id_agricultor_destino) REFERENCES GUARDIAO(id_agricultor)
);

CREATE TABLE AMOSTRA (
    id_amostra SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL, -- Ex: AMO-01 (Etiqueta Tubo)
    id_pesquisador INT NOT NULL,
    id_especie INT NOT NULL,
    id_localizacao_atual INT,
    geolocalizacao VARCHAR(100),
    data_coleta DATE,
    conservacao VARCHAR(100),
    FOREIGN KEY (id_pesquisador) REFERENCES PESQUISADOR(id_pesquisador),
    FOREIGN KEY (id_especie) REFERENCES ESPECIE(id_especie),
    FOREIGN KEY (id_localizacao_atual) REFERENCES LOCALIZACAO_BIOBANCO(id_localizacao)
);

CREATE TABLE ANALISE_LABORATORIAL (
    id_analise SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL, -- Ex: LAB-01 (Laudo)
    id_amostra INT NOT NULL,
    tipo_analise VARCHAR(100),
    resultado TEXT,
    data_analise DATE,
    FOREIGN KEY (id_amostra) REFERENCES AMOSTRA(id_amostra)
);

CREATE TABLE MOVIMENTACAO (
    id_movimentacao SERIAL PRIMARY KEY,
    -- Sem código. Apenas log.
    id_amostra INT NOT NULL,
    id_localizacao INT NOT NULL,
    tipo_movimentacao VARCHAR(100),
    data_movimentacao DATE,
    FOREIGN KEY (id_amostra) REFERENCES AMOSTRA(id_amostra),
    FOREIGN KEY (id_localizacao) REFERENCES LOCALIZACAO_BIOBANCO(id_localizacao)
);