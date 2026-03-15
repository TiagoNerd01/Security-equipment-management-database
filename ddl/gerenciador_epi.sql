--create database gerenciador_epis;

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
    quantidade_entregue INT NOT NULL CHECK (quantidade_entregue > 0),
    id_usuario_registro INT NOT NULL,
    id_estoque INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id),
    FOREIGN KEY (id_estoque) REFERENCES estoque(id),
    FOREIGN KEY (id_usuario_registro) REFERENCES usuario_sistema(id)
);

CREATE TABLE devolucao_epi (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_entrega INT NOT NULL,
    data_devolucao DATE NOT NULL,
    motivo VARCHAR(200),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    id_usuario_registro INT NOT NULL,
    FOREIGN KEY (id_entrega) REFERENCES entrega_epi(id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_registro) REFERENCES usuario_sistema(id)
);
INSERT INTO unidade (nome_unidade, sigla, cidade) VALUES
('Unidade Feira de Santana', 'FSA', 'Feira de Santana'),
('Unidade Salvador', 'SSA', 'Salvador'),
('Unidade Camaçari', 'CAM', 'Camaçari');

INSERT INTO setor (nome_setor, descricao) VALUES
('Almoxarifado', 'Controle de estoque de materiais'),
('Manutenção', 'Equipe responsável por manutenção'),
('Produção', 'Área operacional da empresa');

INSERT INTO tamanho (descricao) VALUES
('P'),
('M'),
('G'),
('GG');

INSERT INTO tipo_epi (nome_epi, ca, instrucoes_uso) VALUES
('Capacete de Segurança', 'CA498', 'Uso obrigatório em áreas com risco de queda de objetos.'),
('Luva de Proteção Nitrílica', 'CA16312', 'Utilizar durante manipulação de materiais e produtos químicos leves.'),
('Óculos de Proteção Incolor', 'CA9722', 'Proteção contra partículas volantes e poeira.'),
('Bota de Segurança com Biqueira', 'CA17044', 'Obrigatória em áreas com risco de impacto nos pés.'),
('Protetor Auricular Tipo Plug', 'CA5674', 'Uso obrigatório em ambientes com ruído elevado.'),
('Máscara Respiratória PFF2', 'CA38943', 'Proteção contra poeiras, fumos e névoas.'),
('Avental de PVC', 'CA28193', 'Proteção do tronco contra respingos de líquidos.'),
('Cinto de Segurança Tipo Paraquedista', 'CA35520', 'Utilizar em atividades de trabalho em altura.'),
('Mangote de Proteção', 'CA20134', 'Proteção dos braços contra abrasão e calor moderado.'),
('Protetor Facial', 'CA27901', 'Proteção contra impacto de partículas e respingos.');

INSERT INTO fornecedor (nome_fornecedor, cnpj, telefone, email) VALUES
('EPI Brasil', '12.345.678/0001-10', '75999990001', 'contato@epibrasil.com'),
('Segurança Total', '98.765.432/0001-55', '75999990002', 'vendas@segurancatotal.com'),
('Protege Equipamentos', '11.222.333/0001-99', '75999990003', 'comercial@protege.com');

INSERT INTO usuario_sistema (nome, email, senha, perfil) VALUES
('Administrador', 'admin@empresa.com', '123456', 'ADMIN'),
('Operador Almoxarifado', 'almox@empresa.com', '123456', 'OPERADOR'),
('Supervisor', 'supervisor@empresa.com', '123456', 'SUPERVISOR');

