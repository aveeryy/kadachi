{
  inputs,
  self,
  lib,
  den,
  ...
}:
{
  flake-file.inputs = {
    nixpkgs.url = lib.mkForce "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = lib.mkForce "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    den.url = lib.mkForce "github:denful/den/v0.18.0";
  };

  imports = [
    (inputs.flake-file.flakeModules.dendritic)
    (inputs.den.flakeModules.dendritic)
    (inputs.home-manager.flakeModules.home-manager)

    # Namespaces
    (inputs.den.namespace "adachi" true)
    (inputs.den.namespace "kasane" false)
    (inputs.den.namespace "megurine" true)
  ];

  _module.args.__findFile = den.lib.__findFile;

  _module.args.kadachi-lib = self.lib;

  systems = [ "x86_64-linux" ];
}
