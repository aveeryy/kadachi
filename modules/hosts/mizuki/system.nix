{ __findFile, ... }:
{
  den.hosts.x86_64-linux.mizuki = {
    users.avery.aspect = "avery_mizuki";
    wsl = true;
  };

  den.aspects.mizuki = {
    includes = [
      <adachi/system/auto-hostname>
      <adachi/system/wsl>
    ];
    nixos = {
      time.timeZone = "Europe/Madrid";
      virtualisation.docker.enable = true;
    };
  };
}
