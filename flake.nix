{
  description = "System configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    ags.url = "github:ozwaldorf/ags";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    autofirma-nix = {
      url = "github:nix-community/autofirma-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    catppuccin.url = "github:catppuccin/nix";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  nixConfig = {
    download-buffer-size = 524288000; # 500 MB
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        # Desktop computer
        totsugeki = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./common/nixos.nix
            ./common/nixos/theme.nix
            ./hosts/totsugeki/nixos
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.stylix.nixosModules.stylix
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
                nix.settings.extra-substituters = [
                  "https://nix-community.cachix.org"
                  "https://attic.xuyh0120.win/lantian"
                ];
                nix.settings.extra-trusted-public-keys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                ];
              }
            )
            {
              home-manager = {
                backupFileExtension = "bak";
                useUserPackages = true;
                users = {
                  avery.imports = [
                    inputs.ags.homeManagerModules.default
                    inputs.autofirma-nix.homeManagerModules.default
                    inputs.nixvim.homeModules.nixvim
                    ./common/home-manager
                    ./common/home-manager/theme.nix
                    ./hosts/totsugeki/home-manager
                  ];
                  root.imports = [
                    ./common/home-manager/theme.nix
                    { home.stateVersion = "25.11"; }
                  ];
                };

              };
            }
          ];
        };
        # Home server
        greatyamada = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./common/nixos.nix
            ./hosts/greatyamada/nixos
            ./hosts/greatyamada/services
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-minecraft.nixosModules.minecraft-servers
            inputs.catppuccin.nixosModules.catppuccin
            {
              home-manager = {
                backupFileExtension = "bak";
                useUserPackages = true;
                users.avery = {
                  imports = [
                    inputs.nixvim.homeModules.nixvim
                    ./common/home-manager
                    ./hosts/greatyamada/home-manager
                  ];
                };
              };
            }
          ];
        };
        # WSL development system
        mizuki = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/mizuki/nixos.nix
            inputs.nixos-wsl.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "bak";
                useUserPackages = true;
                users.avery = {
                  imports = [
                    inputs.nixvim.homeModules.nixvim
                    ./common/home-manager
                    ./hosts/mizuki/home.nix
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
