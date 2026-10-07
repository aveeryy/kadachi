{ lib, ... }:
let
  inherit (lib)
    mkDefault
    ;
in
{
  megurine.is._.server.nixos = {
    boot.loader = {
      grub.configurationLimit = mkDefault 5;
      systemd-boot.configurationLimit = mkDefault 5;
    };

    environment.variables.BROWSER = "echo";

    fonts.fontconfig.enable = mkDefault false;

    networking.useDHCP = mkDefault false;

    security.acme = {
      acceptTerms = true;
      defaults = {
        profile = mkDefault "shortlived";
        group = mkDefault "nginx";
        webroot = mkDefault null;
        extraLegoFlags = mkDefault [
          "--dns.propagation.wait=300s"
        ];
      };
    };

    time.timeZone = mkDefault "UTC";

    users.mutableUsers = false;

    xdg = {
      autostart.enable = mkDefault false;
      icons.enable = mkDefault false;
      menus.enable = mkDefault false;
      mime.enable = mkDefault false;
      sounds.enable = mkDefault false;
    };
  };
}
