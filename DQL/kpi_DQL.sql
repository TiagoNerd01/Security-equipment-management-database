-- 0rder by quantidade total de itens por unidade --

SELECT 
    u.nome_unidade AS unidade,
    SUM(e.quantidade_disponivel) AS total_estoque
FROM estoque e
JOIN unidade u ON e.id_unidade = u.id
GROUP BY u.nome_unidade
ORDER BY u.nome_unidade;

-- Order by quantidade de epis entregue a cada funcionário--
select
	u.nome as funcionario,
	sum(e.quantidade_entregue) as total_entregue
from entrega_epi e
join funcionario u on e.id_funcionario = u.id 
group by u.nome 
order by u.nome;

-- Order by quantidade de funcionários alocados em cada setor --
SELECT 
    u.nome_setor AS setor,
    COUNT(e.id) AS total_funcionarios
FROM funcionario e
JOIN setor u ON e.id_setor = u.id
GROUP BY u.id, u.nome_setor
ORDER BY u.nome_setor;

-- Group by total gasto em epis separado por fornecedor --

select
	u.nome_fornecedor as fornecedor,
	sum(e.valor_total_compra) as total_gasto
from compra_epi e
join fornecedor u on e.id_fornecedor = u.id
group by u.id, u.nome_fornecedor
order by u.nome_fornecedor;

-- Union todas as unidades e setores em uma única lista --

SELECT 
	nome_unidade AS locais
FROM unidade
	UNION
SELECT 
	nome_setor AS locais
FROM setor;

-- union all todos os ids de epis na tabela de entregas e todos na tabela de devoluções --

SELECT 
	e.id_estoque, 'entrega' AS origem
FROM entrega_epi e
UNION ALL
SELECT en.id_estoque, 'devolucao' AS origem
FROM devolucao_epi d
JOIN entrega_epi en ON d.id_entrega = en.id;

-- Identifique os funcionários que possuem registros tanto de entrega quanto de devolução de equipamentos. 

SELECT a.id, a.nome 
FROM funcionario a
JOIN entrega_epi e ON a.id = e.id_funcionario
INTERSECT
SELECT a.id, a.nome 
FROM funcionario a
JOIN entrega_epi e ON a.id = e.id_funcionario
JOIN devolucao_epi d ON e.id = d.id_entrega;

-- Calcule o preço médio de compra de cada tipo de EPI. 

SELECT a.nome_epi, ROUND(AVG(ic.valor_unitario), 2) AS preco_medio
FROM tipo_epi a
JOIN item_compra ic ON a.id = ic.id_tipo_epi
GROUP BY a.nome_epi;

-- Liste os nomes de todos os funcionários e nomes de todos os fornecedores cadastrados.

SELECT nome AS nome_entidade, 'Funcionário' AS tipo FROM funcionario
UNION
SELECT nome_fornecedor AS nome_entidade, 'Fornecedor' AS tipo FROM fornecedor
ORDER BY nome_entidade;

-- Conte o número de devoluções processadas por cada usuário do sistema.

SELECT a.nome, COUNT(b.id) AS total_devolucoes
FROM usuario_sistema a
LEFT JOIN devolucao_epi b ON a.id = b.id_usuario_registro
GROUP BY a.nome;

-- Encontre os IDs de EPIs que estão cadastrados no estoque da "Unidade A" e também na "Unidade B".

SELECT id_tipo_epi FROM estoque WHERE id_unidade = 1
INTERSECT
SELECT id_tipo_epi FROM estoque WHERE id_unidade = 2;

-- Mostre a quantidade de EPIs por tamanho (P, M, G) disponíveis no sistema.

SELECT a.descricao AS tamanho, SUM(b.quantidade_disponivel) AS total_disponivel
FROM tamanho a
JOIN estoque b ON a.id = b.id_tamanho
GROUP BY a.descricao;