INSERT INTO funcionario (nome, cargo, id_setor, id_unidade, status) VALUES
('Carlos Silva', 'Soldador', 1, 1, TRUE),
('Ana Oliveira', 'Pintor', 2, 1, TRUE),
('Marcos Souza', 'Mecânico', 1, 1, TRUE),
('Julia Costa', 'Engenheira', 3, 1, TRUE),
('Ricardo Alves', 'Técnico de Segurança', 3, 1, TRUE),
('Fernanda Lima', 'Soldador', 1, 1, TRUE),
('Paulo Santos', 'Pintor', 2, 1, TRUE),
('Beatriz Rocha', 'Almoxarife', 3, 1, TRUE),
('Lucas Mendes', 'Mecânico', 1, 1, TRUE),
('Mariana Ferreira', 'Soldador', 1, 2, TRUE),
('Roberto Dias', 'Eletricista', 3, 2, TRUE),
('Camila Nunes', 'Pintor', 2, 2, TRUE),
('Bruno Castro', 'Soldador', 1, 2, TRUE),
('Amanda Silva', 'Engenheira', 3, 2, TRUE),
('Diego Ramos', 'Mecânico', 1, 2, TRUE),
('Larissa Moraes', 'Técnica de Segurança', 3, 2, TRUE),
('Gabriel Ortiz', 'Eletricista', 3, 1, TRUE),
('Vanessa Guedes', 'Almoxarife', 3, 2, TRUE),
('Thiago Luz', 'Soldador', 1, 1, FALSE),
('Sonia Abrantes', 'Pintor', 2, 1, TRUE),
('Felipe Neto', 'Mecânico', 1, 1, TRUE),
('Renata Igaci', 'Soldador', 1, 2, TRUE),
('Hugo Boss', 'Eletricista', 3, 2, FALSE),
('Patrícia Poeta', 'Engenheira', 3, 1, TRUE),
('Otávio Mesquita', 'Soldador', 1, 2, FALSE),
('Zeca Pagodinho', 'Pintor', 2, 2, TRUE),
('Arlindo Cruz', 'Mecânico', 1, 1, FALSE),
('Ivete Sangalo', 'Técnica de Segurança', 3, 1, TRUE),
('Gilberto Gil', 'Eletricista', 3, 1, FALSE),
('Caetano Veloso', 'Soldador', 1, 1, TRUE);

INSERT INTO estoque (id_tipo_epi, id_tamanho, quantidade_disponivel, quantidade_minima) VALUES
(1,1,120,20),
(1,2,115,20),
(1,3,110,20),

(2,1,95,15),
(2,2,90,15),
(2,3,85,15),

(3,1,80,15),
(3,2,75,15),
(3,3,70,15),

(4,1,60,10),
(4,2,55,10),
(4,3,50,10),

(5,1,140,30),
(5,2,135,30),
(5,3,130,30),

(6,1,100,20),
(6,2,95,20),
(6,3,90,20),

(7,1,70,15),
(7,2,65,15),
(7,3,60,15),

(8,1,40,10),
(8,2,35,10),
(8,3,30,10),

(9,1,85,15),
(9,2,80,15),
(9,3,75,15),

(10,1,110,20),
(10,2,105,20),
(10,3,100,20);

INSERT INTO fornecedor (nome_fornecedor, cnpj, telefone, email) VALUES
('Protec Equipamentos', '11.234.567/0001-01', '1130000001', 'contato@protec.com'),
('Segura EPI', '11.234.567/0001-02', '1130000002', 'contato@seguraepi.com'),
('Brasil Safety', '11.234.567/0001-03', '1130000003', 'contato@brasilsafety.com'),
('Fort EPI', '11.234.567/0001-04', '1130000004', 'contato@fortepi.com'),
('Top Segurança', '11.234.567/0001-05', '1130000005', 'contato@topseguranca.com'),
('Alpha Equipamentos', '11.234.567/0001-06', '1130000006', 'contato@alphaequip.com'),
('Delta Safety', '11.234.567/0001-07', '1130000007', 'contato@deltasafety.com'),
('Prime EPI', '11.234.567/0001-08', '1130000008', 'contato@primeepi.com'),
('Master Segurança', '11.234.567/0001-09', '1130000009', 'contato@masterseg.com'),
('Nacional EPIs', '11.234.567/0001-10', '1130000010', 'contato@nacionalepi.com'),

('Global Safety', '11.234.567/0001-11', '1130000011', 'contato@globalsafety.com'),
('Pro Work EPI', '11.234.567/0001-12', '1130000012', 'contato@prowork.com'),
('Segurmax', '11.234.567/0001-13', '1130000013', 'contato@segurmax.com'),
('Protege Brasil', '11.234.567/0001-14', '1130000014', 'contato@protegebr.com'),
('Total Segurança', '11.234.567/0001-15', '1130000015', 'contato@totalseg.com'),
('Ultra Safety', '11.234.567/0001-16', '1130000016', 'contato@ultrasafety.com'),
('Worker Equipamentos', '11.234.567/0001-17', '1130000017', 'contato@worker.com'),
('Ideal EPI', '11.234.567/0001-18', '1130000018', 'contato@idealepi.com'),
('Safe Work', '11.234.567/0001-19', '1130000019', 'contato@safework.com'),
('Pro Safety Brasil', '11.234.567/0001-20', '1130000020', 'contato@prosafety.com'),

