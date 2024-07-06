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
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          {
            home-manager = {
              backupFileExtension = "bak";
              useUserPackages = true;
              users.avery = {
                imports = [
                  inputs.nixvim.homeManagerModules.nixvim
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                  ./common/home.nix
                  ./common/zsh
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
