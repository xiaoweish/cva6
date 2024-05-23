import "DPI-C" function void spike_set_param_uint64_t(string base, string name, longint unsigned value);
import "DPI-C" function void spike_set_param_str(string base, string name, string value);
import "DPI-C" function void spike_set_param_bool(string base, string name, bit value);
import "DPI-C" function void spike_set_default_params(string profile);

function st_core_cntrl_cfg cva6pkg_to_core_cntrl_cfg(st_core_cntrl_cfg cfg);

    automatic config_pkg::cva6_cfg_t CVA6Cfg = build_config_pkg::build_config(cva6_config_pkg::cva6_cfg);
    string base;

    $cast(cfg.xlen, CVA6Cfg.XLEN);

    cfg.ilen = 32;

    cfg.marchid = ariane_pkg::ARIANE_MARCHID;
    cfg.mvendorid = ariane_pkg::OPENHWGROUP_MVENDORID;

    cfg.ext_i_supported = 1;
    cfg.ext_a_supported = CVA6Cfg.RVA;
    cfg.ext_m_supported = 1;
    cfg.ext_c_supported = CVA6Cfg.RVC;
    cfg.ext_p_supported = 1;
    cfg.ext_v_supported = CVA6Cfg.RVV;
    cfg.ext_f_supported = CVA6Cfg.RVF;
    cfg.ext_d_supported = CVA6Cfg.RVD;
    cfg.ext_zba_supported = CVA6Cfg.RVB;
    cfg.ext_zbb_supported = CVA6Cfg.RVB;
    cfg.ext_zbc_supported = CVA6Cfg.RVB;
    cfg.ext_zbe_supported = CVA6Cfg.RVB;
    cfg.ext_zbf_supported = 0;
    cfg.ext_zbm_supported = 0;
    cfg.ext_zbp_supported = 0;
    cfg.ext_zbr_supported = 0;
    cfg.ext_zbs_supported = CVA6Cfg.RVB;
    cfg.ext_zbt_supported = 0;
    cfg.ext_zcb_supported = CVA6Cfg.RVZCB;
    cfg.ext_zifencei_supported = 1;
    cfg.ext_zicsr_supported = 1;
    cfg.ext_zicntr_supported = 1;

    cfg.ext_cv32a60x_supported = 1;

    cfg.mode_s_supported = CVA6Cfg.RVS;
    cfg.mode_u_supported = CVA6Cfg.RVU;

    cfg.pmp_supported = (CVA6Cfg.NrPMPEntries > 0);
    cfg.pmp_regions = CVA6Cfg.NrPMPEntries;
    cfg.debug_supported = CVA6Cfg.DebugEn;

    cfg.disable_all_csr_checks = 0;

    cfg.unsupported_csr_mask['h643] = 1; // HTVAL
    cfg.unsupported_csr_mask['h64A] = 1; // HTINST

    // Disable comparison
    cfg.unsupported_csr_mask['h7C0] = 1; // ICACHE
    cfg.unsupported_csr_mask['h7C1] = 1; // DCACHE

    // MHPMEVENT
    for (int unsigned i = 32'h323; i < 32'h33F; i++)
      cfg.unsupported_csr_mask[i] = 1;

    base = $sformatf("/top/core/%0d/", cfg.mhartid);

    void'(spike_set_param_bool(base, "hide_csrs_based_on_priv", 1));
    void'(spike_set_param_uint64_t(base, "mtvec_vectored_alignment", 64 * 4));
    void'(spike_set_param_str(base, "extensions", "cv32a60x"));

    void'(spike_set_param_bool(base, "status_xs_field_we_enable", 1'b1));
    void'(spike_set_param_bool(base, "status_xs_field_we", 1'b0));
    void'(spike_set_param_uint64_t(base, "misa_override_value", get_misa(cfg)));
    void'(spike_set_param_uint64_t(base, "misa_override_mask", 64'h0FFF_FFFF));

    return cfg;

endfunction : cva6pkg_to_core_cntrl_cfg

