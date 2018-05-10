library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util.all;

entity m45 is port(
    clk : in std_logic;
    maddr : in std_logic_vector(25 downto 0);
    mdata : inout std_logic_vector(15 downto 0);
    mclk, madv_c, mcre, mce_c, moe_c, mwe_c : in std_logic;
    mlb_c, mub_c : in std_logic);
end m45;

architecture arch of m45 is
    constant INIT_SIZE : integer := 56;
    constant APP_SIZE : integer := 256;
    constant STACK_SIZE : integer := 256;
    constant RAM_SIZE : integer := 128;

    constant BCALL0_L : integer := 16#00028#;
    constant BCALL0_R : integer := 16#0002a#;
    constant BCALL1_L : integer := 16#02a37#;
    constant BCALL1_R : integer := 16#02ab2#;
    constant BCALL2_L : integer := 16#0249f#;
    constant BCALL2_R : integer := 16#024b4#;

    constant INIT_L : integer := 16#7c000#;
    constant INIT_R : integer := INIT_L+INIT_SIZE-1;

    constant APP_L : integer := 16#85d49#;
    constant APP_R : integer := APP_L+APP_SIZE-1;

    constant RAM_L : integer := 16#80000#;
    constant RAM_R : integer := RAM_L+RAM_SIZE-1;

    constant STACK_R : integer := 16#7ffff#;
    constant STACK_L : integer := STACK_R-STACK_SIZE+1;

    type mem_t is array(integer range <>) of std_logic_vector(7 downto 0);

    impure function file_to_mem(filename : string; size : natural)
    return mem_t is
        use std.textio.all;
        type charfile is file of character;
        file file_p : charfile;
        variable word : character;
        variable mem : mem_t(0 to size-1);
        use ieee.numeric_std.all;
    begin
        mem := (others => x"00");
        file_open(file_p, filename, READ_MODE);
        for i in mem'range loop
            if endfile(file_p) then exit; end if; 
            read(file_p, word);
            mem(i) := std_logic_vector(to_unsigned(character'pos(word), 8));
        end loop;
        file_close(file_p);
        return mem;
    end function;

    procedure read(signal mem : inout mem_t;
                   signal a : in integer;
                   signal data : out std_logic_vector(15 downto 0)) is begin
        if mem'left <= a+1 and a+1 <= mem'right then
            data(15 downto 8) <= mem(a+1);
        end if;
        if mem'left <= a and a <= mem'right then
            data(7 downto 0) <= mem(a);
        end if;
    end procedure;

    procedure write(signal mem : inout mem_t;
                    signal mub_c, mlb_c : in std_logic;
                    signal a : in integer;
                    signal data : in std_logic_vector(15 downto 0)) is begin
        if mub_c = '0' then 
            if mem'left <= a+1 and a+1 <= mem'right then
                mem(a+1) <= data(15 downto 8);
            end if;
        end if;
        if mlb_c = '0' then 
            if mem'left <= a and a <= mem'right then
                mem(a) <= data(7 downto 0);
            end if;
        end if;
    end procedure;

    -- modifiable
    signal mem_ram : mem_t(RAM_L to RAM_R) := (others => x"00");
    signal mem_app : mem_t(APP_L to APP_R) := file_to_mem("a.bin", APP_SIZE);
    signal mem_stack : mem_t(STACK_L to STACK_R) := (others => x"00");

    -- jump to user ram fapp pc init
    signal mem_init : mem_t(INIT_L to INIT_R)
        := file_to_mem("tests/binary/init.z", INIT_SIZE);
    -- jump to bcall routine
    signal mem_bc0 : mem_t(BCALL0_L to BCALL0_R) := (x"c3", x"37", x"2a");
    -- bcall routine 1
    signal mem_bc1 : mem_t(BCALL1_L to BCALL1_R)
        := file_to_mem("bc1.bin", BCALL1_R-BCALL1_L+1);
    -- bcall routine 2
    signal mem_bc2 : mem_t(BCALL2_L to BCALL2_R)
        := file_to_mem("bc2.bin", BCALL2_R-BCALL2_L+1);

    signal word_out : std_logic_vector(15 downto 0);
    signal a_ub, a_lb : integer;
begin
    a_ub <= to_integer(unsigned(maddr))*2+1;
    a_lb <= to_integer(unsigned(maddr))*2;

    process(clk) begin
        if rising_edge(clk) then
            if mce_c = '0' then
                if mwe_c = '0' then
                    write(mem_app, mub_c, mlb_c, a_lb, mdata);
                    write(mem_ram, mub_c, mlb_c, a_lb, mdata);
                    write(mem_stack, mub_c, mlb_c, a_lb, mdata);
                end if;
                word_out <= x"7676";
                read(mem_init, a_lb, word_out);
                read(mem_app, a_lb, word_out);
                read(mem_ram, a_lb, word_out);
                read(mem_stack, a_lb, word_out);
                read(mem_bc0, a_lb, word_out);
                read(mem_bc1, a_lb, word_out);
                read(mem_bc2, a_lb, word_out);
            end if;
        end if;
    end process;

    mdata <= word_out when moe_c = '0' else (others => 'Z');
end arch;
