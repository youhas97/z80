library ieee;
use ieee.std_logic_1164.all;

package z80_comm is
    function bool_sl(b : boolean) return std_logic;
    type instr_t is (unknown, 
                     add_i, adc_i, sub_i, sbc_i, cp_i, inc_i, dec_i, neg_i,
                     and_i, or_i, xor_i,
                     bit_i, res_i, set_i,
                     rlc_i, rl_i, sla_i, sll_i,
                     rrc_i, rr_i, sra_i, srl_i,
                     daa_i, cpl_i, scf_i, ccf_i,
                     in_i, rld1_i, rld2_i, rrd1_i, rrd2_i);
    type rf_swap_t is (none, af, reg, dehl);
    type addr_op_t is (inc, none, dec);
    type cond_t is array(0 to 7) of boolean;

    type id_mode_t is (
        main, ed, cb, dd, ddcb, fd, fdcb, -- exec prefixes
        wz,                               -- use wz instead of pc on fetch
        halt                              -- halted
    );

    -- control signals for id
    type id_ctrl_t is record
        cycle_end : std_logic;      -- last state of current cycle
        instr_end : std_logic;      -- last state of current instr
        mode_next : id_mode_t;      -- mode for next cp
    end record;

    -- current state/context of cpu
    type state_t is record
        mode : id_mode_t;
        cc : cond_t;
        m : integer range 1 to 6;
        t : integer range 1 to 6;
    end record;

    type ctrlbus_in is record
        -- cpu control
        wt, int, nmi, reset : std_logic;
        -- cpu bus control
        busrq : std_logic;
    end record;

    type ctrlbus_out is record
        -- system control
        m1, mreq, iorq, rd, wr, rfsh : std_logic;
        -- cpu control
        halt : std_logic;
        -- cpu bus control
        busack : std_logic;
    end record;

    type dbus_src_t is (ext_o, rf_o, tmp_o, alu_o);
    type abus_src_t is (pc_o, rf_o, tmpa_o, dis_o);

    type ctrlword is record 
        -- buses / registers
        dbus_src : dbus_src_t;
        abus_src : abus_src_t;
        rf_addr : integer range 0 to 15;
        rf_rdd, rf_rda : std_logic;
        rf_swp : rf_swap_t;
        f_rd : std_logic;
        ir_rd : std_logic;
        tmpa_rd : std_logic;
        pc_rd : std_logic;
        pc_dis : std_logic;
        addr_op : addr_op_t;
        -- alu
        alu_op : instr_t;
        alu_bs : integer range 0 to 7;
        act_rd : std_logic;
        tmp_rd : std_logic;
        -- buffers
        data_rdi, data_rdo, data_wro : std_logic;
        addr_rd, addr_wr : std_logic;
    end record;

    -- flags
    constant  C_f : integer := 0;   -- carry
    constant  N_f : integer := 1;   -- subtract instr
    constant PV_f : integer := 2;   -- parity/overflow
    constant f3_f : integer := 3;   -- copy of bit 3
    constant  H_f : integer := 4;   -- half carry
    constant f5_f : integer := 5;   -- copy of bit 5
    constant  Z_f : integer := 6;   -- zero
    constant  S_f : integer := 7;   -- sign

    -- conditions
    constant NZ_c : integer := 0;   -- non-zero
    constant  Z_c : integer := 1;   -- zero
    constant NC_c : integer := 2;   -- no carry
    constant  C_c : integer := 3;   -- carry
    constant PO_c : integer := 4;   -- parity odd
    constant PE_c : integer := 5;   -- parity even
    constant  P_c : integer := 6;   -- sign positive
    constant  M_c : integer := 7;   -- sign negative

    -- machine states
    constant m1 : integer := 1;
    constant m2 : integer := 2;
    constant m3 : integer := 3;
    constant m4 : integer := 4;
    constant m5 : integer := 5;
    constant m6 : integer := 6;
    constant t1 : integer := 1;
    constant t2 : integer := 2;
    constant t3 : integer := 3;
    constant t4 : integer := 4;
    constant t5 : integer := 5;
    constant t6 : integer := 6;

    -- reg16
    constant regBC : integer := 0;
    constant regDE : integer := 2;
    constant regHL : integer := 4;
    constant regAF : integer := 6;
    constant regWZ : integer := 8;
    constant regSP : integer := 10;
    constant regIX : integer := 12;
    constant regIY : integer := 14;
    -- reg8
    constant regB   : integer := 0;
    constant regC   : integer := 1;
    constant regD   : integer := 2;
    constant regE   : integer := 3;
    constant regH   : integer := 4;
    constant regL   : integer := 5;
    constant regF   : integer := 6;
    constant regA   : integer := 7;
    constant regW   : integer := 8;
    constant regZ   : integer := 9;
    constant regSPh : integer := 10;
    constant regSPl : integer := 11;
    constant regIXh : integer := 12;
    constant regIXl : integer := 13;
    constant regIYh : integer := 14;
    constant regIYl : integer := 15;

    type dbg_regs_t is record
        BC, DE, HL, AF, WZ, SP, IX, IY : std_logic_vector(15 downto 0);
    end record;
    type dbg_z80_t is record
        regs : dbg_regs_t;
        state : state_t;
        ct : id_ctrl_t;
        cw : ctrlword;
        pc, abus : std_logic_vector(15 downto 0);
        ir, tmp, act, dbus : std_logic_vector(7 downto 0);
    end record;
end z80_comm;

package body z80_comm is
    function bool_sl(b : boolean) return std_logic is 
    begin
        if b then
            return '1';
        else
            return '0';
        end if;
    end bool_sl;
end z80_comm;