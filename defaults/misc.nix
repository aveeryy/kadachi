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
      includes = [ den.batteries.user-aspects ];
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

        security = {
          sudo.enable = false;
          sudo-rs = {
            enable = true;
            extraConfig = "Defaults !pwfeedback";
            wheelNeedsPassword = true;
          };
        };

        system.stateVersion = stateVersion;
      };

    homeManager = {
      home.stateVersion = stateVersion;
      xdg.mimeApps.enable = true;
    };
  };
}
