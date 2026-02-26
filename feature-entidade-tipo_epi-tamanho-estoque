create database gerenciador_epis;

create table funcionario(
id INT PRIMARY KEY, 
nome varchar(120),
cargo varchar(80),
setor varchar(80),
unidade varchar(80),
status boolean,
);

create table unidade(
id INT PRIMARY KEY,
nome_unidade varchar(100),
sigla varchar(10),
cidade varchar(80),
);

create table setor(
id INT PRIMARY KEY,
nome_setor varchar(100),
descricao varchar(150),
);

create table tipo_epi (
    id INT PRIMARY KEY,
    nome_epi VARCHAR(100),
    ca VARCHAR(20),
    instrucoes_uso TEXT
);

create table tamanho (
    id INT PRIMARY KEY,
    descricao VARCHAR(50)
);

create table estoque (
    id INT PRIMARY KEY,
    quantidade_disponivel INT,
    quantidade_minima INT
);

CREATE TABLE usuario_sistema (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    perfil VARCHAR(50) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE item_compra (
    id INT PRIMARY KEY,
    nome_item VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
);

CREATE TABLE entrega_epi (
    id INT PRIMARY KEY,
    data_entrega_epi DATE NOT NULL,
    quantidade_entregue INT NOT NULL,
    setor_destino VARCHAR(100) NOT NULL,
    nome_entregador VARCHAR(100) NOT NULL,
    prazo_validade INT
);

CREATE TABLE devolucao_epi (
    id INT PRIMARY KEY,
    data_devolucao DATE NOT NULL,
    motivo VARCHAR(200),
    quantidade INT NOT NULL
);

CREATE TABLE fornecedor (
    id INT PRIMARY KEY,
    nome_fornecedor VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE compra_epi (
    id INT PRIMARY KEY,
    data_emissao_nf DATE NOT NULL,
    numero_nota_fiscal VARCHAR(50) NOT NULL,
    valor_total_compra DECIMAL(10,2) NOT NULL,
    metodo_pagamento VARCHAR(50)
);
