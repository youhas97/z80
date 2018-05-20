library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- write jump addresses to memory for debugging
--
-- example:
--  0x803c: jp 0xf000
--  0xf0d0: call 0x9d95
--   yields:
--                  ____
-- LIST_BOTTOM --> |_3c_|
--                 |_80_|
--                 |_00_|
--                 |_f0_|
--                 |_d0_|
--                 |_f0_|
--                 |_95_|
--                 |_9d_|
--    list ptr --> |____|
--                   :   
--                   :   
--                 |____|
--                 |____|
-- running
--      hexdump -e '1/2 "%04x" " -> " 1/2 "%04x" "\n"' memdump.bin
-- outputs
--      8003 -> f000
--      f0d0 -> 9d95

entity trace is port(
    clk, rst, ce : in std_logic;
    jump_beg, jump_end : in std_logic;
    pc : in std_logic_vector(15 downto 0);
    t : in natural range 1 to 6;
    wr : out std_logic;
    addr : out std_logic_vector(23 downto 0);
    data : out std_logic_vector(15 downto 0));
end trace;

architecture arch of trace is
    component reg is generic(init : std_logic_vector;
                             size : integer); port(
        clk, rst, ce : in std_logic;
        rd : in std_logic;
        di : in std_logic_vector(size-1 downto 0);
        do : out std_logic_vector(size-1 downto 0));
    end component;

    constant LIST_BOTTOM : unsigned(23 downto 0) := x"088000";

    type trace_state_t is (idle, store);

    signal from_addr, to_addr : std_logic_vector(15 downto 0);
    signal list_ptr : unsigned(23 downto 0) := LIST_BOTTOM;
    signal to_rd : std_logic;
    signal state : trace_state_t := idle;
begin
    save_from : reg generic map(x"0000", 16)
                    port map(clk, rst, ce, jump_beg, pc, from_addr);
    save_to : reg generic map(x"0000", 16)
                  port map(clk, rst, ce, to_rd, pc, to_addr);

    process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                list_ptr <= LIST_BOTTOM;
                state <= idle;
            elsif ce = '1' then
                to_rd <= '0';
                case state is
                when idle =>
                    if jump_end = '1' then
                        state <= store;
                        to_rd <= '1';
                    end if;
                when store =>
                    case t is
                    when 1 =>
                        list_ptr <= list_ptr + 2;
                    when 3 =>
                        list_ptr <= list_ptr + 2;
                        state <= idle;
                    when others => null; end case;
                end case;
            end if;
        end if;
    end process;

    data <= (others => '0') when state = idle else
            from_addr       when t = 1 else 
            to_addr         when t = 3 else
            (others => '0');
    addr <= std_logic_vector(list_ptr);
    wr <= '1' when state = store and (t = 1 or t = 3) else '0';
end arch;
