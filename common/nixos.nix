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
    doas = {
      enable = true;
      extraRules = [{
        users = [ "avery" ];
        keepEnv = true;
        persist = true;
      }];
    };
    rtkit.enable = true;
    sudo.enable = false;
  };

  services.openssh.enable = true;

  sops = {
    secrets.avery_password = {
      sopsFile = "/etc/nixos/secrets/hosts/common.yaml";
      neededForUsers = true;
    };
    validateSopsFiles = false;
  };
}
