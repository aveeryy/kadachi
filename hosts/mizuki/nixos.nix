{ lib, pkgs, ... }: {

  boot.kernel.sysctl."vm.overcommit_memory" = 1;

  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ xorg.setxkbmap ];

  fonts = {
    packages = with pkgs; [ inter notonoto ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "notonoto" ];
      };
    };
  };

  networking = {
    hostName = "mizuki";
    nameservers = [ "1.1.1.1" ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  programs.zsh.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.avery.extraGroups = [ "wheel" ];
  };

  wsl = {
    enable = true;
    defaultUser = "avery";
    wslConf.network.generateResolvConf = false;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "24.11";

  time.timeZone = "Europe/Madrid";
}
