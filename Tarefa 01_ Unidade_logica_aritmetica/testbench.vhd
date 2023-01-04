-------------------------------------------------------------------
-- Name        : testbench.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : ULA
-------------------------------------------------------------------

-- Bibliotecas e clásulas
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-------------------------------------
ENTITY testbench IS
END ENTITY testbench;
------------------------------

ARCHITECTURE stimulus OF testbench IS

    -- Decaclaração do componente
    component ULA is
        port(A, B       : IN  signed(15 downto 0);
             aluop      : IN  std_logic_vector(4 downto 0);
             result_lsb : out signed(15 downto 0);
             C, V, N, Z : out std_logic);

    end component ULA;

    -- Declaração de sinais
    signal A          : signed(15 downto 0);
    signal B          : signed(15 downto 0);
    signal aluop      : std_logic_vector(4 downto 0);
    signal result_lsb : signed(15 downto 0);
    signal C, V, N, Z : std_logic;

BEGIN                                   -- Inicio do corpo da arquitetura

    -- Instância da ULA
    dut : ULA
        port map(
            A          => A,
            B          => B,
            aluop      => aluop,
            result_lsb => result_lsb,
            C          => C,
            V          => V,
            N          => N,
            Z          => Z);

    -- Processos para alterar A e B incrementando o aluop, mostrando dessa forma o comportamento para diferentes operandos e oprações
    process
    begin
        A <= x"0001";                   --A<B
        wait for 5 ns;
        A <= x"FFFF";                   --A=B
        wait for 5 ns;
        A <= x"0FFF";                   --A>B
        wait for 5 ns;
    end process;

    process
    begin
        B <= x"0002";
        wait for 5 ns;
        B <= x"FFFF";
        wait for 5 ns;
        B <= x"00FF";
        wait for 5 ns;
    end process;

    process
    begin

        for i in 0 to 13 loop
            aluop <= std_logic_vector(to_unsigned(i, aluop'Length));
            wait for 20 ns;
        end loop;
        wait;
    end process;

END ARCHITECTURE stimulus;
