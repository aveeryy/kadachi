{
  __findFile,
  inputs,
  self,
  ...
}:
let
  stateVersion = "25.11";
in
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.default = {
    includes = [
      <den/define-user>
      <den/home-manager>
    ];

    nixos =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];
        console = {
          keyMap = lib.mkForce "dvorak-es";
          useXkbConfig = true;
        };
        environment.systemPackages = with pkgs; [
          git
          htop
          neovim
          sops
          ncdu
        ];
        hardware.enableRedistributableFirmware = true;
        home-manager.backupFileExtension = "bak";
        nix = {
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
          };
          settings = {
            auto-optimise-store = true;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            trusted-users = [
              "root"
              "@wheel"
            ];
          };
        };
        nixpkgs = {
          config = {
            allowUnfree = true;
          };
          overlays = [ self.overlays.default ];
        };
        sops = {
          defaultSopsFile =
            if (builtins.pathExists "${self}/secrets/${config.networking.hostName}.yaml") then
              "${self}/secrets/${config.networking.hostName}.yaml"
            else
              "${self}/secrets/common.yaml";
          secrets.avery_password = {
            sopsFile = "${self}/secrets/common.yaml";
            owner = "root";
            neededForUsers = true;
          };
          validateSopsFiles = false;
        };
        security = {
          sudo.enable = false;
          sudo-rs = {
            enable = true;
            wheelNeedsPassword = true;
          };
        };
        services = {
          openssh = {
            enable = true;
            settings = {
              X11Forwarding = false;
              PermitRootLogin = "no";
            };
          };
        };
        system.stateVersion = stateVersion;
      };

    homeManager = {
      home.stateVersion = stateVersion;
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
        overlays = [ self.overlays.default ];
      };
      services.ssh-agent.enable = true;
      xdg.mimeApps.enable = true;
    };
  };
}
