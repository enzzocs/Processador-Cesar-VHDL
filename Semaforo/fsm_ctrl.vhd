library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
    port(
        clk        : in  std_logic;
        stby       : in  std_logic;
        test       : in  std_logic;
        vermelho_1 : out std_logic;
        amarelo_1  : out std_logic;
        verde_1    : out std_logic;
        vermelho_2 : out std_logic;
        amarelo_2  : out std_logic;
        verde_2    : out std_logic
    );
end entity fsm;

architecture RTL of fsm is
    type state_type is (AmAm, VmAm, VdVm, AmVm, VmVd);

    signal state     : state_type;
    signal pulso_1hz : std_logic;
    signal segundos  : natural;
begin

    -- Processo repsonsável apenas pela
    -- transição de estados
    state_transation : process(pulso_1hz, stby) is
    begin
        if (stby = '1') then
            state    <= AmAm;
            segundos <= 0;
        elsif rising_edge(pulso_1hz) then
            case state is
                when AmAm =>
                    state <= VmAm;
                when VmAm =>
                    if (test = '1') then
                        state <= VdVm;
                    elsif (test = '0') then
                        segundos <= segundos + 1;
                        if (segundos = 5) then
                            state    <= VdVm;
                            segundos <= 0;
                        end if;
                    end if;
                when VdVm =>
                    if (test = '1') then
                        state <= AmVm;
                    elsif (test = '0') then
                        segundos <= segundos + 1;
                        if (segundos = 45) then
                            state    <= AmVm;
                            segundos <= 0;
                        end if;
                    end if;
                when AmVm =>
                    if (test = '1') then
                        state <= VmVd;
                    elsif (test = '0') then
                        segundos <= segundos + 1;
                        if (segundos = 5) then
                            state    <= VmVd;
                            segundos <= 0;
                        end if;
                    end if;
                when VmVd =>
                    if (test = '1') then
                        state <= VmAm;
                    elsif (test = '0') then
                        segundos <= segundos + 1;
                        if (segundos = 30) then
                            state    <= VmAm;
                            segundos <= 0;
                        end if;
                    end if;
            end case;
        end if;
    end process;

    -- Saída(s) tipo Moore:
    -- Apenas relacionadas com o estado.
    moore : process(state)
    begin
        vermelho_1 <= '0';
        amarelo_1  <= '0';
        verde_1    <= '0';
        vermelho_2 <= '0';
        amarelo_2  <= '0';
        verde_2    <= '0';
        case state is
            when AmAm =>
                amarelo_1 <= '1';
                amarelo_2 <= '1';
            when VmAm =>
                vermelho_1 <= '1';
                amarelo_2  <= '1';
            when VdVm =>
                verde_1    <= '1';
                vermelho_2 <= '1';
            when AmVm =>
                amarelo_1  <= '1';
                vermelho_2 <= '1';
            when VmVd =>
                vermelho_1 <= '1';
                verde_2    <= '1';
        end case;

    end process;

    um_segundo : process(clk, stby)
        variable count_1 : natural range 0 to 60 := 0;
        variable temp    : std_logic             := '0';
    begin
        if (stby = '1') then
            count_1 := 0;
        elsif (rising_edge(clk)) then
            count_1 := count_1 + 1;
            if (count_1 = 60) then
                temp    := not temp;
                count_1 := 0;
            end if;
        end if;
        pulso_1hz <= temp;
    end process;

end architecture RTL;
