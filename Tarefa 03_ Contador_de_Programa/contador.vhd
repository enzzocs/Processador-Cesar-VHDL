-------------------------------------------------------------------
-- Name        : contador.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Contador de Programa
-------------------------------------------------------------------
--O contador de programa é um registrador responsável por manter a posição atual da sequência de execução das instruções do programa do processador.
--No caso desta CPU simples, o contador de programa oferece o endereço direto para a próxima instrução contida na memória de instruções.
--Este componente possui 5 entradas: clock, sinal load, sinal reset, up e entrada de dados de 16 bits. 
--Como saída apresenta o valor/endereço do programa em execução
--Load e data_in são utilizados na execução de instruções que interrompem o fluxo linear do programa
--Up incrementa o valor atual do registrador.

--O incremento e carregamento de data_in são sincronizados com o clk;
--Se reset é nível alto, data recebe 0 assincronamente;
--Se load é nível alto, data recebe data_in;
--Se up é nível alto, data é incrementado em 1;
--Se up e load são nível alto, load tem prioridade.


-- Bibliotecas e clásulas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entidades e portas
entity pc is
    port(
        signal clk     : in  std_logic; --Clock
        signal reset  : in  std_logic; --reset assícrono 
        signal load : in  std_logic; --Controle de escrita síncrono
        signal up: in std_logic; --Incrementa o valor do registrador
        signal datain  : in  std_logic_vector(15 downto 0); --Entrada de 16bits
        signal data : out std_logic_vector(15 downto 0) --Saida de 16 bits
    );
end entity pc;

architecture RTL of pc is
signal temp : std_logic_vector(15 downto 0); --temporario utilizado pois o vhdl não le saidas (data) para o incremento
begin

    process(clk, reset)
    begin
        if reset = '1' then
            temp <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                temp <= datain;
            elsif up = '1' then
                temp <= std_logic_vector(unsigned(temp) + 1);
            end if;
        end if;
    end process;
    data <= temp;

end architecture RTL;
