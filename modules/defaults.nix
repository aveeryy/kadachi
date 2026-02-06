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
          config.allowUnfree = true;
          overlays = [ self.overlays.default ];
        };
        programs.ssh.extraConfig = ''
          AddKeysToAgent yes
        '';
        sops = {
          defaultSopsFile =
            if (builtins.pathExists "${inputs.secrets}/${config.networking.hostName}.yaml") then
              "${inputs.secrets}/${config.networking.hostName}.yaml"
            else
              "${inputs.secrets}/common.yaml";
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
              PasswordAuthentication = false;
              PermitRootLogin = "no";
              X11Forwarding = false;
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
