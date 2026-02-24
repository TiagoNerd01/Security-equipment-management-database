create database gerenciador_kpis;
create table funcionario(
id_funcionario INT not null, 
nome varchar(120),
cargo varchar(80),
setor varchar(80),
unidade varchar(80),
status boolean,
constraint pk_funcionario primary key (id_funcionario)
);
create table unidade(
id_unidade INT not null,
nome_unidade varchar(100),
sigla varchar(10),
cidade varchar(80),
constraint pk_unidade primary key (id_unidade)
);
create table setor(
id_setor INT not null, 
nome_setor varchar(100),
descricao varchar(150),
constraint pk_setor primary key (id_setor)
);