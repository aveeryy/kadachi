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
      aspect = lib.mkDefault den.aspects."${user.userName}@${user.host.hostName}";
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

        networking.dhcpcd.wait = "background";

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
