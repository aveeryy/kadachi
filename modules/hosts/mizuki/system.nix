{ __findFile, ... }:
{
  den.hosts.x86_64-linux.mizuki.users.avery.aspect = "avery_mizuki";

  den.aspects.mizuki = {
    includes = [ <megurine/is/wsl> ];

    nixos = {
      time.timeZone = "Europe/Madrid";
      virtualisation.docker.enable = true;
    };
  };
}
