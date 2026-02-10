{ inputs, ... }:
{
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
      systems.follows = "systems";
    };
  };

  adachi.neovim = {
    description = "Modular Neovim configuration";
    homeManager.imports = [ inputs.nixvim.homeModules.nixvim ];
  };
}
