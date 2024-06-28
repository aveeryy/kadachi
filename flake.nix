{
  description = "System configurations";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url =
      "github:nixos/nixpkgs/b17538d34de26bf52626a9caff104a267abd991a";
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

  outputs =
    { self, nixpkgs, home-manager, nixvim, sops-nix, plasma-manager }@inputs: {
      nixosConfigurations = {
        totsugeki = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common/nixos.nix
            ./hosts/totsugeki/nixos
            ./hosts/greatyamada/services/minecraft
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "bak";
                useUserPackages = true;
                users.avery = {
                  imports = [
                    nixvim.homeManagerModules.nixvim
                    plasma-manager.homeManagerModules.plasma-manager
                    ./common/home.nix
                    ./common/zsh
                    ./hosts/totsugeki/home-manager
                  ];
                };
              };
            }
          ];
          specialArgs = { inherit inputs; };
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
