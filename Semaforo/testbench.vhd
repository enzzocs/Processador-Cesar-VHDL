-------------------------------------------------------------------
-- Name        : testbench.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Script Modelsim para verificar o funcionamento do Banco de Registradores
-------------------------------------------------------------------

-- Bibliotecas e clásulas
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
----------------------------------------------
ENTITY testbench IS
END ENTITY testbench;

ARCHITECTURE stimulus OF testbench IS
    -- Declaração de sinais
    signal clk, stby, test : std_logic;
    signal vermelho_1, amarelo_1, verde_1 : std_logic;
    signal vermelho_2, amarelo_2, verde_2 : std_logic;
BEGIN
    
    fsm : entity work.fsm
        port map(
            clk        => clk,
            stby       => stby,
            test       => test,
            vermelho_1 => vermelho_1,
            amarelo_1  => amarelo_1,
            verde_1    => verde_1,
            vermelho_2 => vermelho_2,
            amarelo_2  => amarelo_2,
            verde_2    => verde_2
        ) ;
    
    -- Instância do banco
    --Sequência de processos para verificar o funcionamento.
    process
    begin
        clk <= '0';
        wait for 8.33 ms;
        clk <= '1';
        wait for 8.33 ms;
    end process;

    Funcionamento : process
    begin
        stby <= '1';
        wait for 10 ms;
        
        stby <= '0';
        test <= '1';
        wait;
        
    end process Funcionamento;

END ARCHITECTURE stimulus;
