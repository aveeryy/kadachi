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
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    autofirma-nix = {
      url = "github:nix-community/autofirma-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # Desktop computer
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
      # Home server
      greatyamada = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common/nixos.nix
          ./hosts/greatyamada/nixos
          ./hosts/greatyamada/services
          inputs.sops-nix.nixosModules.sops
        ];
      };
      # WSL development system
      mizuki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nixos-wsl.nixosModules.default
          ./hosts/mizuki/nixos.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "bak";
              useUserPackages = true;
              users.avery = {
                imports = [
                  inputs.nixvim.homeManagerModules.nixvim
                  ./hosts/mizuki/home.nix
                  ./common/zsh.nix
                  ./hosts/totsugeki/home-manager/development/nixvim
                  ./hosts/mizuki/development.nix
                ];
              };
            };
          }
        ];
      };
    };
  };
}
