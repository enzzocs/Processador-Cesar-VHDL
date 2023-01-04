-------------------------------------------------------------------
-- Name        : reg.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Banco de Registradores
-------------------------------------------------------------------
--Há uma porta de entrada de clock e um reset assíncrono.
--A porta de escrita é composta pelo sinal w_wr, pelo seletor de endereço w_addr e pela porta com os dados a serem gravados w_data.
--As portas de leitura seguem o mesmo princípio: há o seletor de qual registrador será lido ra_addr/rb_addr, porém as leituras são assíncronas.
--Os dados de leitura são dispostos ns portas de saída da leitura ra_data}/rb_data.
--O componente possui o seguinte comportamento:
--todas as leituras são assíncronas (não dependem do clock)
-- as duas portas de leitura podem ser lidas ao mesmo tempo
-- para leitura:
--rX_addr deve conter o endereço do registrador a ser lido
--para a escrita:
--w_addr deve conter o valor do registrador a ser escrito
--se w_wr é nível alto, registrador apontado por  w_addr recebe o valor de w_data na próxima borda de subida de clock;
--se w_wr é nível baixo, nenhuma transação é realizada.

-- Bibliotecas e clásulas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entidades e portas
entity banco is
    port(
        signal clk              : in  std_logic; --Clock
        signal reset            : in  std_logic; --reset assícrono 
        signal w_wr             : in  std_logic; --Controle de escrita síncrono
        signal w_addr           : in  unsigned(2 downto 0); --Escolhe o registrador a ser escrito
        signal w_data           : in  unsigned(15 downto 0); --Entrada de 16bits
        signal ra_addr, rb_addr : in  unsigned(2 downto 0); --Escolhe os registradores lidos pela saida
        signal ra_data, rb_data : out unsigned(15 downto 0) --Saida de 16 bits

    );
end entity banco;

architecture RTL of banco is
    type banco_reg is array (0 to 7) of unsigned(15 downto 0);

    signal reg : banco_reg;

begin

    process(clk, reset)                 -- @suppress "Superfluous signals in sensitivity list. The process is not sensitive to signal 'ra_addr'"
    begin
        if reset = '1' then             --Reset zera os registradores 
            for i in 0 to 7 loop
                reg(i) <= x"0000";
            end loop;
        elsif rising_edge(clk) then     -- Na subida do clock escreve o valor no registrador selecionado
            if w_wr = '1' then
                reg(to_integer(w_addr)) <= w_data;
            end if;
        end if;

    end process;
    ra_data <= reg(to_integer(ra_addr)); -- Saida 'a' recebe o registrador selecionado independente do clock
    rb_data <= reg(to_integer(rb_addr)); -- Saida 'b' recebe o registrador selecionado independente do clock
end architecture RTL;