('Segurança Total', '11.234.567/0001-21', '1130000021', 'contato@segurancatotal.com'),
('Fortaleza EPIs', '11.234.567/0001-22', '1130000022', 'contato@fortalezaepi.com'),
('Trabalhe Seguro', '11.234.567/0001-23', '1130000023', 'contato@trabalheseguro.com'),
('Central de EPIs', '11.234.567/0001-24', '1130000024', 'contato@centralepi.com'),
('Safety Brasil', '11.234.567/0001-25', '1130000025', 'contato@safetybr.com'),
('Work Safe Equipamentos', '11.234.567/0001-26', '1130000026', 'contato@worksafe.com'),
('EquipSeg', '11.234.567/0001-27', '1130000027', 'contato@equipseg.com'),
('Proteção Industrial', '11.234.567/0001-28', '1130000028', 'contato@protecaoind.com'),
('Industrial Safety', '11.234.567/0001-29', '1130000029', 'contato@industrialsafety.com'),
('Segurança Profissional', '11.234.567/0001-30', '1130000030', 'contato@segprof.com');

INSERT INTO compra_epi (data_emissao_nf, numero_nota_fiscal, valor_total_compra, metodo_pagamento, id_fornecedor) VALUES
('2024-01-10','NF1001',3200.50,'Boleto',1),
('2024-01-15','NF1002',2850.00,'PIX',2),
('2024-01-20','NF1003',4100.75,'Transferência',3),
('2024-01-25','NF1004',1500.40,'Boleto',4),
('2024-02-01','NF1005',2750.90,'PIX',5),
('2024-02-05','NF1006',3680.00,'Cartão',6),
('2024-02-10','NF1007',4200.00,'Boleto',7),
('2024-02-15','NF1008',1990.60,'Transferência',8),
('2024-02-20','NF1009',3150.30,'PIX',9),
('2024-02-25','NF1010',2899.99,'Boleto',10),

('2024-03-02','NF1011',3550.50,'PIX',11),
('2024-03-05','NF1012',2400.00,'Cartão',12),
('2024-03-10','NF1013',3999.90,'Transferência',13),
('2024-03-15','NF1014',1800.00,'Boleto',14),
('2024-03-20','NF1015',2650.70,'PIX',15),
('2024-03-25','NF1016',3100.40,'Cartão',16),
('2024-04-01','NF1017',4200.00,'Transferência',17),
('2024-04-05','NF1018',2300.50,'PIX',18),
('2024-04-10','NF1019',2950.80,'Boleto',19),
('2024-04-15','NF1020',3600.20,'Cartão',20),

('2024-04-20','NF1021',2100.00,'PIX',21),
('2024-04-25','NF1022',3400.75,'Boleto',22),
('2024-05-01','NF1023',2750.30,'Transferência',23),
('2024-05-05','NF1024',1999.99,'Cartão',24),
('2024-05-10','NF1025',4100.60,'PIX',25),
('2024-05-15','NF1026',3800.00,'Boleto',26),
('2024-05-20','NF1027',2600.90,'Transferência',27),
('2024-05-25','NF1028',3150.50,'Cartão',28),
('2024-06-01','NF1029',2900.40,'PIX',29),
('2024-06-05','NF1030',3300.00,'Boleto',30);

INSERT INTO item_compra (id_compra,id_tipo_epi,id_tamanho,quantidade,valor_unitario) VALUES
(1,1,1,50,45.00),
(1,2,2,80,12.50),

(2,3,1,40,30.00),
(2,4,2,35,95.00),

(3,5,1,120,5.50),
(3,6,2,70,6.80),

(4,7,1,45,28.00),
(4,8,2,20,150.00),

(5,9,1,60,18.00),
(5,10,2,50,22.00),

(6,1,2,55,45.00),
(6,2,3,90,12.00),

(7,3,2,50,29.00),
(7,4,1,30,100.00),

(8,5,2,110,5.20),
(8,6,3,60,7.10),

(9,7,2,35,27.00),
(9,8,1,15,155.00),

(10,9,2,70,19.00),
(10,10,3,65,23.00),

(11,1,3,60,44.00),
(11,2,1,75,11.80),

(12,3,3,42,31.00),
(12,4,2,38,92.00),

(13,5,3,130,5.30),
(13,6,1,80,6.50),

(14,7,3,48,26.50),
(14,8,2,22,148.00),

(15,9,3,68,17.50),
(15,10,1,52,21.50),

(16,1,1,57,46.00),
(16,2,2,85,12.20),

