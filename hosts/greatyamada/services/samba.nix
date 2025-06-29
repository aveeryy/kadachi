{ ... }: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "invalid users" = [ "root" ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
      };
      "PS2" = {
        path = "/mnt/hdd-01/PS2";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        comment = "PS2 game share";
      };
    };
  };
}
