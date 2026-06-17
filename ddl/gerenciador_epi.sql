--create database gerenciador_epis;

DROP TABLE IF EXISTS alerta_estoque;
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
DROP TABLE IF EXISTS log_devolucao_epi;
DROP TABLE IF EXISTS alerta_tamanho_incompativel;

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

CREATE TABLE log_devolucao_epi (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_devolucao INT NOT NULL,
    data_devolucao DATE NOT NULL,
    estado_equipamento VARCHAR(200),
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE funcionario (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    id_setor INT NOT NULL,
    id_unidade INT NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    id_tamanho_padrao INT NOT NULL,
    FOREIGN KEY (id_setor) REFERENCES setor(id),
    FOREIGN KEY (id_tamanho_padrao) REFERENCES tamanho(id),
    FOREIGN KEY (id_unidade) REFERENCES unidade(id)
);

CREATE TABLE estoque (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tipo_epi INT NOT NULL,
    id_tamanho INT NOT NULL,
    id_unidade int NOT null,
    quantidade_disponivel INT NOT NULL CHECK (quantidade_disponivel >= 0),
    quantidade_minima INT NOT NULL CHECK (quantidade_minima >= 0),
    FOREIGN KEY (id_tipo_epi) REFERENCES tipo_epi(id),
    FOREIGN KEY (id_tamanho) REFERENCES tamanho(id),
    FOREIGN KEY (id_unidade) REFERENCES unidade(id),
    UNIQUE (id_tipo_epi, id_tamanho, id_unidade)
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

 CREATE TABLE alerta_estoque (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_estoque INT NOT NULL,
    mensagem VARCHAR(255) NOT NULL,
    data_alerta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estoque) REFERENCES estoque(id)
);
--Tabela feita apenas para manter controle dos epis entregues fora do tamanho
CREATE TABLE alerta_tamanho_incompativel (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_entrega INT NOT NULL,
    id_funcionario INT NOT NULL,
    tamanho_entregue VARCHAR(50),
    tamanho_perfil VARCHAR(50),
    data_alerta TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cria o trigger associado à alerta_estoque
 CREATE TRIGGER AlertaEstoqueBaixo
AFTER INSERT OR UPDATE OF quantidade_disponivel, quantidade_minima ON estoque
FOR EACH ROW
EXECUTE FUNCTION fn_alerta_estoque_baixo();

-- Cria o trigger associado à tabela devolucao_epi
CREATE TRIGGER LogDevolucaoEPI
AFTER INSERT ON devolucao_epi
FOR EACH ROW
EXECUTE FUNCTION fn_log_devolucao();

--Cria o trigger associado à tabela alerta_tamanho_incompativel
CREATE TRIGGER ValidarTamanhoEPI
AFTER INSERT ON entrega_epi
FOR EACH ROW
EXECUTE FUNCTION fn_validar_tamanho_epi();

-- 1. Unidades (30 registros)
INSERT INTO unidade (nome_unidade, sigla, cidade) VALUES
('Unidade Feira', 'FSA', 'Feira de Santana'), ('Unidade Salvador', 'SSA', 'Salvador'), ('Unidade Camaçari', 'CAM', 'Camaçari'),
('Unidade Lauro', 'LAU', 'Lauro de Freitas'), ('Unidade Simões', 'SIM', 'Simões Filho'), ('Unidade Conquista', 'VDC', 'Vitória da Conquista'),
('Unidade Itabuna', 'ITA', 'Itabuna'), ('Unidade Ilhéus', 'ILH', 'Ilhéus'), ('Unidade Juazeiro', 'JUA', 'Juazeiro'),
('Unidade Barreiras', 'BAR', 'Barreiras'), ('Unidade Jequié', 'JEQ', 'Jequié'), ('Unidade Alagoinhas', 'ALA', 'Alagoinhas'),
('Unidade Teixeira', 'TXF', 'Teixeira de Freitas'), ('Unidade Porto', 'BPS', 'Porto Seguro'), ('Unidade Eunápolis', 'EUN', 'Eunápolis'),
('Unidade Paulo Afonso', 'PAF', 'Paulo Afonso'), ('Unidade S. Antônio', 'SAJ', 'Santo Antônio de Jesus'), ('Unidade Valença', 'VAL', 'Valença'),
('Unidade Candeias', 'CND', 'Candeias'), ('Unidade Guanambi', 'GNB', 'Guanambi'), ('Unidade Jacobina', 'JCB', 'Jacobina'),
('Unidade Serrinha', 'SER', 'Serrinha'), ('Unidade Bonfim', 'SDB', 'Senhor do Bonfim'), ('Unidade Dias D''Avila', 'DDA', 'Dias d''Ávila'),
('Unidade LEM', 'LEM', 'Luís Eduardo Magalhães'), ('Unidade Irecê', 'IRE', 'Irecê'), ('Unidade Casa Nova', 'CNV', 'Casa Nova'),
('Unidade Bom Jesus', 'BJL', 'Bom Jesus da Lapa'), ('Unidade Itapetinga', 'ITP', 'Itapetinga'), ('Unidade Coité', 'CDC', 'Conceição do Coité');

-- 2. Setores (30 registros)
INSERT INTO setor (nome_setor, descricao) VALUES
('Almoxarifado', 'Controle de estoque'), ('Manutenção', 'Reparos gerais'), ('Produção', 'Chão de fábrica'),
('TI', 'Tecnologia'), ('RH', 'Recursos Humanos'), ('Financeiro', 'Finanças'), ('Logística', 'Transporte'),
('Qualidade', 'Inspeção'), ('Segurança do Trabalho', 'Prevenção'), ('Compras', 'Aquisições'),
('Vendas', 'Comercial'), ('Marketing', 'Propaganda'), ('Engenharia', 'Projetos'), ('Diretoria', 'Gestão'),
('Jurídico', 'Legal'), ('Frota', 'Veículos'), ('Recepção', 'Atendimento'), ('Limpeza', 'Conservação'),
('Copa', 'Alimentação'), ('Usinagem', 'Tornos e fresas'), ('Solda', 'Soldagem metálica'), ('Pintura', 'Acabamento'),
('Montagem', 'Montagem de peças'), ('Embalagem', 'Preparação envio'), ('Expedição', 'Despacho'), ('Auditoria', 'Conformidade'),
('Treinamento', 'Capacitação'), ('P&D', 'Pesquisa e Desenvolvimento'), ('Atendimento', 'SAC'), ('Ouvidoria', 'Reclamações');

-- 3. Tamanhos (30 registros)
INSERT INTO tamanho (descricao) VALUES
('PP'), ('P'), ('M'), ('G'), ('GG'), ('XG'), ('XXG'), ('34'), ('35'), ('36'),
('37'), ('38'), ('39'), ('40'), ('41'), ('42'), ('43'), ('44'), ('45'), ('46'),
('Luva 6'), ('Luva 7'), ('Luva 8'), ('Luva 9'), ('Luva 10'), ('Luva 11'), ('Único'), ('Ajustável'), ('Especial'), ('Sob Medida');

-- 4. Tipos EPI (30 registros)
INSERT INTO tipo_epi (nome_epi, ca, instrucoes_uso) VALUES
('Capacete de Segurança', 'CA498', 'Risco de queda de objetos'), ('Luva Nitrílica', 'CA16312', 'Químicos leves'),
('Óculos Incolor', 'CA9722', 'Partículas volantes'), ('Bota de Segurança', 'CA17044', 'Impacto nos pés'),
('Protetor Auricular Plug', 'CA5674', 'Ruído elevado'), ('Máscara PFF2', 'CA38943', 'Poeiras e fumos'),
('Avental de PVC', 'CA28193', 'Respingos'), ('Cinto Paraquedista', 'CA35520', 'Trabalho em altura'),
('Mangote de Proteção', 'CA20134', 'Abrasão e calor'), ('Protetor Facial', 'CA27901', 'Partículas frontais'),
('Luva de Raspa', 'CA10111', 'Abrasão pesada'), ('Luva de Vaqueta', 'CA10222', 'Serviços gerais e elétrica'),
('Avental de Raspa', 'CA10333', 'Solda e calor'), ('Perneira', 'CA10444', 'Animais peçonhentos'),
('Capacete com Jugular', 'CA10555', 'Altura'), ('Óculos Escuro', 'CA10666', 'Luz solar intensa'),
('Protetor Concha', 'CA10777', 'Ruído extremo'), ('Máscara de Solda', 'CA10888', 'Luz intensa e fagulhas'),
('Respirador Semifacial', 'CA10999', 'Gases'), ('Filtro VO', 'CA11000', 'Vapores orgânicos'),
('Creme Protetor', 'CA11111', 'Produtos químicos na pele'), ('Botina de Elástico', 'CA11222', 'Uso geral'),
('Cinto Eletricista', 'CA11333', 'Posicionamento'), ('Talabarte Y', 'CA11444', 'Deslocamento seguro'),
('Touca Árabe', 'CA11555', 'Proteção do pescoço'), ('Luva Isolante', 'CA11666', 'Alta tensão'),
('Braçadeira', 'CA11777', 'Identificação'), ('Colete Refletivo', 'CA11888', 'Sinalização viária'),
('Capa de Chuva', 'CA11999', 'Intempéries'), ('Bota de PVC', 'CA12000', 'Umidade');

-- 5. Fornecedor (30 registros)
INSERT INTO fornecedor (nome_fornecedor, cnpj, telefone, email) VALUES
('EPI Brasil', '12.345.678/0001-10', '75999990001', 'contato@epibrasil.com'), ('Segurança Total', '98.765.432/0001-55', '75999990002', 'vendas@segurancatotal.com'),
('Protege Equipamentos', '11.222.333/0001-99', '75999990003', 'comercial@protege.com'), ('Fort EPI', '11.234.567/0001-04', '75999990004', 'contato@fortepi.com'),
('Top Segurança', '11.234.567/0001-05', '75999990005', 'contato@topseguranca.com'), ('Alpha Equipamentos', '11.234.567/0001-06', '75999990006', 'contato@alphaequip.com'),
('Delta Safety', '11.234.567/0001-07', '75999990007', 'contato@deltasafety.com'), ('Prime EPI', '11.234.567/0001-08', '75999990008', 'contato@primeepi.com'),
('Master Segurança', '11.234.567/0001-09', '75999990009', 'contato@masterseg.com'), ('Nacional EPIs', '11.234.567/0001-10', '75999990010', 'contato@nacionalepi.com'),
('Global Safety', '11.234.567/0001-11', '75999990011', 'contato@globalsafety.com'), ('Pro Work EPI', '11.234.567/0001-12', '75999990012', 'contato@prowork.com'),
('Segurmax', '11.234.567/0001-13', '75999990013', 'contato@segurmax.com'), ('Protege Brasil', '11.234.567/0001-14', '75999990014', 'contato@protegebr.com'),
('Total Segurança', '11.234.567/0001-15', '75999990015', 'contato@totalseg.com'), ('Ultra Safety', '11.234.567/0001-16', '75999990016', 'contato@ultrasafety.com'),
('Worker Equipamentos', '11.234.567/0001-17', '75999990017', 'contato@worker.com'), ('Ideal EPI', '11.234.567/0001-18', '75999990018', 'contato@idealepi.com'),
('Safe Work', '11.234.567/0001-19', '75999990019', 'contato@safework.com'), ('Pro Safety', '11.234.567/0001-20', '75999990020', 'contato@prosafety.com'),
('Fortaleza EPIs', '11.234.567/0001-21', '75999990021', 'contato@fortalezaepi.com'), ('Trabalhe Seguro', '11.234.567/0001-22', '75999990022', 'contato@trabalheseguro.com'),
('Central de EPIs', '11.234.567/0001-23', '75999990023', 'contato@centralepi.com'), ('Safety Brasil', '11.234.567/0001-24', '75999990024', 'contato@safetybr.com'),
('Work Safe Equip', '11.234.567/0001-25', '75999990025', 'contato@worksafe.com'), ('EquipSeg', '11.234.567/0001-26', '75999990026', 'contato@equipseg.com'),
('Proteção Industrial', '11.234.567/0001-27', '75999990027', 'contato@protecaoind.com'), ('Ind Safety', '11.234.567/0001-28', '75999990028', 'contato@indsafety.com'),
('Seg Profissional', '11.234.567/0001-29', '75999990029', 'contato@segprof.com'), ('EPIs do Vale', '11.234.567/0001-30', '75999990030', 'contato@epivale.com');

-- 6. Usuarios do Sistema (30 registros)
INSERT INTO usuario_sistema (nome, email, senha, perfil) VALUES
('Administrador', 'admin@empresa.com', '123456', 'ADMIN'), ('Op Almoxarifado', 'almox@empresa.com', '123456', 'OPERADOR'),
('Supervisor 1', 'sup1@empresa.com', '123456', 'SUPERVISOR'), ('Operador 1', 'op1@empresa.com', '123456', 'OPERADOR'),
('Operador 2', 'op2@empresa.com', '123456', 'OPERADOR'), ('Operador 3', 'op3@empresa.com', '123456', 'OPERADOR'),
('Gestor TI', 'ti@empresa.com', '123456', 'ADMIN'), ('Auditor 1', 'aud1@empresa.com', '123456', 'SUPERVISOR'),
('Operador 4', 'op4@empresa.com', '123456', 'OPERADOR'), ('Operador 5', 'op5@empresa.com', '123456', 'OPERADOR'),
('Supervisor 2', 'sup2@empresa.com', '123456', 'SUPERVISOR'), ('Gestor RH', 'rh@empresa.com', '123456', 'ADMIN'),
('Operador 6', 'op6@empresa.com', '123456', 'OPERADOR'), ('Operador 7', 'op7@empresa.com', '123456', 'OPERADOR'),
('Operador 8', 'op8@empresa.com', '123456', 'OPERADOR'), ('Operador 9', 'op9@empresa.com', '123456', 'OPERADOR'),
('Supervisor 3', 'sup3@empresa.com', '123456', 'SUPERVISOR'), ('Auditor 2', 'aud2@empresa.com', '123456', 'SUPERVISOR'),
('Operador 10', 'op10@empresa.com', '123456', 'OPERADOR'), ('Operador 11', 'op11@empresa.com', '123456', 'OPERADOR'),
('Operador 12', 'op12@empresa.com', '123456', 'OPERADOR'), ('Gestor Seg', 'seg@empresa.com', '123456', 'ADMIN'),
('Supervisor 4', 'sup4@empresa.com', '123456', 'SUPERVISOR'), ('Operador 13', 'op13@empresa.com', '123456', 'OPERADOR'),
('Operador 14', 'op14@empresa.com', '123456', 'OPERADOR'), ('Operador 15', 'op15@empresa.com', '123456', 'OPERADOR'),
('Operador 16', 'op16@empresa.com', '123456', 'OPERADOR'), ('Supervisor 5', 'sup5@empresa.com', '123456', 'SUPERVISOR'),
('Operador 17', 'op17@empresa.com', '123456', 'OPERADOR'), ('Auditor 3', 'aud3@empresa.com', '123456', 'SUPERVISOR');

-- 7. Funcionários (30 registros - Corrigido o id_tamanho_padrao)
INSERT INTO funcionario (nome, cargo, id_setor, id_unidade, status, id_tamanho_padrao) VALUES
('Carlos Silva', 'Soldador', 21, 1, TRUE, 3), ('Ana Oliveira', 'Pintor', 22, 2, TRUE, 2),
('Marcos Souza', 'Mecânico', 2, 3, TRUE, 4), ('Julia Costa', 'Engenheira', 13, 4, TRUE, 2),
('Ricardo Alves', 'Tec. Segurança', 9, 5, TRUE, 3), ('Fernanda Lima', 'Soldador', 21, 6, TRUE, 2),
('Paulo Santos', 'Pintor', 22, 7, TRUE, 4), ('Beatriz Rocha', 'Almoxarife', 1, 8, TRUE, 2),
('Lucas Mendes', 'Mecânico', 2, 9, TRUE, 3), ('Mariana Ferreira', 'Soldador', 21, 10, TRUE, 3),
('Roberto Dias', 'Eletricista', 2, 11, TRUE, 4), ('Camila Nunes', 'Pintor', 22, 12, TRUE, 2),
('Bruno Castro', 'Soldador', 21, 13, TRUE, 3), ('Amanda Silva', 'Engenheira', 13, 14, TRUE, 2),
('Diego Ramos', 'Mecânico', 2, 15, TRUE, 4), ('Larissa Moraes', 'Tec. Segurança', 9, 16, TRUE, 2),
('Gabriel Ortiz', 'Eletricista', 2, 17, TRUE, 3), ('Vanessa Guedes', 'Almoxarife', 1, 18, TRUE, 2),
('Thiago Luz', 'Soldador', 21, 19, FALSE, 4), ('Sonia Abrantes', 'Pintor', 22, 20, TRUE, 3),
('Felipe Neto', 'Mecânico', 2, 21, TRUE, 4), ('Renata Igaci', 'Soldador', 21, 22, TRUE, 2),
('Hugo Boss', 'Eletricista', 2, 23, FALSE, 3), ('Patrícia Poeta', 'Engenheira', 13, 24, TRUE, 2),
('Otávio Mesquita', 'Soldador', 21, 25, FALSE, 4), ('Zeca Pagodinho', 'Pintor', 22, 26, TRUE, 3),
('Arlindo Cruz', 'Mecânico', 2, 27, FALSE, 4), ('Ivete Sangalo', 'Tec. Segurança', 9, 28, TRUE, 2),
('Gilberto Gil', 'Eletricista', 2, 29, FALSE, 3), ('Caetano Veloso', 'Soldador', 21, 30, TRUE, 3);

-- 8. Estoque (Exatamente 30 registros - Sem duplicações ou cruzas aleatórias)
INSERT INTO estoque (id_tipo_epi, id_tamanho, id_unidade, quantidade_disponivel, quantidade_minima) VALUES
(1, 27, 1, 50, 10), (2, 23, 2, 80, 15), (3, 27, 3, 40, 5), (4, 13, 4, 30, 8), (5, 27, 5, 100, 20),
(6, 27, 6, 60, 10), (7, 4, 7, 25, 5), (8, 28, 8, 15, 3), (9, 27, 9, 45, 10), (10, 28, 10, 35, 5),
(11, 24, 11, 55, 10), (12, 22, 12, 40, 10), (13, 4, 13, 20, 5), (14, 28, 14, 18, 5), (15, 27, 15, 30, 8),
(16, 27, 16, 70, 15), (17, 27, 17, 45, 10), (18, 28, 18, 12, 2), (19, 27, 19, 25, 5), (20, 27, 20, 80, 20),
(21, 27, 21, 100, 15), (22, 14, 22, 35, 5), (23, 28, 23, 10, 2), (24, 28, 24, 14, 3), (25, 27, 25, 50, 10),
(26, 24, 26, 20, 5), (27, 27, 27, 60, 10), (28, 28, 28, 40, 8), (29, 4, 29, 30, 5), (30, 15, 30, 25, 5);

-- 9. Compra EPI (30 registros)
INSERT INTO compra_epi (data_emissao_nf, numero_nota_fiscal, valor_total_compra, metodo_pagamento, id_fornecedor) VALUES
('2024-01-10','NF1001',3200.50,'Boleto',1), ('2024-01-15','NF1002',2850.00,'PIX',2), ('2024-01-20','NF1003',4100.75,'Transferência',3),
('2024-01-25','NF1004',1500.40,'Boleto',4), ('2024-02-01','NF1005',2750.90,'PIX',5), ('2024-02-05','NF1006',3680.00,'Cartão',6),
('2024-02-10','NF1007',4200.00,'Boleto',7), ('2024-02-15','NF1008',1990.60,'Transferência',8), ('2024-02-20','NF1009',3150.30,'PIX',9),
('2024-02-25','NF1010',2899.99,'Boleto',10), ('2024-03-02','NF1011',3550.50,'PIX',11), ('2024-03-05','NF1012',2400.00,'Cartão',12),
('2024-03-10','NF1013',3999.90,'Transferência',13), ('2024-03-15','NF1014',1800.00,'Boleto',14), ('2024-03-20','NF1015',2650.70,'PIX',15),
('2024-03-25','NF1016',3100.40,'Cartão',16), ('2024-04-01','NF1017',4200.00,'Transferência',17), ('2024-04-05','NF1018',2300.50,'PIX',18),
('2024-04-10','NF1019',2950.80,'Boleto',19), ('2024-04-15','NF1020',3600.20,'Cartão',20), ('2024-04-20','NF1021',2100.00,'PIX',21),
('2024-04-25','NF1022',3400.75,'Boleto',22), ('2024-05-01','NF1023',2750.30,'Transferência',23), ('2024-05-05','NF1024',1999.99,'Cartão',24),
('2024-05-10','NF1025',4100.60,'PIX',25), ('2024-05-15','NF1026',3800.00,'Boleto',26), ('2024-05-20','NF1027',2600.90,'Transferência',27),
('2024-05-25','NF1028',3150.50,'Cartão',28), ('2024-06-01','NF1029',2900.40,'PIX',29), ('2024-06-05','NF1030',3300.00,'Boleto',30);

-- 10. Item Compra (Exatamente 30 registros)
INSERT INTO item_compra (id_compra, id_tipo_epi, id_tamanho, quantidade, valor_unitario) VALUES
(1,1,27,50,45.00), (2,2,23,80,12.50), (3,3,27,40,30.00), (4,4,13,35,95.00), (5,5,27,120,5.50),
(6,6,27,70,6.80), (7,7,4,45,28.00), (8,8,28,20,150.00), (9,9,27,60,18.00), (10,10,28,50,22.00),
(11,11,24,55,14.00), (12,12,22,90,16.00), (13,13,4,50,29.00), (14,14,28,30,18.00), (15,15,27,110,48.20),
(16,16,27,60,25.10), (17,17,27,35,27.00), (18,18,28,15,155.00), (19,19,27,70,45.00), (20,20,27,65,23.00),
(21,21,27,60,15.00), (22,22,14,75,85.80), (23,23,28,42,120.00), (24,24,28,38,92.00), (25,25,27,130,8.30),
(26,26,24,80,65.50), (27,27,27,48,16.50), (28,28,28,22,35.00), (29,29,4,68,22.50), (30,30,15,52,41.50);

-- 11. Entrega EPI (Exatamente 30 registros atrelados ao Estoque)
INSERT INTO entrega_epi (data_entrega, id_funcionario, quantidade_entregue, id_usuario_registro, id_estoque) VALUES
('2024-02-01',1,1,1,1), ('2024-02-02',2,2,2,2), ('2024-02-03',3,1,3,3), ('2024-02-04',4,1,4,4), ('2024-02-05',5,2,5,5),
('2024-02-06',6,1,6,6), ('2024-02-07',7,1,7,7), ('2024-02-08',8,1,8,8), ('2024-02-09',9,2,9,9), ('2024-02-10',10,1,10,10),
('2024-02-11',11,1,11,11), ('2024-02-12',12,2,12,12), ('2024-02-13',13,1,13,13), ('2024-02-14',14,1,14,14), ('2024-02-15',15,2,15,15),
('2024-02-16',16,1,16,16), ('2024-02-17',17,1,17,17), ('2024-02-18',18,1,18,18), ('2024-02-19',19,2,19,19), ('2024-02-20',20,1,20,20),
('2024-02-21',21,1,21,21), ('2024-02-22',22,2,22,22), ('2024-02-23',23,1,23,23), ('2024-02-24',24,1,24,24), ('2024-02-25',25,1,25,25),
('2024-02-26',26,2,26,26), ('2024-02-27',27,1,27,27), ('2024-02-28',28,1,28,28), ('2024-02-29',29,2,29,29), ('2024-03-01',30,1,30,30);

-- 12. Devolucao EPI (Exatamente 30 registros mapeando as entregas 1 a 30)
INSERT INTO devolucao_epi (id_entrega, data_devolucao, motivo, quantidade, id_usuario_registro) VALUES
(1,'2024-03-10','Substituição preventiva',1,1), (2,'2024-03-11','Troca de tamanho',1,2), (3,'2024-03-12','Equipamento com defeito',1,3),
(4,'2024-03-13','Substituição preventiva',1,4), (5,'2024-03-14','Desligamento do funcionário',1,5), (6,'2024-03-15','Troca por modelo novo',1,6),
(7,'2024-03-16','EPI danificado',1,7), (8,'2024-03-17','Substituição preventiva',1,8), (9,'2024-03-18','Erro na entrega',1,9),
(10,'2024-03-19','Equipamento com defeito',1,10), (11,'2024-03-20','Substituição preventiva',1,11), (12,'2024-03-21','Desligamento',1,12),
(13,'2024-03-22','Troca por modelo novo',1,13), (14,'2024-03-23','EPI danificado',1,14), (15,'2024-03-24','Erro na entrega',1,15),
(16,'2024-03-25','Troca de tamanho',1,16), (17,'2024-03-26','Equipamento com defeito',1,17), (18,'2024-03-27','Substituição preventiva',1,18),
(19,'2024-03-28','Desligamento do funcionário',1,19), (20,'2024-03-29','Troca por modelo novo',1,20), (21,'2024-03-30','EPI danificado',1,21),
(22,'2024-03-31','Erro na entrega',1,22), (23,'2024-04-01','Troca de tamanho',1,23), (24,'2024-04-02','Equipamento com defeito',1,24),
(25,'2024-04-03','Substituição preventiva',1,25), (26,'2024-04-04','Desligamento',1,26), (27,'2024-04-05','Troca por modelo novo',1,27),
(28,'2024-04-06','EPI danificado',1,28), (29,'2024-04-07','Erro na entrega',1,29), (30,'2024-04-08','Troca de tamanho',1,30);

-- Views --

-- Inventário Geral --
CREATE OR REPLACE VIEW vw_inventario_geral AS
SELECT 
    te.nome_epi,
    t.descricao AS tamanho,
    SUM(e.quantidade_disponivel) AS quantidade_total
FROM 
    estoque e
JOIN 
    tipo_epi te ON e.id_tipo_epi = te.id
JOIN 
    tamanho t ON e.id_tamanho = t.id
GROUP BY 
    te.nome_epi, 
    t.descricao
ORDER BY 
    te.nome_epi, 
    t.descricao;

-- Entregas por Setor --

CREATE OR REPLACE VIEW vw_entregas_por_setor AS
SELECT 
    s.nome_setor,
    SUM(ee.quantidade_entregue) AS total_epis_entregues
FROM 
    entrega_epi ee
JOIN 
    funcionario f ON ee.id_funcionario = f.id
JOIN 
    setor s ON f.id_setor = s.id
GROUP BY 
    s.nome_setor
ORDER BY 
    total_epis_entregues DESC;

-- Controle de EPIs Vencidos --

ALTER TABLE tipo_epi ADD COLUMN IF NOT EXISTS validade_dias INT NOT NULL DEFAULT 180;

-- Inserção de data de vencimento (em dias) -- 
UPDATE tipo_epi SET validade_dias = 1800 WHERE id = 1; -- Capacete de Segurança (5 anos)
UPDATE tipo_epi SET validade_dias = 30   WHERE id = 2; -- Luva de Proteção Nitrílica (1 mês)
UPDATE tipo_epi SET validade_dias = 365  WHERE id = 3; -- Óculos de Proteção Incolor (1 ano)
UPDATE tipo_epi SET validade_dias = 365  WHERE id = 4; -- Bota de Segurança com Biqueira (1 ano)
UPDATE tipo_epi SET validade_dias = 90   WHERE id = 5; -- Protetor Auricular Tipo Plug (3 meses)
UPDATE tipo_epi SET validade_dias = 15   WHERE id = 6; -- Máscara Respiratória PFF2 (15 dias)
UPDATE tipo_epi SET validade_dias = 180  WHERE id = 7; -- Avental de PVC (6 meses)
UPDATE tipo_epi SET validade_dias = 1095 WHERE id = 8; -- Cinto de Segurança Tipo Paraquedista (3 anos)
UPDATE tipo_epi SET validade_dias = 180  WHERE id = 9; -- Mangote de Proteção (6 meses)
UPDATE tipo_epi SET validade_dias = 365  WHERE id = 10;-- Protetor Facial (1 ano)

CREATE OR REPLACE VIEW vw_funcionarios_epi_vencido AS
SELECT 
    f.nome AS nome_funcionario,
    s.nome_setor,
    te.nome_epi,
    ee.data_entrega,
    te.validade_dias,
    (ee.data_entrega + (te.validade_dias || ' days')::INTERVAL)::DATE AS data_vencimento
FROM 
    entrega_epi ee
JOIN 
    funcionario f ON ee.id_funcionario = f.id
JOIN 
    setor s ON f.id_setor = s.id
JOIN 
    estoque est ON ee.id_estoque = est.id
JOIN 
    tipo_epi te ON est.id_tipo_epi = te.id
LEFT JOIN 
    devolucao_epi de ON ee.id = de.id_entrega
WHERE 
    de.id IS NULL -- Garante que o funcionário ainda está com o EPI (ou seja, que ainda não devolveu)
    AND (ee.data_entrega + (te.validade_dias || ' days')::INTERVAL)::DATE < CURRENT_DATE;

