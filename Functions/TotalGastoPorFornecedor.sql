-- Total Gasto por Fornecedor --

CREATE OR REPLACE FUNCTION fn_total_gasto_por_fornecedor(
    p_id_fornecedor INT
)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_total_gasto DECIMAL(10,2);
BEGIN
    -- Calcula o montante com base na coluna valor_total_compra da tabela compra_epi
    SELECT COALESCE(SUM(valor_total_compra), 0) INTO v_total_gasto
    FROM compra_epi
    WHERE id_fornecedor = p_id_fornecedor;

    RETURN v_total_gasto;
END;
$$ LANGUAGE plpgsql;
