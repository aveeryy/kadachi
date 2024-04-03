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
  };

  outputs = { self, nixpkgs, home-manager, nixvim, sops-nix }@inputs: {
    nixosConfigurations = {
      totsugeki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common/nixos.nix
          ./hosts/totsugeki/nixos.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            home-manager.useUserPackages = true;
            home-manager.users.avery = {
              imports = [
                nixvim.homeManagerModules.nixvim
                ./common/home.nix
                ./common/zsh
                ./hosts/totsugeki/desktop
                ./hosts/totsugeki/development
              ];
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
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
