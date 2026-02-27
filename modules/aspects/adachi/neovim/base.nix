{
  inputs,
  den,
  lib,
  ...
}:
{
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
      systems.follows = "systems";
    };
  };

  adachi.neovim =
    let
      neovimClass =
        { class, aspect-chain }:
        den._.forward {
          each = lib.singleton true;
          fromClass = _: "neovim";
          intoClass = _: "homeManager";
          intoPath = _: [
            "programs"
            "nixvim"
          ];
          fromAspect = _: lib.head aspect-chain;
        };
    in
    {
      description = "Modular Neovim configuration";

      includes = [ neovimClass ];

      homeManager.imports = [ inputs.nixvim.homeModules.nixvim ];
    };
}
