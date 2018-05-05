library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_motor is port ( 
     clk, ce : in std_logic;
	 data : in std_logic;
	 rst : in std_logic;
     x : out std_logic_vector(6 downto 0);
     y : out std_logic_vector(5 downto 0);
	 vgaRed	: out std_logic_vector(2 downto 0);
	 vgaGreen : out std_logic_vector(2 downto 0);
	 vgaBlue : out std_logic_vector(2 downto 1);
	 Hsync : out std_logic;
	 Vsync : out std_logic);
end vga_motor;

architecture Behavioral of vga_motor is
    component cntr generic(bitwidth : integer); port(
        clk, rst, ce : in std_logic;
        cnten : in std_logic;
        ld : in std_logic;
        di : in unsigned(bitwidth-1 downto 0);
        do : out unsigned(bitwidth-1 downto 0));
    end component;

    constant VGA_VIS_X : integer := 640;
    constant VGA_VIS_Y : integer := 480;
    constant VGA_X : integer := 800;
    constant VGA_y : integer := 521;
    constant LCD_VIS_X : integer := 96;
    constant LCD_VIS_Y : integer := 64;
    constant PIXEL_SIZE : integer := 6;

    signal x_ld, xp_ld : std_logic;
    signal x_vga : unsigned(9 downto 0);
    signal xp : unsigned(2 downto 0);
    signal x_lcd : unsigned(6 downto 0);

    signal y_ld, yp_ld : std_logic;
    signal y_vga : unsigned(8 downto 0);
    signal yp : unsigned(2 downto 0);
    signal y_lcd : unsigned(5 downto 0);

    signal colour : std_logic_vector(7 downto 0);	
    signal blank : std_logic;
begin
    -- vga pixel counters
    x_ld <= '1' when x_vga = to_unsigned(VGA_X-1, x_vga'length) else '0';
    xv_cntr : cntr generic map(x_vga'length)
                   port map(clk, rst, ce, '1', x_ld,
                            to_unsigned(0, x_vga'length), x_vga);
    y_ld <= '1' when y_vga = to_unsigned(VGA_Y-1, y_vga'length) else '0';
    yv_cntr : cntr generic map(y_vga'length)
                   port map(clk, rst, ce, x_ld, y_ld,
                            to_unsigned(0, y_vga'length), y_vga);

    -- vga on lcd pixel
    xp_ld <= '1' when xp = to_unsigned(PIXEL_SIZE-1, xp'length) else '0';
    xp_cntr : cntr generic map(xp'length)
                   port map(clk, rst, ce, '1', xp_ld,
                            to_unsigned(0, xp'length), xp);
    yp_ld <= '1' when yp = to_unsigned(PIXEL_SIZE-1, yp'length) else '0';
    yp_cntr : cntr generic map(yp'length)
                   port map(clk, rst, ce, x_ld, yp_ld,
                            to_unsigned(0, yp'length), yp);
    -- lcd pixels
    xl_cntr : cntr generic map(x_lcd'length)
                   port map(clk, rst, ce, xp_ld, x_ld,
                            to_unsigned(0, x_lcd'length), x_lcd);
    yl_cntr : cntr generic map(y_lcd'length)
                   port map(clk, rst, ce, yp_ld, y_ld,
                            to_unsigned(0, y_lcd'length), y_lcd);

    Hsync <= '0' when x_vga > 656 and x_vga <= 752 else
             '1';
    Vsync <= '0' when y_vga > 490 and y_vga <= 492 else
             '1';
    blank <= '1' when x_vga >= VGA_VIS_X or y_vga >= VGA_VIS_Y else '0';
    colour <= x"00" when blank = '1' else
              x"00" when x_vga >= LCD_VIS_X*PIXEL_SIZE or
                         y_vga >= LCD_VIS_Y*PIXEL_SIZE else
              x"ff" when data = '1' else
              -- 010 010 00_
              x"48" when data = '0' else
              (others => '-');
  
    x <= std_logic_vector(x_lcd);
    y <= std_logic_vector(y_lcd);

    vgaRed 	    <= colour(7 downto 5);
    vgaGreen    <= colour(4 downto 2);
    vgaBlue 	<= colour(1 downto 0);
end Behavioral;
