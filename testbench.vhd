-------------------------------------------------------------------
-- Name        : testbench.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamto de Eletrônica, Florianópolis, IFSC
-- Description : Script Modelsim para verificar o funcionamto do Registrador de Instruções
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
    signal clk          : std_logic;
    signal reset        : std_logic;
    signal en           : std_logic;
    --serão deletados
    signal C            : std_logic;
    signal V            : std_logic;
    signal N            : std_logic;
    signal cond         : unsigned(3 downto 0);
    signal deslocamento : unsigned(7 downto 0);
    signal mode         : unsigned(2 downto 0);
    signal src          : unsigned(5 downto 0);
    signal dst          : unsigned(5 downto 0);

BEGIN
    -- Instância do registrador
    dut : entity work.CPU
        port map(
            clk          => clk,
            reset        => reset,
            en           => en,
            C            => C,
            V            => V,
            N            => N,
            cond         => cond,
            deslocamento => deslocamento,
            mode         => mode,
            src          => src,
            dst          => dst
        );

    -- Instância do registrador

    --Sequência de processos para verificar o funcionamto.
    process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    Test : process
    begin
        reset <= '1';
        wait for 5 ns;
        reset <= '0';
        en    <= '1';
        wait;
    end process Test;

END ARCHITECTURE stimulus;
