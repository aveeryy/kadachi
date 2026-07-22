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

    shellAliases = {
      "rbd" = ''nh os switch "path:/etc/nixos#$(hostname)"'';
      "rbdb" = ''nh os boot "path:/etc/nixos#$(hostname)"'';
      "rbd-remote" = ''nh os switch "git+https://git.rcia.dev/Avery/kadachi#$(hostname)"'';
      "rbdb-remote" = ''nh os boot "git+https://git.rcia.dev/Avery/kadachi#$(hostname)"'';
      "print-nix-store-gc-roots" =
        ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"'';
    };
  };
}
