{
  __findFile,
  den,
  lib,
  hosts,
  ...
}:
let
  stateVersion = "26.05";
in
{
  den.schema = {
    host = { host, ... }: {
      aspect = lib.mkDefault hosts.${host.name};
    };
    user = { user, ... }: {
      classes = lib.mkDefault [ "homeManager" ];
      aspect = lib.mkDefault hosts.${user.host.name}.users.${user.userName};
    };
  };

  den.default = {
    includes = [
      <den/hostname>
      <den/define-user>
      <den/host-aspects>
      <den/mutual-provider>
      den.batteries.inputs'
      den.batteries.self'

      ({ host }: {
        nixos.environment.etc.kadachi_host.source = builtins.toFile "kadachi_host" host.name;
      })
    ];

    nixos =
      { pkgs, ... }:
      {
        console = {
          keyMap = lib.mkForce "dvorak-es";
          useXkbConfig = true;
        };

        environment.systemPackages = with pkgs; [
          git
          htop
          ncdu
        ];

        hardware.enableRedistributableFirmware = true;

        home-manager = {
          backupFileExtension = "bak";
          useUserPackages = true;
        };

        networking = {
          dhcpcd.enable = false;
          useNetworkd = true;
        };

        security = {
          pki.caCertificateBlacklist = [
            # CVE-2026-111943
            "Comodo AAA Services root"
            # https://hg-edge.mozilla.org/projects/nss/rev/26d38a0c3fb81e7fb2acedbaf4c42dd21dce0517
            "emSign ECC Root CA - G3"
            # https://hg-edge.mozilla.org/projects/nss/rev/8159223c48ceeb1273a1915bca95a517294ab0e0
            "emSign Root CA - C1"
            "emSign ECC Root CA - C3"
          ];

          sudo.enable = false;
          sudo-rs = {
            enable = true;
            extraConfig = "Defaults !pwfeedback";
            wheelNeedsPassword = true;
          };

        };

        services.resolved.settings.Resolve.DNSStubListener = false;

        system.stateVersion = stateVersion;

        systemd.network = {
          enable = true;
          wait-online = {
            enable = lib.mkDefault true;
            anyInterface = lib.mkDefault true;
          };
        };
      };

    homeManager = {
      home.stateVersion = stateVersion;
      xdg.mimeApps.enable = true;
    };
  };
}
