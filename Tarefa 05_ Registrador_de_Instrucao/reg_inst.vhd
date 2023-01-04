-------------------------------------------------------------------
-- Name        : reg.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Registrador de Intruções
-------------------------------------------------------------------
--O registrador de instruções é responsável pela separação dos componentes da instrução do processador. 
--Este componente recebe uma instrução de 16 bits da memória de instruções
--e ``quebra" de acordo com a descrição acima nas várias saídas do componente:
--A saída opcode recebe os 8 bits mais significativos
--As saídas mem_addr e imediate recebem os 8 bits menos significativos.
--Reset é nível alto, todas as saídas recebem 0;
--en é nível alto, as saídas recebem os dados decodificados conforme a entrada data na subida do clock.


-- Bibliotecas e clásulas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entidades e portas
entity reg_inst is
    port(
        signal clk     : in  std_logic; --Clock
        signal reset  : in  std_logic; --reset assícrono 
        signal en : in  std_logic; --Enable síncrono
        signal datain  : in  unsigned(15 downto 0); --Entrada de 16bits
        signal opcode: out  unsigned(3 downto 0); --opcode (bits mais significativos)
        signal cond: out unsigned(3 downto 0);
        signal deslocamento: out unsigned(7 downto 0);
        signal mode: out unsigned (2 downto 0);
        signal reg: out unsigned (2 downto 0);
        signal reg2: out unsigned (2 downto 0);
        signal src: out unsigned (5 downto 0);
        signal dst: out unsigned (5 downto 0)
    );
end entity reg_inst;

architecture RTL of reg_inst is

begin

    process(clk, reset)
    begin
        if reset = '1' then -- Condição Reset Assincrono ligado
            opcode <= (others=>'0');
            opcode <= (others=>'0');
            cond <= (others=>'0');
            deslocamento <= (others=>'0');
            mode <= (others=>'0');
            reg <= (others=>'0');
            reg2 <= (others=>'0');
            src <= (others=>'0');
            dst <= (others=>'0');
        elsif rising_edge(clk) then --Condição borda de subida clock
            if en = '1' then --Enable ligado
                opcode <= datain (15 downto 12);
                cond <= datain (11 downto 8);
                deslocamento <= datain (7 downto 0);
                mode <= datain (5 downto 3);
                reg <= datain (2 downto 0);
                reg2 <= datain (10 downto 8);
                src <= datain(11 downto 6);
                dst <= datain(5 downto 0);
            end if;
        end if;

    end process;

end architecture RTL;
