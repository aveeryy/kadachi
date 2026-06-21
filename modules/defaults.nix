{
  __findFile,
  inputs,
  lib,
  den,
  ...
}:
let
  stateVersion = "26.05";

  jovianClass =
    { class, aspect-chain }:
    den._.forward {
      each = lib.singleton class;
      fromClass = _: "jovian";
      intoClass = _: "nixos";
      intoPath = _: [ "jovian" ];
      fromAspect = _: lib.last aspect-chain;
      guard = { options, ... }: options ? jovian;
    };

  noctaliaShellClass =
    { class, aspect-chain }:
    den._.forward {
      each = lib.singleton class;
      fromClass = _: "noctaliaShell";
      intoClass = _: "homeManager";
      intoPath = _: [
        "programs"
        "noctalia-shell"
      ];
      fromAspect = _: lib.last aspect-chain;
      guard = { options, ... }: options ? programs.noctalia-shell;
    };

  wslClass =
    { class, aspect-chain }:
    den._.forward {
      each = lib.singleton class;
      fromClass = _: "wsl";
      intoClass = _: "nixos";
      intoPath = _: [ "wsl" ];
      fromAspect = _: lib.last aspect-chain;
      guard = { options, ... }: options ? wsl;
    };
in
{
  flake-file.inputs = {
    kadachi-nvim = {
      url = "git+https://git.rcia.dev/Avery/kadachi-nvim.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://forgejo@git.rcia.dev:2222/Avery/kadachi-secrets.git";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.schema.user =
    { user, ... }:
    {
      classes = lib.mkDefault [ "homeManager" ];
      aspect = lib.mkDefault den.aspects."${user.userName}@${user.host.hostName}";
    };

  den.default = {
    includes = [
      <den/hostname>
      <den/define-user>
      <den/host-aspects>
      <den/mutual-provider>
      den.batteries.inputs'
      den.batteries.self'

      jovianClass
      noctaliaShellClass
      wslClass
    ];

    nixos =
      {
        config,
        pkgs,
        lib,
        inputs',
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
          sops
          ncdu

          inputs'.kadachi-nvim.packages.kadachi-nvim
        ];
        hardware.enableRedistributableFirmware = true;
        home-manager = {
          backupFileExtension = "bak";
          useUserPackages = true;
        };
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
        networking.dhcpcd.wait = "background";
        nixpkgs.config.allowUnfree = true;
        programs = {
          nh = {
            enable = true;
            clean = {
              enable = true;
              dates = "weekly";
              extraArgs = "--keep-since 14d";
            };
            flake = "/etc/nixos";
          };
          ssh.extraConfig = ''
            AddKeysToAgent yes
          '';
        };
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
            extraConfig = "Defaults !pwfeedback";
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
      nixpkgs.config.allowUnfree = true;
      services.ssh-agent.enable = true;
      xdg.mimeApps.enable = true;
    };
  };
}
