{ inputs, ... }:
{
  flake-file.inputs.nixos-wsl = {
    url = "github:nix-community/nixos-wsl";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  adachi.system._.wsl = {
    nixos = {
      imports = [ inputs.nixos-wsl.nixosModules.default ];

      wsl.enable = true;
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ wslu ];
      };
  };
}
