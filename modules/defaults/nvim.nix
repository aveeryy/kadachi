{ lib, ... }: {
  flake-file.inputs.kadachi-nvim = {
    url = "git+https://git.rcia.dev/Avery/kadachi-nvim.git";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.default = {
    nixos =
      { inputs', ... }:
      {
        environment = {
          systemPackages = with inputs'.kadachi-nvim.packages; [
            kadachi-nvim
          ];
          variables.EDITOR = lib.mkDefault "nvim";
        };
      };
  };
}
