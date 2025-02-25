{ lib, pkgs, ... }: {

  environment.shells = with pkgs; [ zsh ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  security.sudo.enable = true;

  services = { mongodb.enable = true; };

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
