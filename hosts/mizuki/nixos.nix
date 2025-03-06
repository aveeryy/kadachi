{ lib, pkgs, ... }: {

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.avery.extraGroups = [ "wheel" ];
  };

  wsl = {
    enable = true;
    defaultUser = "avery";
  };

  system.stateVersion = "24.11";
}
