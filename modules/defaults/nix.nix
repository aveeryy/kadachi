{ ... }: {
  den.default = {
    nixos =
      { ... }:
      {
        nix.settings = {
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "@wheel"
          ];
        };

        nixpkgs.config.allowUnfree = true;

        programs.nh = {
          enable = true;
          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "--keep-since 14d";
          };
          flake = "/etc/nixos";
        };
      };

    homeManager = {
      nixpkgs.config.allowUnfree = true;
    };
  };
}
