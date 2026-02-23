{ lib, ... }:
{
  megurine.is._.server.nixos = {
    boot.loader = {
      grub.configurationLimit = lib.mkDefault 5;
      systemd-boot.configurationLimit = lib.mkDefault 5;
    };

    environment.variables.BROWSER = "echo";

    fonts.fontconfig.enable = lib.mkDefault false;

    time.timeZone = lib.mkDefault "UTC";

    users.mutableUsers = false;

    xdg = {
      autostart.enable = lib.mkDefault false;
      icons.enable = lib.mkDefault false;
      menus.enable = lib.mkDefault false;
      mime.enable = lib.mkDefault false;
      sounds.enable = lib.mkDefault false;
    };
  };
}
