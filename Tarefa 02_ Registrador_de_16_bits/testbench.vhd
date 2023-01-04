-------------------------------------------------------------------
-- Name        : testbench.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Script Modelsim para verificar o funcionamento do Registrador de 16 bits
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
    signal clk        : std_logic; --Clock
    signal clear     : std_logic; --Clear assícrono
    signal w_flag    : std_logic; --Controle de escrita síncrono
    signal datain     : unsigned(15 downto 0); --Entrada de 16bits
    signal reg_out    : unsigned(15 downto 0); --Saida d 16 bits

BEGIN
    -- Instância do registrador
    dut : entity work.reg
        port map(
            clk     => clk,
            clear  => clear,
            w_flag => w_flag,
            datain  => datain,
            reg_out => reg_out
        );
    --Sequência de processos para verificar o funcionamento.
    process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    Test : process
    begin
        clear  <= '1';
        w_flag <= '0';
        datain  <= x"FFFF";
        wait for 60 ns;

        clear  <= '1';
        w_flag <= '1';
        datain  <= x"FFFE";
        wait for 60 ns;

        clear  <= '0';
        w_flag <= '1';
        datain  <= x"FFFD";
        wait for 60 ns;

        clear  <= '1';
        w_flag <= '1';
        datain  <= x"FFFC";
        wait for 60 ns;

    end process Test;

END ARCHITECTURE stimulus;
