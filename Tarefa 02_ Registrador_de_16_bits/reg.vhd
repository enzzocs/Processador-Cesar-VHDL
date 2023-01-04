-------------------------------------------------------------------
-- Name        : reg.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Registrador de 16 bits
-------------------------------------------------------------------
--O registrador de 16 bits é responsável por registrar valores de 16 bits com operação de escrita 
--sincronizada com um sinal de clock.
--Possui quatro portas de entrada:
--clock (clk), entrada de dados (data_in), reset assíncrono (clear) e um bit de controle de escrita (w_flag)
--Reg_out é a saída com o valor registrado.
--
--Quanto ao comportamento, tem-se:
--A transação de escrita ocorre somente na subida do clock;
--Se reset (clear) é nível alto, reg_out recebe $0x0000$ (reset assíncrono). Reset tem prioridade máxima.
--Se w_flag é nível baixo, não acontece nada.


-- Bibliotecas e clásulas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entidades e portas
entity reg is
    port(
        signal clk     : in  std_logic; --Clock
        signal clear  : in  std_logic; --Clear assícrono 
        signal w_flag : in  std_logic; --Controle de escrita síncrono
        signal datain  : in  unsigned(15 downto 0); --Entrada de 16bits
        signal reg_out : out unsigned(15 downto 0) --Saida de 16 bits
    );
end entity reg;

architecture RTL of reg is

begin

    process(clk, clear)
    begin
        if clear = '1' then
            reg_out <= (others => '0');
        elsif rising_edge(clk) then
            if w_flag = '1' then
                reg_out <= datain;
            end if;
        end if;

    end process;

end architecture RTL;
