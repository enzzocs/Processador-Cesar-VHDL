-------------------------------------------------------
--! @file
--! @version     : 0.2
-- ROM feita a partir do código disponivel em https://github.com/xtarke/pld
-- Esta ROM guarda os comandos digitados no signal ROM que serão lidos a partir do valor disponibilizado no contador de programa
-------------------------------------------------------

--! Use IEE standard library
library ieee;
--! Use standard logic elements
use ieee.std_logic_1164.all;
--! Use conversion functions
use ieee.numeric_std.all;
--! Use read hex and io functions
use ieee.std_logic_textio.all;

--! Use standard library
use std.textio.all;

entity rom is
    port(
        clk     : in  std_logic;
        addr    : in  unsigned(15 downto 0); --Era 4 downto 0, mudança feita para ser igualado ao valor do PC
        -- Must exist to infer ROM.
        we      : in  std_logic;
        data_in : in  std_logic_vector(15 downto 0);
        q       : out std_logic_vector(15 downto 0);
        q2      : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of rom is

    -- Build a 2-D array type for the ROM
    subtype word_t is std_logic_vector(15 downto 0);
    type memory_t is array (0 to 31) of word_t;

    --    signal rom : memory_t := (x"8201", x"8202", x"A081", x"8300", x"8002", x"8105", x"B045", x"9BC3", x"0004", x"9BC4", x"0003", --Codigo em assembly de teste
    --                             others => (others => '0'));

    signal rom : memory_t := (x"9BC0", x"0000", x"9BC1", x"0001", x"B040", x"8202", x"8200", x"5008", x"A105", --Codigo em assembly de teste
                              others => (others => '0'));
begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            if we = '1' then
                rom(to_integer(addr)) <= data_in;
            end if;
            q  <= rom(to_integer(addr));
            q2 <= rom(to_integer(addr) + 1);
        end if;
    end process;
end rtl;
