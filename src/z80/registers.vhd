--Register by Jakob & Yousef

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Register
entity reg is
    port(
    clk : in std_logic;
    rst : in std_logic
    
    read, write : in std_logic;
    di : in std_logic_vector(7 downto 0);
    do : out std_logic_vector(7 downto 0);
    );
    
end reg;

architecture Behavioral of reg is
    bits : unsigned(7 downto 0);
    
    process(clk) begin
        if rising_edge(clk) then
            if (rst = '1') then
                bits <= (others => '0');
            elsif (read = '1') then
                bits <= di;
            elsif (write = '1') then
                do <= bits;
            end if;
        end if;
    end process;
    
end Behavioral;
