-------------------------------------------------------------------
-- Name        : testbench.vhd
-- Author      : Renan Augusto Starke
-- Version     : 0.1
-- Copyright   : Renan, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Exemplo de estimulus para testbenchs
-------------------------------------------------------------------

-- Bibliotecas e clásulas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------
entity testbench is
end entity testbench;
------------------------------

architecture stimulus of testbench is
    -- declaração de sinais
    signal clk  : std_logic := '0';
    signal addr : unsigned(15 downto 0);
    signal data : std_logic_vector(15 downto 0);

begin                                   -- inicio do corpo da arquitetura

    dut : entity work.ram
        port map(
            clk     => clk,
            addr    => addr,
            we      => '0',
            data_in => x"0000",
            q       => data
        );

    -- Laço de teste
    addr_gen : process
    begin
        for i in 0 to 31 loop
            addr <= to_unsigned(i, 16);
            wait for 20 ns;
        end loop;
        wait;
    end process;

    -- clock
    process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

end architecture stimulus;
