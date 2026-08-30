{
  __findFile,
  den,
  lib,
  ...
}:
let
  stateVersion = "26.05";
in
{
  den.schema.user =
    { user, ... }:
    {
      classes = lib.mkDefault [ "homeManager" ];
      aspect = lib.mkDefault den.aspects."${user.userName}@${user.host.name}";
    };

  den.default = {
    includes = [
      <den/hostname>
      <den/define-user>
      <den/host-aspects>
      <den/mutual-provider>
      den.batteries.inputs'
      den.batteries.self'
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
