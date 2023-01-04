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
    signal clk        : std_logic; --Clock
    signal reset     : std_logic; --reset assícrono
    signal w_wr    : std_logic; --Controle de escrita síncrono
    signal w_addr : unsigned(2 downto 0);
    signal w_data     : unsigned(15 downto 0); --Entrada de 16bits
    signal ra_addr, rb_addr : unsigned (2 downto 0);
    signal ra_data, rb_data    : unsigned(15 downto 0); --Saidas d 16 bits

BEGIN
    -- Instância do banco
    dut : entity work.banco
        port map(
            clk     => clk,
            reset  => reset,
            w_wr => w_wr,
            w_addr => w_addr,
            w_data  => w_data,
            ra_addr => ra_addr,
            rb_addr => rb_addr,
            ra_data => ra_data,
            rb_data => rb_data
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
        reset  <= '1';
        w_wr <= '0';
        w_data  <= x"FFFF";
        w_addr <= "000";
        ra_addr <= "000";
        rb_addr <= "001";
        wait for 60 ns;

        reset  <= '0';
        w_wr <= '1';
        w_data  <= x"FFFE";
        w_addr <= "000";
        ra_addr <= "000";
        rb_addr <= "001";
        wait for 60 ns;

        reset  <= '0';
        w_wr <= '1';
        w_data  <= x"FFFE";
        w_addr <= "001";
        ra_addr <= "000";
        rb_addr <= "001";
        wait for 60 ns;

        reset  <= '0';
        w_wr <= '1';
        w_data  <= x"FFFC";
        w_addr <= "010";
        ra_addr <= "000";
        rb_addr <= "001";
        wait for 60 ns;
        
        reset  <= '0';
        w_wr <= '1';
        w_data  <= x"FFFC";
        w_addr <= "010";
        ra_addr <= "010";
        rb_addr <= "001";
        wait for 60 ns;
        
        reset  <= '0';
        w_wr <= '0';
        w_data  <= x"10AC";
        w_addr <= "010";
        ra_addr <= "000";
        rb_addr <= "001";
        wait for 60 ns;

        reset  <= '0';
        w_wr <= '1';
        w_data  <= x"10AC";
        w_addr <= "011";
        ra_addr <= "001";
        rb_addr <= "010";
        wait for 60 ns;
    end process Test;

END ARCHITECTURE stimulus;
