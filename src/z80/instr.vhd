library IEEE;
use ieee.std_logic_1164.all;
use work.z80_comm.all;

package z80_instr is
    -- control signals for id, modified combinationally by instructions
    type id_ctrl_t is record
        set_end : std_logic;        -- last state of current set
        cycle_end : std_logic;      -- last state of current cycle
        instr_end : std_logic;      -- last state of current instr
        overlap : std_logic;        -- fetch during this cycle while exec
        multi_word : std_logic;     -- fetch next word of multi-word instr
        jump : std_logic;           -- use wz when fetching on next cycle
    end record;

    -- current state of cpu, modified synchronously
    type id_state_t is record
        set : instr_set_t;
        m : integer;
        t : integer;
        overlap, multi_word, jump_cycle : std_logic;
    end record;

    -- container for signals so a function can be used (f as return value)
    type id_frame_t is record
        ct : id_ctrl_t;
        cb : ctrlbus_out;
        cw : ctrlword;
    end record;

    type id_split_t is record x, y, z, p, q : integer; end record;

    -- t1: abus:addr -> t3: dbus:data
    procedure fetch(signal state : in id_state_t;
                    variable f : out id_frame_t);
    -- -> t3: dbus:data, pc++
    procedure fetch_pc(signal state : in id_state_t;
                       variable f : out id_frame_t);
    procedure fetch_multi(signal state : in id_state_t;
                          variable f : out id_frame_t);
    -- INSTRUCTIONS
    procedure nop(signal state : in id_state_t;
                  variable f : out id_frame_t);
    procedure jp_nn(signal state : in id_state_t;
                    variable f : out id_frame_t);
    procedure ex_af(signal state : in id_state_t;
                    variable f : out id_frame_t);
    procedure alu_a_r(signal state : in id_state_t;
                      variable f : out id_frame_t;
                      constant op : in instr_t;
                      signal reg : in integer);
    procedure bit_r(signal state : in id_state_t;
                    variable f : out id_frame_t;
                    constant op : in instr_t;
                    bs : in integer;
                    signal reg : in integer);
    procedure ld_r_r(signal state : in id_state_t;
                     variable f : out id_frame_t;
                     signal src, dst : in integer);
end z80_instr;

