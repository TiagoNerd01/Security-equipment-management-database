-- 0rder by quantidade total de itens por unidade --
SELECT 
    u.nome_unidade AS unidade,
    SUM(e.quantidade_disponivel) AS total_estoque
FROM estoque e
JOIN unidade u ON e.id_unidade = u.id
GROUP BY u.nome_unidade
ORDER BY u.nome_unidade;
-- Order by qunatidade de epis entregue a cada funcionário--
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









