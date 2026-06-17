-- Saldo de Estoque por Unidade --

CREATE OR REPLACE FUNCTION fn_saldo_estoque_unidade(
    p_id_tipo_epi INT, 
    p_id_unidade INT
)
RETURNS INT AS $$
DECLARE
    v_saldo INT;
BEGIN
    -- Busca a quantidade disponível somada para o EPI e unidade correspondentes
    SELECT COALESCE(SUM(quantidade_disponivel), 0) INTO v_saldo
    FROM estoque
    WHERE id_tipo_epi = p_id_tipo_epi 
      AND id_unidade = p_id_unidade;

    RETURN v_saldo;
END;
$$ LANGUAGE plpgsql;
