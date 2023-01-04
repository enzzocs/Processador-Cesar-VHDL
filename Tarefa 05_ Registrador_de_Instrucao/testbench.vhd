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
    signal clk: std_logic; --Clock
    signal reset: std_logic; --reset assícrono
    signal en: std_logic; --Controle de escrita síncrono
    signal datain: unsigned(15 downto 0); --trada de 16bits
    signal opcode: unsigned(3 downto 0); --opcode (bits mais significativos)
    signal cond: unsigned(3 downto 0);
    signal deslocamento: unsigned(7 downto 0);
    signal mode: unsigned (2 downto 0);
    signal reg: unsigned (2 downto 0);
    signal reg2: unsigned (2 downto 0);
    signal src: unsigned (5 downto 0);
    signal dst: unsigned (5 downto 0);


BEGIN
    -- Instância do registrador
    dut : entity work.reg_inst
        port map(
            clk          => clk,
            reset        => reset,
            en           => en,
            datain       => datain,
            opcode       => opcode,
            cond         => cond,
            deslocamento => deslocamento,
            mode         => mode,
            reg          => reg,
            reg2         => reg2,
            src          => src,
            dst          => dst
        ) ;
    
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
        reset  <= '1';
        en <= '0';
        datain  <= x"FFFF";
        wait for 60 ns;

        reset  <= '1';
        en <= '1';
        datain  <= x"FFFE";
        wait for 60 ns;

        reset  <= '0';
        en <= '1';
        datain  <= x"FFFD";
        wait for 60 ns;

        reset  <= '1';
        en <= '1';
        datain  <= x"FFFC";
        wait for 60 ns;

    end process Test;

END ARCHITECTURE stimulus;
