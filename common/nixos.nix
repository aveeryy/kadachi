{ config, lib, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  console = {
    keyMap = lib.mkForce "dvorak-es";
    useXkbConfig = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users = {
    defaultUserShell = pkgs.zsh;
    users.avery = {
      description = "Avery";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.avery_password.path;
    };
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [ git htop neovim sops ];
  };

  programs.zsh.enable = true;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  sops = {
    secrets.avery_password = {
      sopsFile = "/etc/nixos/secrets/common.yaml";
      neededForUsers = true;
    };
    validateSopsFiles = false;
  };
}
