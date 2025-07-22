{ pkgs, ... }: {
  imports = [ ./development.nix ./scripts ./zsh.nix ];
  home = {
    username = "avery";
    homeDirectory = "/home/avery";
    stateVersion = "24.05";
    packages = with pkgs; [ rclone xdg-utils ];
    sessionVariables = { EDITOR = "nvim"; };
  };
  programs.home-manager.enable = true;
}
