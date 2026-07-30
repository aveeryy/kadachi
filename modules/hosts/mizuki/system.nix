{ __findFile, ... }:
{
  den.hosts.x86_64-linux.mizuki = {
    services.wireguard = {
      peerEnabled = true;
      addresses = [ "10.10.0.3/16" ];
      publicKey = "MbVmCHiEXd81GmmKl6lpy559o3Peho/4I0IbbOH8qU0=";
    };
    users.avery = {
      services.syncthing.deviceId = "TCMJPPO-NAPKHXJ-4EPPVBZ-4BVC5UJ-ZWXERBO-DKEOLSM-624FO7M-ZCKXPQA";
    };
  };

  den.aspects.mizuki = {
    includes = [
      <adachi/services/podman>
      <kasane/services/wireguard>
      <megurine/is/wsl>
    ];

    nixos =
      { pkgs, ... }:
      {
        boot.kernel.sysctl."vm.overcommit_memory" = 1;
        time.timeZone = "Europe/Madrid";
      };
  };
}
