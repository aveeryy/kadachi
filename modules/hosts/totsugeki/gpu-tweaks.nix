{ ... }: {
  den.aspects.totsugeki.nixos = {
    hardware.amdgpu.overdrive.enable = true;
    services.lact = {
      enable = true;
      settings = {
        version = 6;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        current_profile = null;
        auto_switch_profiles = false;
        gpus."1002:73DF-1DA2:E445-0000:08:00.0" = {
          max_core_clock = 2800;
          max_memory_clock = 1000;
          voltage_offset = -80;
          power_cap = 213.0;
          performance_level = "auto";
          fan_control_enabled = false;
        };
      };
    };
  };
}
