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
