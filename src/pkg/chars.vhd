library ieee;
use ieee.std_logic_1164.all;
use work.z80_comm.all;

package chars is
    constant CHAR_ROWS : integer := 8;
    constant CHAR_COLS : integer := 6;

    type char_t is array(0 to CHAR_ROWS-1) of
                   std_logic_vector(CHAR_COLS-1 downto 0);
                   
    constant char0 : char_t := ("000000",
                                "011100",
                                "100010",
                                "100110",
                                "101010",
                                "110010",
                                "100010",
                                "011100");
    constant char1 : char_t := ("000000",
                                "001000",
                                "011000",
                                "001000",
                                "001000",
                                "001000",
                                "001000",
                                "011100");
    constant char2 : char_t := ("000000",
                                "011100",
                                "100010",
                                "000010",
                                "000100",
                                "001000",
                                "010000",
                                "111110");
    constant char3 : char_t := ("000000",
                                "111110",
                                "000100",
                                "001000",
                                "000100",
                                "000010",
                                "100010",
                                "011100");
    constant char4 : char_t := ("000000",
                                "000100",
                                "001100",
                                "010100",
                                "100100",
                                "111110",
                                "000100",
                                "000100");
    constant char5 : char_t := ("000000",
                                "111110",
                                "100000",
                                "111100",
                                "000010",
                                "000010",
                                "100010",
                                "011100");
    constant char6 : char_t := ("000000",
                                "001100",
                                "010000",
                                "100000",
                                "111100",
                                "100010",
                                "100010",
                                "011100");
    constant charA : char_t := ("000000",
                                "011100",
                                "100010",
                                "100010",
                                "111110",
                                "100010",
                                "100010",
                                "100010");
    constant charB : char_t := ("000000",
                                "111100",
                                "100010",
                                "100010",
                                "111100",
                                "100010",
                                "100010",
                                "111100");
    constant charD : char_t := ("000000",
                                "111100",
                                "100010",
                                "100010",
                                "100010",
                                "100010",
                                "100010",
                                "111100");
end chars;
