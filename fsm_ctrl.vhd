library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;
        start        : in  std_logic;
        Z            : in  std_logic;
        rst_pc       : out std_logic;
        rst_reg_inst : out std_logic;
        rst_banco    : out std_logic;
        -- Reg_Inst
        opcode       : in  unsigned(3 downto 0);
        opcode2      : in  unsigned(3 downto 0);
        en_reg_inst  : out std_logic;
        --ULA
        aluop        : out std_logic_vector(4 downto 0);
        w_wr         : out std_logic;   --Controle de escrita síncrono
        --PC
        load_pc      : out std_logic;
        up_pc        : out std_logic;
        --ROM
        en_we_rom    : out std_logic;
        --RAM
        we_ram       : out std_logic;
        data_banco   : out std_logic
    );
end entity fsm;

architecture RTL of fsm is
    type state_type is (STOP, FETCH, DECODE, ULA_EXE, WR_BK_1, WR_BK_2, PC_UP, MOV, PC_UP_2, MOV2, SOB, SOB2);

    signal state : state_type;

begin

    -- Processo repsonsável apenas pela
    -- transição de estados
    state_transaction : process(clk, rst) is
    begin
        if rst = '1' then
            state <= STOP;
        elsif rising_edge(clk) then
            case state is
                when STOP =>
                    if start = '1' then
                        state <= FETCH;
                    end if;
                when FETCH =>
                    state <= DECODE;

                when DECODE =>
                    if ((opcode = "1000") or ((opcode >= "1010") and (opcode <= "1110"))) then --Operações ULA 1 e 2 operandos
                        state <= ULA_EXE;
                    elsif (opcode = "1001") then --MOV (acesso a memória)
                        state <= MOV;
                    elsif (opcode = "0101") then --SOB (branch, com decremento e comparação com 0)
                        state <= ULA_EXE;
                    end if;

                when ULA_EXE =>
                    if (opcode = "0101" and Z = '0') then --Caso o resultado não seja 0 é preciso repetir o laço
                        state <= SOB;
                    else
                        state <= WR_BK_2; --Outros casos segue a lógica de incrementr o PC
                    end if;
                when WR_BK_1 =>         --Atraso para salvar o resultado e depois incrementar o PC
                    state <= PC_UP;

                when WR_BK_2 =>
                    state <= WR_BK_1;

                when PC_UP =>
                    state <= FETCH;

                WHEN MOV =>
                    state <= MOV2;

                WHEN MOV2 =>
                    state <= PC_UP_2;

                WHEN PC_UP_2 =>
                    state <= PC_UP;
                when SOB =>
                    state <= SOB2;
                when SOB2 =>
                    state <= FETCH;

            end case;
        end if;
    end process;

    -- Saída(s) tipo Moore:
    -- Apenas relacionadas com o estado.
    moore : process(state)
    begin
        w_wr         <= '0';
        rst_banco    <= '0';
        rst_pc       <= '0';
        rst_reg_inst <= '0';
        load_pc      <= '0';
        en_we_rom    <= '0';
        we_ram       <= '0';
        up_pc        <= '0';
        en_reg_inst  <= '1';
        data_banco   <= '0';

        case state is
            when STOP =>                --Reseta os valores para iniciar a fsm
                rst_banco    <= '1';
                rst_pc       <= '1';
                rst_reg_inst <= '1';
            when FETCH =>
                null;
            when DECODE =>
                null;
            when ULA_EXE =>
                null;
            when WR_BK_1 =>
                w_wr  <= '1';           --Habilita a escrita no banco de registradores
                up_pc <= '1';           --Incrementa PC para a próxima instrução
            when WR_BK_2 =>
                null;
            when PC_UP =>
                null;
            when MOV =>
                data_banco <= '1';      --Muda a saida do mux para acesso a posição da memoria a ser carregada
                up_pc      <= '1';
            when PC_UP_2 =>
                up_pc      <= '1';
                data_banco <= '1';
            when MOV2 =>
                w_wr       <= '1';
                data_banco <= '1';
            when SOB =>
                w_wr <= '1';
            when SOB2 =>
                load_pc <= '1';         --Carrega o valor salvo para a volta do laço

        end case;
    end process;

    sel_op : process(opcode, opcode2)   --Compara o opcode para mandar o código certo da aluop
    begin
        if (opcode = "1010") then
            aluop <= "00000";           --ADD
        elsif (opcode = "1011") then
            aluop <= "00001";           --SUB
        elsif (opcode = "1101") then
            aluop <= "00010";           --AND
        elsif (opcode = "1110") then
            aluop <= "00011";           --OR

        elsif (opcode = "1000") then
            if (opcode2 = "0010") then
                aluop <= "00110";       --INC
            elsif (opcode2 = "0001") then
                aluop <= "00101";       --NOT
            elsif (opcode2 = "0011") then
                aluop <= "00111";       --DEC
            elsif (opcode2 <= "0100") then
                aluop <= "01000";       --NEG
            elsif (opcode2 <= "0000") then
                aluop <= "00100";       --CLR
            elsif (opcode2 <= "0110") then
                aluop <= "01001";       --ROR
            elsif (opcode2 <= "0111") then
                aluop <= "01010";       --ROL
            elsif (opcode2 <= "1000") then
                aluop <= "01011";       --ASR
            elsif (opcode2 <= "1001") then
                aluop <= "01100";       --ASR
            end if;

        elsif (opcode = "0101") then
            aluop <= "00111";
        else
            aluop <= "00001";
        end if;
    end process;
end architecture RTL;
