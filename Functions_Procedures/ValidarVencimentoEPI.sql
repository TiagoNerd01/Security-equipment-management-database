-- Validar Vencimento do EPI entregue --

CREATE OR REPLACE FUNCTION fn_validar_vencimento_epi(
    p_id_entrega INT
)
RETURNS VARCHAR AS $$
DECLARE
    v_data_entrega DATE;
    v_validade_dias INT;
    v_data_vencimento DATE;
BEGIN
    -- Busca a data da entrega e o tempo limite em dias cadastrado na tabela tipo_epi
    SELECT 
        ee.data_entrega, 
        te.validade_dias INTO v_data_entrega, v_validade_dias
    FROM entrega_epi ee
    JOIN estoque est ON ee.id_estoque = est.id
    JOIN tipo_epi te ON est.id_tipo_epi = te.id
    WHERE ee.id = p_id_entrega;

    -- Se a entrega não existir no sistema, retorna um aviso
    IF v_data_entrega IS NULL THEN
        RETURN 'Entrega não encontrada';
    END IF;

    -- Faz o cálculo exato somando o intervalo de dias à data da entrega
    v_data_vencimento := (v_data_entrega + (v_validade_dias || ' days')::INTERVAL)::DATE;

    -- Compara com a data atual do servidor
    IF v_data_vencimento < CURRENT_DATE THEN
        RETURN 'Vencido';
    ELSE
        RETURN 'Dentro do prazo';
    END IF;
END;
$$ LANGUAGE plpgsql;
