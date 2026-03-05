create database gerenciador_epis;

DROP TABLE IF EXISTS devolucao_epi;
DROP TABLE IF EXISTS entrega_epi;
DROP TABLE IF EXISTS item_compra;
DROP TABLE IF EXISTS compra_epi;
DROP TABLE IF EXISTS estoque;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS usuario_sistema;
DROP TABLE IF EXISTS fornecedor;
DROP TABLE IF EXISTS tipo_epi;
DROP TABLE IF EXISTS tamanho;
DROP TABLE IF EXISTS setor;
DROP TABLE IF EXISTS unidade;

CREATE TABLE unidade (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_unidade VARCHAR(100) NOT NULL,
    sigla VARCHAR(10) NOT NULL UNIQUE,
    cidade VARCHAR(80) NOT NULL
);

CREATE TABLE setor (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_setor VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(150)
);

CREATE TABLE tamanho (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE tipo_epi (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_epi VARCHAR(100) NOT NULL,
    ca VARCHAR(20) NOT NULL UNIQUE,
    instrucoes_uso TEXT
);

CREATE TABLE fornecedor (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_fornecedor VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE usuario_sistema (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    perfil VARCHAR(50) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE funcionario (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    id_setor INT NOT NULL,
    id_unidade INT NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_setor) REFERENCES setor(id),
    FOREIGN KEY (id_unidade) REFERENCES unidade(id)
);

CREATE TABLE estoque (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tipo_epi INT NOT NULL,
    id_tamanho INT NOT NULL,
    quantidade_disponivel INT NOT NULL CHECK (quantidade_disponivel >= 0),
    quantidade_minima INT NOT NULL CHECK (quantidade_minima >= 0),
    FOREIGN KEY (id_tipo_epi) REFERENCES tipo_epi(id),
    FOREIGN KEY (id_tamanho) REFERENCES tamanho(id),
    UNIQUE (id_tipo_epi, id_tamanho)
);

CREATE TABLE compra_epi (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_emissao_nf DATE NOT NULL,
    numero_nota_fiscal VARCHAR(50) NOT NULL UNIQUE,
    valor_total_compra DECIMAL(10,2) NOT NULL CHECK (valor_total_compra >= 0),
    metodo_pagamento VARCHAR(50),
    id_fornecedor INT NOT NULL,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id)
);

CREATE TABLE item_compra (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_compra INT NOT NULL,
    id_tipo_epi INT NOT NULL,
    id_tamanho INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    valor_unitario DECIMAL(10,2) NOT NULL CHECK (valor_unitario >= 0),
    FOREIGN KEY (id_compra) REFERENCES compra_epi(id) ON DELETE CASCADE,
    FOREIGN KEY (id_tipo_epi) REFERENCES tipo_epi(id),
    FOREIGN KEY (id_tamanho) REFERENCES tamanho(id)
);

CREATE TABLE entrega_epi (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_entrega DATE NOT NULL,
    id_funcionario INT NOT NULL,
    id_tipo_epi INT NOT NULL,
    id_tamanho INT NOT NULL,
    quantidade_entregue INT NOT NULL CHECK (quantidade_entregue > 0),
    id_usuario_registro INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id),
    FOREIGN KEY (id_tipo_epi) REFERENCES tipo_epi(id),
    FOREIGN KEY (id_tamanho) REFERENCES tamanho(id),
    FOREIGN KEY (id_usuario_registro) REFERENCES usuario_sistema(id)
);

CREATE TABLE devolucao_epi (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_entrega INT NOT NULL,
    data_devolucao DATE NOT NULL,
    motivo VARCHAR(200),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    FOREIGN KEY (id_entrega) REFERENCES entrega_epi(id) ON DELETE CASCADE
);