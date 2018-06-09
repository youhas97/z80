function ld_r_r(state : id_state_t; f_in : id_frame_t;
                dst, src : std_logic_vector(4 downto 0))
return id_frame_t is variable f : id_frame_t; begin
    f := f_in;
    case state.m is
    when m1 =>
        case state.t is
        when t4 =>
            f.cw.rf_daddr := src;       -- select src reg
            f.cw.dbus_src := rf_o;      -- place regfile output on databus
            f.cw.tmp_rd := '1';         -- read from databus to tmp
        when t5 =>
            f.cw.rf_daddr := dst;       -- select dst reg
            f.cw.dbus_src := tmp_o;     -- place tmp output on databus
            f.cw.rf_rdd := '1';         -- read from databus to selected reg
            f.ct.cycle_end := '1';      -- end machine cycle
            f.ct.instr_end := '1';      -- end instr, begin with next
        when others => null; end case;
    when others => null; end case;
    return f;
end ld_r_r;
