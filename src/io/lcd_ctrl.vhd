library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cmp_comm.all;

-- TODO / MISSING
--  - power on/off
--  - rowshift (z register/counter)
--  - contrast

entity lcd_ctrl is port(
    clk, rst : in std_logic;
    gmem_data_o : in std_logic_vector(7 downto 0);
    gmem_data_i : out std_logic_vector(7 downto 0);
    gmem_x : out std_logic_vector(5 downto 0);
    gmem_y : out std_logic_vector(4 downto 0);
    gmem_rst, gmem_rd, gmem_wl : out std_logic;
    status_o, data_o : in port_out_t;
    status_i, data_i : out port_in_t);
end lcd_ctrl;

architecture arch of lcd_ctrl is
    type lcd_mode_t is record
        inc : std_logic_vector(1 downto 0); -- counter & up/down
        active : std_logic;
        wl : std_logic; -- 0: 6bit, 1: 8bit
        busy : std_logic;
    end record;

    signal mode, mode_next : lcd_mode_t;
    signal x, x_next : integer range 0 to LCD_ROWS-1; -- row
    signal y, y_next : integer range 0 to LCD_COLS/6-1; -- column page
begin
    gmem_data_i <= data_o.data;
    gmem_x <= std_logic_vector(to_unsigned(x, gmem_x'length));
    gmem_y <= std_logic_vector(to_unsigned(y, gmem_y'length));
    gmem_rst <= rst;
    gmem_rd <= '1' when data_o.wr = '1' else '0';
    gmem_wl <= mode.wl;

    data_i <= (gmem_data_o, '0');
    status_i <= (mode.busy & mode.wl & mode.active & "0--" & mode.inc, '0');

    update : process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                mode <= (inc => "00", others => '0');
                x <= 0; y <= 0;
            else
                mode <= mode_next;
                x <= x_next; y <= y_next;
            end if;
        end if;
    end process;

    next_mode : process(status_o.data, status_o.wr, mode)
        variable m : lcd_mode_t;
    begin
        m := mode;
        if status_o.wr = '1' then
            case status_o.data is
            when x"00"|x"01" => m.wl := status_o.data(0);
            when x"02"|x"03" => m.active := status_o.data(1);
            when x"04"|x"05"|x"06"|x"07" =>
                m.inc := status_o.data(1 downto 0);
            when others => null; end case;
        end if;
        mode_next <= m;
    end process;

    next_ptr : process(data_o.rd, data_o.wr, status_o.wr,
                       status_o.data, mode, x, y)
        variable x_tmp, y_tmp : integer;
    begin
        x_tmp := x; y_tmp := y;
        if data_o.rd = '1' or data_o.wr = '1' then
            -- inc/dec
            case mode.inc is
            when "00" => x_tmp := x - 1;
            when "01" => x_tmp := x + 1;
            when "10" => y_tmp := y - 1;
            when "11" => y_tmp := y + 1;
            when others => null; end case;
            -- limit
            if mode.wl = '1' then
                if y_tmp > LCD_COLS/8-1 then y_tmp := 0;            end if;
                if y_tmp < 0            then y_tmp := LCD_COLS/8-1; end if;
                if x_tmp > LCD_ROWS-1   then x_tmp := 0;            end if;
                if x_tmp < 0            then x_tmp := LCD_ROWS-1;   end if;
            else
                if y_tmp > LCD_COLS/6-1 then y_tmp := 0;            end if;
                if y_tmp < 0            then y_tmp := LCD_COLS/6-1; end if;
                if x_tmp > LCD_ROWS-1   then x_tmp := 0;            end if;
                if x_tmp < 0            then x_tmp := LCD_ROWS-1;   end if;
            end if;
        elsif status_o.wr = '1' then
            if status_o.data(7 downto 5) = "001" then
                x_tmp := to_integer(unsigned(status_o.data(4 downto 0)));
            elsif status_o.data(7 downto 6) = "10" then
                y_tmp := to_integer(unsigned(status_o.data(5 downto 0)));
            end if;
        end if;
        x_next <= x_tmp; y_next <= y_tmp;
    end process;
end arch;