package body z80_instr is
    procedure fetch(signal state : in id_state_t;
                    variable f : out id_frame_t)
    is begin
        case state.t is
        when t1 =>
            f.cw.addr_rd := '1';    -- read from abus to buffer
            f.cw.addr_wr := '1';    -- write from buffer to outside abus
            f.cb.mreq := '1';       -- signal addr is ready on abus
            f.cb.rd := '1';         -- request reading from memory
        when t2 =>
            f.cw.addr_wr := '1';    -- keep writing addr to mem
            f.cw.data_rdi := '1';   -- store instr to data buf
            f.cb.mreq := '1';       -- keep request until byte retrieved
            f.cb.rd := '1';         -- keep reading
        when t3 =>
            f.cw.data_wri := '1';   -- write instr to inner dbus from buf
        when others => null; end case;
    end fetch;

    procedure fetch_pc(signal state : in id_state_t;
                       variable f : out id_frame_t)
    is begin
        fetch(state, f);
        case state.t is
        when t1 =>
            f.cw.pc_wr := '1';
        when t2 =>
            f.cw.pc_wr := '1';
            f.cw.pc_rd := '1';
        when t3 =>
        when others => null; end case;
    end fetch_pc;

    procedure fetch_multi(
        signal state : in id_state_t;
        variable f : out id_frame_t)
    is begin
        f.ct.multi_word := '1';
        case state.m is
        when m1 =>
            case state.t is
            when t4 =>
                f.ct.cycle_end := '1';
            when others => null; end case;
        when others =>
            case state.t is
            when t3 =>
                f.ct.set_end := '1';
                f.ct.cycle_end := '1';
            when others => null; end case;
        end case;
    end fetch_multi;

    procedure nop(
        signal state : in id_state_t;
        variable f : out id_frame_t)
    is begin
        case state.t is
        when t4 =>
            f.ct.cycle_end := '1';
            f.ct.instr_end := '1';
        when others => null; end case;
    end nop;

    procedure jp_nn(
        signal state : in id_state_t;
        variable f : out id_frame_t)
    is begin
        case state.m is
        when m1 =>
            case state.t is
            when t4 =>
                f.ct.cycle_end := '1';
            when others => null; end case;
        when m2 =>
            fetch_pc(state, f);
            case state.t is
            when t3 =>
                f.cw.rf_addr := regZ;
                f.cw.rf_rdd := '1';
                f.ct.cycle_end := '1';
            when others => null; end case;
        when m3 =>
            fetch_pc(state, f);
            case state.t is
            when t3 =>
                f.cw.rf_addr := regW;
                f.ct.cycle_end := '1';
                f.ct.jump := '1';
                f.ct.instr_end := '1';
            when others => null; end case;
        when others => null; end case;
    end jp_nn;

    procedure ex_af(
        signal state : in id_state_t;
        variable f : out id_frame_t)
    is begin
        case state.m is
        when m1 =>
            case state.t is
            when t4 =>
                f.cw.rf_swp := af;
                f.ct.cycle_end := '1';
                f.ct.instr_end := '1';
            when others => null; end case;
        when others => null; end case;
    end ex_af;

    procedure alu_a_r(
        signal state : in id_state_t;
        variable f : out id_frame_t;
        constant op : in instr_t;
        signal reg : in integer)
    is begin
        case state.m is
        when m1 =>
            case state.t is
            when t4 =>
                f.cw.act_rd := '1';     -- read from a to tmp accumulator
                f.cw.rf_addr := reg;    -- select reg
                f.cw.rf_wrd := '1';     -- place reg on dbus
                f.cw.tmp_rd := '1';     -- read from dbus to tmp
                f.ct.cycle_end := '1';  -- signal new cycle
            when others => null; end case;
        when m2 =>
            f.ct.overlap := '1';        -- fetch next instr simultaneously
            case state.t is
            when t2 =>
                f.cw.alu_op := op;      -- tell alu operation
                f.cw.alu_wr := '1';     -- place result on dbus
                f.cw.f_rd := '1';       -- read flags from alu
                f.cw.rf_addr := regA;   -- select the A reg
                f.cw.rf_rdd := '1';     -- read alu output from dbus
                f.ct.instr_end := '1';  -- signal instr is done
            when others => null; end case;
        when others => null; end case;
    end alu_a_r;

    procedure bit_r(signal state : in id_state_t;
                    variable f : out id_frame_t;
                    constant op : in instr_t;
                    bs : in integer;
                    signal reg : in integer)
    is begin
        case state.m is 
        when m2 =>
            case state.t is
            when t4 =>
                f.cw.rf_addr := reg;
                f.cw.rf_wrd := '1';
                f.cw.tmp_rd := '1';
                f.ct.cycle_end := '1';
            when others => null; end case;
        when m3 =>
            f.ct.overlap := '1';
            case state.t is
            when t2 =>
                f.cw.alu_op := op;
                f.cw.alu_bs := bs;
                f.cw.alu_wr := '1';
                f.cw.f_rd := '1';
                f.cw.rf_addr := reg;
                f.cw.rf_rdd := '1';
                f.ct.instr_end := '1';
            when others => null; end case;
        when others => null; end case;
    end bit_r;

    procedure ld_r_r(signal state : in id_state_t;
                     variable f : out id_frame_t;
                     signal src, dst : in integer)
    is begin
        case state.m is
        when m1 =>
            case state.t is
            when t4 =>
                f.cw.rf_addr := src;
                f.cw.rf_wrd := '1';
                f.cw.tmp_rd := '1';
            when t5 =>
                f.cw.rf_addr := dst;
                f.cw.tmp_wr := '1';
                f.cw.rf_rdd := '1';
                f.ct.instr_end := '1';
                f.ct.cycle_end := '1';
            when others => null; end case;
        when others => null; end case;
    end ld_r_r;
end z80_instr;
