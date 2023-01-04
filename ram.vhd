-------------------------------------------------------
--! @file
--! @version     : 0.2
--! @brief Simple synchronous memory. Optimized to infer
--         single-port RAM
--         MAX10 needs at least 32 words to infer RAM
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

entity ram is
    port(
        clk     : in  std_logic;
        addr    : in  unsigned(7 downto 0);
        -- Must exist to infer RAM.
        we      : in  std_logic;
        data_in : in  std_logic_vector(15 downto 0);
        q       : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of ram is

    -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector(15 downto 0);
    type memory_t is array (0 to 255) of word_t;

    signal ram : memory_t := (x"000A", x"0005", x"4200", x"7ADE", x"6996", x"2011", --Codigo em assembly de teste
                              others => (others => '0'));

begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            if we = '1' then
                ram(to_integer(addr)) <= data_in;
            end if;
            q <= ram(to_integer(addr));
        end if;
    end process;
end rtl;
