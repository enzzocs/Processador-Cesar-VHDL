-------------------------------------------------------------------
-- Name        : ULA.vhd
-- Author      : Enzzo Comassetto dos Santos
-- Version     : 0.1
-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
-- Description : ULA
-------------------------------------------------------------------
--Implementar a ULA (unidade lógica aritmética como descrito:

--Este componente é composto por três portas de entrada: operando A, operando B e pelo seletor de operação.
--Há duas portas de saída: os 16 bits mais significativos e os 16 bits menos significativos do resultado da operação.
--Esse componente é assíncrono.
--Os sinais A,B e resultados devem ser signed. A entrada aluop deve ser bit_vector.
--As operações da ULA serão visualisadas no código

-- Bibliotecas e clásulas
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Entidade e portas
ENTITY ULA IS
    PORT(A, B       : in  signed(15 downto 0);
         aluop      : in  std_logic_vector(4 downto 0);
         result_lsb : out signed(15 downto 0);
         C          : out std_logic;
         V          : out std_logic;
         N          : out std_logic;
         Z          : out std_logic);
END ENTITY;

-- Arquitetura
ARCHITECTURE operations OF ULA IS
    signal temp : signed(16 downto 0);  -- Temporario de 17 bits para realizar as operações
begin
    result_lsb <= temp(15 downto 0);    --LSB pega os 15 primeiros bits do temp
    C          <= temp(16);             --Carry
    V          <= temp(16);             --Overflow
    N          <= temp(15);             --Negative
    with aluop select temp <=
        resize(A + B, temp'length) when "00000", -- A+B
        resize(A - B, temp'length) when "00001", -- A-B
        resize(A and B, temp'length) when "00010", -- A and B
        resize(A or B, temp'length) when "00011", -- A or B
        (others => '0') when "00100",   -- CLR
        '0' & not A when "00101",       -- Not A
        resize(A + 1, temp'Length) when "00110", -- A + 1
        resize(A - 1, temp'Length) when "00111", -- A - 1
        resize(0 - A, temp'length) when "01000", -- Neg A
        rotate_right(resize(A,temp'length), 1) when "01001", -- Rotate “op” one bit right through carry
        rotate_left(resize(A,temp'length), 1) when "01010", -- Rotate “op” one bit left through carry
        '0' & shift_right(A, 1) when "01011", -- Shift “op” one bit right
        '0' & shift_left(A, 1) when "01100", -- Shift “op” one bit left
        (others => '0') when others;

    process(temp)
    begin
        if temp = x"0000" then
            Z <= '1';
        else
            Z <= '0';
        end if;
    end process;
END ARCHITECTURE;
