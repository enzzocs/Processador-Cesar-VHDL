library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    port(
        clk          : in  std_logic;
        reset        : in  std_logic;
        en           : in  std_logic;
        --serão deletados
        C            : out std_logic;
        V            : out std_logic;
        N            : out std_logic;
        cond         : out unsigned(3 downto 0);
        deslocamento : out unsigned(7 downto 0);
        mode         : out unsigned(2 downto 0);
        src          : out unsigned(5 downto 0);
        dst          : out unsigned(5 downto 0)
    );
end entity CPU;

architecture RTL of CPU is
    signal data_addr_rom : std_logic_vector(15 downto 0);
    signal q             : std_logic_vector(15 downto 0);
    signal A             : signed(15 downto 0);
    signal B             : signed(15 downto 0);
    signal ULA_Result    : signed(15 downto 0);
    signal opcode        : unsigned(3 downto 0);
    signal opcode2       : unsigned(3 downto 0);
    signal aluop         : std_logic_vector(4 downto 0);
    signal reg           : unsigned(2 downto 0);
    signal reg2          : unsigned(2 downto 0);
    signal w_wr          : std_logic;   --Controle de escrita síncrono

    --Resets
    signal rst_pc       : std_logic;
    signal rst_reg_inst : std_logic;
    signal rst_banco    : std_logic;

    --Enables
    signal load_pc     : std_logic;
    signal en_we_rom   : std_logic;
    signal en_reg_inst : std_logic;

    signal up_pc : std_logic;

    --Ram
    signal addr_ram : std_logic_vector(15 downto 0);
    signal we_ram   : std_logic;
    signal q_ram    : std_logic_vector(15 downto 0);

    signal data_banco : std_logic;
    signal banco_in   : signed(15 downto 0);
    signal rb_addr    : unsigned(2 downto 0);
    signal Z          : std_logic;
    signal datain     : unsigned(15 downto 0);
    signal data_in    : unsigned(7 downto 0);

begin
    contador : entity work.pc
        port map(
            clk    => clk,
            reset  => rst_pc,
            load   => load_pc,          --FSM
            up     => up_pc,            --FSM
            datain => std_logic_vector(datain), --?
            data   => data_addr_rom
        );

    rom_ram : entity work.rom
        port map(
            clk     => clk,
            addr    => unsigned(data_addr_rom),
            we      => en_we_rom,       --FSM
            data_in => (std_logic_vector(datain)), --?
            q       => q,
            q2      => addr_ram
        );

    reg_inst : entity work.reg_inst
        port map(
            clk          => clk,
            reset        => rst_reg_inst,
            en           => en_reg_inst,
            datain       => unsigned(q),
            opcode       => opcode,
            opcode2      => opcode2,
            cond         => cond,
            deslocamento => data_in,
            mode         => mode,
            reg          => reg,
            reg2         => reg2,
            src          => src,
            dst          => dst
        );

    ULA : entity work.ULA
        port map(
            A          => A,
            B          => B,
            aluop      => aluop,        --reg_inst
            result_lsb => ULA_Result,
            C          => C,
            V          => V,
            N          => N,
            Z          => Z
        );

    Banco : entity work.banco
        port map(
            clk     => clk,
            reset   => rst_banco,       --FSM
            w_wr    => w_wr,            -- FSM
            w_addr  => reg2,            --reg_inst
            w_data  => banco_in,        --ULA_Result,
            ra_addr => reg,             --reg_inst
            rb_addr => rb_addr,         --reg_inst
            ra_data => A,
            rb_data => B
        );

    fsm : entity work.fsm
        port map(
            clk          => clk,
            rst          => reset,
            start        => en,
            Z            => Z,
            rst_pc       => rst_pc,
            rst_reg_inst => rst_reg_inst,
            rst_banco    => rst_banco,
            opcode       => opcode,
            opcode2      => opcode2,
            en_reg_inst  => en_reg_inst,
            aluop        => aluop,
            w_wr         => w_wr,       --Banco
            load_pc      => load_pc,
            up_pc        => up_pc,
            en_we_rom    => en_we_rom,
            we_ram       => we_ram,
            data_banco   => data_banco
        );

    ram : entity work.ram
        port map(
            clk     => clk,
            addr    => unsigned(addr_ram(7 downto 0)),
            we      => we_ram,
            data_in => std_logic_vector(A),
            q       => q_ram
        );

    sel_data_banco : process(data_banco, ULA_Result, q_ram) --Mux para escolha de quem vai controlar o endereço do registrador de instruções, a ULA salva os resultados e a RAM carrega um valor em algum registrador
    begin
        if (data_banco = '0') then
            banco_in <= ULA_Result;
        elsif (data_banco = '1') then
            banco_in <= signed(q_ram);
        end if;
    end process;

    sel_pos_reg : process(opcode(3), opcode2(2 downto 0), reg2) --posição do registrador que sera utilizado na operação
    begin
        if (opcode(3) = '1') then
            rb_addr <= reg2;
        elsif (opcode(3) = '0') then
            rb_addr <= opcode2(2 downto 0);
        end if;
    end process;
    data : process(data_in)
    begin
        datain <= shift_right(x"00" & data_in, 1); --Como o PC incrementa em 1 mas originalmente ele é incrementado em 2, o shift divide o valor por 2
    end process;
end architecture RTL;
