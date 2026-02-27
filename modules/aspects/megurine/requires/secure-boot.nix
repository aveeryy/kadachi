{ inputs, ... }:
{
  flake-file.inputs.lanzaboote = {
    url = "github:nix-community/lanzaboote/v1.0.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  megurine.requires._.secure-boot = {
    nixos =
      { pkgs, lib, ... }:
      {
        imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

        boot = {
          lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
            autoGenerateKeys.enable = lib.mkDefault true;
            autoEnrollKeys = {
              enable = lib.mkDefault true;
              autoReboot = lib.mkDefault true;
            };
          };
          loader.systemd-boot.enable = lib.mkForce false;
        };

        environment.systemPackages = with pkgs; [ sbctl ];
      };
  };
}
