{ lib, pkgs, ... }: {

  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ xorg.setxkbmap android-tools ];

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.avery.extraGroups = [ "wheel" "adbusers" ];
  };

  wsl = {
    enable = true;
    defaultUser = "avery";
    usbip.enable = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "24.11";
}
