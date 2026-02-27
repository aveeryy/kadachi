{ ... }:
{
  kasane.services._.fail2ban.nixos.services.fail2ban = {
    enable = true;
    ignoreIP = [
      "10.0.0.0/8"
    ];
    bantime = "48h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      overalljails = true;
    };
  };
}
