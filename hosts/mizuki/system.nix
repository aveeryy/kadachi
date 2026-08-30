{ __findFile, ... }:
{
  den.hosts.x86_64-linux.mizuki = {
    hostName = "AIR108";
    desktop = {
      displays."HDMI-1" = {
        resolution = "3840x2160";
        scaling = 1.5;
      };
      lockSessionAtStart = true;
    };

    services.wireguard = {
      addresses = [ "10.10.1.3/16" ];
      publicKey = "MbVmCHiEXd81GmmKl6lpy559o3Peho/4I0IbbOH8qU0=";
    };

    users.avery = {
      services.syncthing.deviceId = "TCMJPPO-NAPKHXJ-4EPPVBZ-4BVC5UJ-ZWXERBO-DKEOLSM-624FO7M-ZCKXPQA";
    };
  };

  den.aspects.mizuki = {
    description = "Work computer";

    includes = [
      <megurine/is/desktop>
      <megurine/has/bluetooth>
      <megurine/has/intel-cpu>
      <megurine/has/intel-cpu/kvm>
      <megurine/requires/secure-boot>

      <adachi/desktop/hyprland>

      <adachi/services/podman>
      <kasane/services/wireguard>
    ];

    nixos =
      { pkgs, ... }:
      {
        boot.kernel.sysctl."vm.overcommit_memory" = 1;

        i18n = {
          defaultLocale = "es_ES.UTF-8";
          supportedLocales = [
            "C.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
            "es_ES.UTF-8/UTF-8"
          ];
        };

        systemd.network.networks."10-wan" = {
          matchConfig.Name = ""; # TODO: set real interface name
          networkConfig.DHCP = "ipv4";
          linkConfig.RequiredForOnline = "routable";
          # DNS is managed by dnsmasq
          dhcpV4Config.UseDNS = false;
          dhcpV6Config.UseDNS = false;
        };

        time.timeZone = "Europe/Madrid";
      };
  };
}
