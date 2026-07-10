{ inputs, ... }: {
  flake-file.inputs = {
    secrets = {
      url = "git+ssh://forgejo@git.rcia.dev:2222/Avery/kadachi-secrets.git";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.default.nixos =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      environment.systemPackages = with pkgs; [ sops ];

      sops = {
        defaultSopsFile = "${inputs.secrets}/${config.networking.hostname}.yaml";
        validateSopsFiles = false;
      };
    };
}