(17,3,1,47,30.50),
(17,4,3,33,97.00),

(18,5,1,105,5.60),
(18,6,2,73,7.00),

(19,7,1,40,29.00),
(19,8,3,18,152.00),

(20,9,1,64,18.70),
(20,10,2,55,22.50),

(21,1,2,52,45.50),
(21,2,3,88,12.40),

(22,3,2,46,30.80),
(22,4,1,32,94.00),

(23,5,2,115,5.40),
(23,6,3,66,6.90),

(24,7,2,37,28.50),
(24,8,1,16,149.00),

(25,9,2,72,19.20),
(25,10,3,60,23.20),

(26,1,3,58,44.50),
(26,2,1,82,11.90),

(27,3,3,49,31.20),
(27,4,2,36,96.00),

(28,5,3,125,5.35),
(28,6,1,77,6.70),

(29,7,3,43,27.80),
(29,8,2,19,151.00),

(30,9,3,69,18.90),
(30,10,1,54,21.80);

INSERT INTO entrega_epi (data_entrega,id_funcionario,quantidade_entregue,id_usuario_registro,id_estoque) VALUES
('2024-02-01',1,2,1,1),
('2024-02-02',2,1,2,2),
('2024-02-03',3,3,1,3),
('2024-02-04',4,2,3,4),
('2024-02-05',5,1,1,5),

('2024-02-06',6,2,2,6),
('2024-02-07',7,1,1,7),
('2024-02-08',8,3,2,8),
('2024-02-09',9,2,3,9),
('2024-02-10',10,1,1,10),

('2024-02-11',11,2,2,11),
('2024-02-12',12,1,3,12),
('2024-02-13',13,2,1,13),
('2024-02-14',14,3,2,14),
('2024-02-15',15,1,1,15),

('2024-02-16',16,2,3,16),
('2024-02-17',17,1,2,17),
('2024-02-18',18,2,1,18),
('2024-02-19',19,1,3,19),
('2024-02-20',20,3,2,20),

('2024-02-21',21,2,1,21),
('2024-02-22',22,1,2,22),
('2024-02-23',23,2,3,23),
('2024-02-24',24,1,1,24),
('2024-02-25',25,3,2,25),

('2024-02-26',26,2,3,26),
('2024-02-27',27,1,1,27),
('2024-02-28',28,2,2,28),
('2024-02-29',29,1,3,29),
('2024-03-01',30,2,1,30);

INSERT INTO devolucao_epi (id_entrega,data_devolucao,motivo,quantidade,id_usuario_registro) VALUES
(1,'2024-03-10','EPI danificado',1,1),
(2,'2024-03-11','Troca de tamanho',1,2),
(3,'2024-03-12','Equipamento com defeito',1,3),
(4,'2024-03-13','Substituição preventiva',1,1),
(5,'2024-03-14','Desligamento do funcionário',1,2),

(6,'2024-03-15','Troca por modelo novo',1,3),
(7,'2024-03-16','EPI danificado',1,1),
(8,'2024-03-17','Erro na entrega',1,2),
(9,'2024-03-18','Troca de tamanho',1,3),
(10,'2024-03-19','Equipamento com defeito',1,1),

(11,'2024-03-20','Substituição preventiva',1,2),
(12,'2024-03-21','Desligamento do funcionário',1,3),
(13,'2024-03-22','Troca por modelo novo',1,1),
(14,'2024-03-23','EPI danificado',1,2),
(15,'2024-03-24','Erro na entrega',1,3),

(16,'2024-03-25','Troca de tamanho',1,1),
(17,'2024-03-26','Equipamento com defeito',1,2),
(18,'2024-03-27','Substituição preventiva',1,3),
(19,'2024-03-28','Desligamento do funcionário',1,1),
(20,'2024-03-29','Troca por modelo novo',1,2),

(21,'2024-03-30','EPI danificado',1,3),
(22,'2024-03-31','Erro na entrega',1,1),
(23,'2024-04-01','Troca de tamanho',1,2),
(24,'2024-04-02','Equipamento com defeito',1,3),
(25,'2024-04-03','Substituição preventiva',1,1),

(26,'2024-04-04','Desligamento do funcionário',1,2),
(27,'2024-04-05','Troca por modelo novo',1,3),
(28,'2024-04-06','EPI danificado',1,1),
(29,'2024-04-07','Erro na entrega',1,2),
(30,'2024-04-08','Troca de tamanho',1,3);
