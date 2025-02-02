{
  description = "System configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      # url = "github:Aylur/ags";
      url = "github:aveeryy/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    autofirma-nix = {
      url = "github:nix-community/autofirma-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://autofirma-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "autofirma-nix.cachix.org-1:cDC9Dtee+HJ7QZcM8s36836scXyRToqNX/T+yvjiI0E="
    ];
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      totsugeki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common/nixos.nix
          ./hosts/totsugeki/nixos
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote
          {
            home-manager = {
              backupFileExtension = "bak";
              useUserPackages = true;
              users.avery = {
                imports = [
                  inputs.ags.homeManagerModules.default
                  inputs.autofirma-nix.homeManagerModules.default
                  inputs.nixvim.homeManagerModules.nixvim
                  ./common/home.nix
                  ./common/zsh.nix
                  ./hosts/totsugeki/home-manager
                ];
              };
            };
          }
        ];
      };
      greatyamada = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common/nixos.nix
          ./hosts/greatyamada/nixos.nix
          ./hosts/greatyamada/services
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
