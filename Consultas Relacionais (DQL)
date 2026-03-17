-- 1- Left Join: Liste o nome de todos os funcionários e a unidade onde trabalham, incluindo os recém-contratados sem unidade definida.
SELECT a.nome AS funcionario,
  b.nome_unidade AS unidade
FROM funcionario a LEFT JOIN unidade b ON a.id_unidade = b.id;

-- 2- Inner Join: Exiba o nome do funcionário e o setor específico ao qual ele está alocado.
SELECT c.nome AS funcionario,
    d.nome_setor AS setor
FROM funcionario c INNER JOIN setor d ON c.id_setor = d.id;

-- 3 - Inner Join: Mostre a descrição do EPI entregue e o nome do funcionário que o recebeu.
SELECT a.nome_epi AS descricao_epi,
    v.nome AS funcionario FROM entrega_epi e INNER JOIN funcionario v ON e.id_funcionario = v.id 
    INNER JOIN estoque est ON e.id_estoque = est.id
INNER JOIN tipo_epi a ON est.id_tipo_epi = a.id;

-- 4- Liste todos os tipos de EPI cadastrados e as quantidades em estoque, mesmo para itens sem registro de entrada.
SELECT a.nome_epi, b.quantidade_disponivel FROM tipo_epi a LEFT JOIN estoque b ON a.id = b.id_tipo_epi;

-- 5- Relacione as devoluções de equipamentos com o nome do usuário do sistema que as processou.
SELECT a.id AS protocolo_devolucao, a.data_devolucao, c.nome AS usuario_processador FROM devolucao_epi a
INNER JOIN usuario_sistema c ON a.id_usuario_registro = c.id;

-- 6- Exiba o nome do fornecedor e os itens de compra vinculados a ele.
SELECT a.nome_fornecedor, c.numero_nota_fiscal, w.quantidade, w.valor_unitario FROM fornecedor a INNER JOIN compra_epi c ON a.id = c.id_fornecedor
INNER JOIN item_compra w ON c.id = w.id_compra;

-- 7- Liste todas as unidades da empresa e o estoque de EPIs disponível em cada uma, incluindo unidades sem estoque.
SELECT u.nome_unidade, u.cidade, te.nome_epi, e.quantidade_disponivel
FROM unidade u
LEFT JOIN funcionario f ON u.id = f.id_unidade
LEFT JOIN entrega_epi ent ON f.id = ent.id_funcionario
LEFT JOIN estoque e ON ent.id_estoque = e.id
LEFT JOIN tipo_epi te ON e.id_tipo_epi = te.id;

-- 8- Mostre o nome do funcionário e o cargo (permissão) que ele possui no sistema de controle.
SELECT f.nome AS nome_funcionario, f.cargo, s.nome_setor
FROM funcionario f
INNER JOIN setor s ON f.id_setor = s.id;

-- 9- Relacione o EPI e seu respectivo tamanho cadastrado na tabela de estoque.
SELECT te.nome_epi, t.descricao AS tamanho
FROM estoque e
INNER JOIN tipo_epi te ON e.id_tipo_epi = te.id
INNER JOIN tamanho t ON e.id_tamanho = t.id;

-- 10- Liste todos os setores cadastrados e os funcionários a eles vinculados, incluindo setores que ainda não possuem pessoal.
SELECT s.nome_setor, f.nome AS nome_funcionario
FROM funcionario f
RIGHT JOIN setor s ON f.id_setor = s.id;

-- 11- Exiba a data da entrega do EPI e o nome do fornecedor original daquele lote de equipamento.
SELECT ent.data_entrega, f.nome_fornecedor, te.nome_epi
FROM entrega_epi ent
INNER JOIN estoque e ON ent.id_estoque = e.id
INNER JOIN tipo_epi te ON e.id_tipo_epi = te.id
INNER JOIN item_compra ic ON te.id = ic.id_tipo_epi
INNER JOIN compra_epi c ON ic.id_compra = c.id
INNER JOIN fornecedor f ON c.id_fornecedor = f.id;

-- 12- Liste todos os registros de compras e o nome do fabricante do EPI, incluindo compras com fabricantes não identificados.
SELECT ce.data_emissao_nf, fo.nome_fornecedor AS fabricante_fornecedor
FROM compra_epi ce
LEFT JOIN fornecedor fo ON ce.id_fornecedor = fo.id;
