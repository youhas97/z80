library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- RSV control signals:
--  rsv res
--  000 sum
--  100 xor
--  010 and
--  111 or

-- INSTRUCTION SIGNALS (for instr decoder)
-- signal               options                     bits
-- sr                   ^reset/set                  6
-- shiftneg             none,neg,lshift,rshift      ??
-- instr                and,xor,sum,or              43

-- OPERATION SIGNALING
--  OP                  rsv sr shift op1
-- ARITH
--  add                 000    0-    op1
--  sub                 000    0-    op1
--  increment           000    0-    op1
--  decrement           000    0-    op1
--  compare             000    0-    op1
-- LOGIC
--  and                 010    0-    op1
--  or                  111    0-    op1
--  xor                 100    0-    op1
-- SHIFTS
--  lshift logic        000    10    -
--  rshift logic        000    11    -
--  lshift arith        000    10    -
--  rshift arith        000    11    -
-- BIT
--  set bit             000 1  0-    bs
--  reset bit           000 0  0-    bs
--  test bit            000    0-    bs

-- OPERATION IMPLEMENTATIONS
-- ARITH
--  add                 sum
--  sub                 op2<=-op2, sum
--  increment           op2<=1, sum
--  decrement           op2<=-1, sum
--  compare             op2<=-op2, sum (skip output)
-- LOGIC
--  and                 and
--  or                  or
--  xor                 xor
-- SHIFTS
--  lshift logic        op2<=op2<<1, op1<=0, sum
--  rshift logic        op2<=op2>>1, op1<=0, sum
--  lshift arith        op2<=op2<<1, op1<=0, sum
--  rshift arith        op2<=op2>>1, op1<=0, sum
-- BIT
--  set bit             asic
--  reset bit           asic
--  test bit            asic

-- FLAGS
-- 7  6  5  4  3  2  1  0
-- S  Z  f5 H f3 P/V N  C
-- f3: copy of bit 3
-- f5: copy of bit 5
-- S: copy of bit 7

-- SHIFTS --------

-- LEFT: c <= b7
--                instr
-- rlc: lsb <= b7 0000 0rrr
-- rl:  lsb <= c  0001 0rrr
-- sla: lsb <= 0  0010 0rrr
-- sll: lsb <= 0  0011 0rrr

-- RIGHT: c <= b0
--                instr
-- rrc: msb <= b0 0000 1rrr
-- rr:  msb <= c  0001 1rrr
-- sra: msb <= b7 0010 1rrr
-- srl: msb <= 0  0011 1rrr

-- LONG: 
-- rld: 
-- rrd:

-- INSTRUCTIONS -------

-- MAIN
--   0-7 8-f
-- 8 add adc
-- 9 sub sbc
-- a and xor
-- b or  cp

-- EXTENDED
--      1   2   4   9   a   c
-- 4-7      sbc neg     adc neg
-- a    cpi         cpd
-- b    cpir        cpdr

-- IY
--   4-5 c-d
-- 8 add adc
-- 9 sub sbc
-- a and xor
-- b or  cp

-- CB, DDCB, FDCB: BIT INSTR, IX, IY
--   0-7    8-f
-- 0 rlc    rrc
-- 1 rl     rr
-- 2 sla    sra
-- 3 sll    srl
-- 4 bit0   bit1
-- 5 bit2   bit3
-- 6 bit4   bit5
-- 7 bit6   bit6
-- 8 res0   res1
-- 9 res2   res3
-- a res4   res5
-- b res6   res6
-- c set0   set1
-- d set2   set3
-- e set4   set5
-- f set6   set6

-- INSTRUCTION SET STATES
-- name         opcode      state
-- main                     000
-- extended     ED          011
-- bit          CB          100
-- ix           DD          001
-- ix bit       DDCB        101
-- iy           FD          010
-- iy bit       FDCB        110

entity alu is port(
    clk, rst : in std_logic;
    op1, op2 : in std_logic_vector(7 downto 0);
    instr : in std_logic_vector(1 downto 0);
    carry_prev : in std_logic;
    shiftneg : in std_logic_vector(1 downto 0);
    shift : in std_logic_vector(1 downto 0);
    shift_op : in std_logic_vector(1 downto 0);
    instr : in std_logic_vector(7 downto 0);
    set : in std_logic_vector(2 downto 0);
    res, flags : out std_logic_vector(7 downto 0));
end alu;

architecture arch of alu is
    signal op1_uint, op2_uint : unsigned(7 downto 0);

    signal first, last : std_logic;
    signal op2sn : unsigned(7 downto 0);

    signal bs : std_logic_vector(2 downto 0);

    signal res_sum, res_xor, res_and, res_or : unsigned(8 downto 0);
    signal calc_res : unsigned(8 downto 0);

    signal carry, overflow : std_logic;
    signal edge : std_logic;
begin
    bs <= op1(2 downto 0);
    op1_uint <= unsigned(op1);
    op2_uint <= unsigned(op2);

    -- shift/neg
    with instr(5 downto 3) select
        edge <= op2(7) when "000", -- rlc
                c_prev when "010", -- rl
                0      when "100", -- sla
                0      when "110", -- sll
                op2(0) when "001", -- rrc
                c_prev when "011", -- rr
                op2(7) when "101", -- sra
                0      when "111", -- srl
                '-'    when others;
    shift <= bit_instr and
             (instr(3 downto 0) = "0000" or
              instr(3 downto 0) = "0001" or
              instr(3 downto 0) = "0010" or
              instr(3 downto 0) = "0011");
    pm_dir <= 
    with (shiftneg) select
        op2sn <= op2_uint                           when "00", -- no shift
                 -op2_uint                          when "01", -- negative
                        op2_uint(6 downto 0) & edge when "10", -- lshift 
                 edge & op2_uint(7 downto 1)        when "11", -- rshift
                 (others => '-')                    when others; 

    -- calculation
    process(clk) begin
        res_sum <= 0 & op1_uint +    0 & op2sn;
        res_xor <= 0 & op1_uint xor  0 & op2sn;
        res_and <= 0 & op1_uint and  0 & op2sn;
        res_or  <= 0 & op1_uint or   0 & op2sn;
    end process;
    with instr select
        calc_res <= res_and         when "00",
                    res_xor         when "01",
                    res_sum         when "10",
                    res_or          when "11",
                    (others => '-') when others;

    carry <= calc_res(8);
    overflow <= ((calc_res(7) xor op1_uint(7)) or
                 (calc_res(7) xor op2_uint(7)))
                 and not carry;

    flags(0) <= carry;
    flags(1) <= '1' when shiftneg = "01" else '0';
end arch;
