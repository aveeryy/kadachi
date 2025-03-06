{ pkgs, ... }: {
  home = {
    username = "avery";
    homeDirectory = "/home/avery";
    stateVersion = "24.11";
    packages = with pkgs; [ python3 ];
    sessionVariables.EDITOR = "nvim";
  };
  programs.home-manager.enable = true;
  programs.zsh.initExtra = ''
    setxkbmap -layout es -variant dvorak
    WAYLAND_DISPLAY="wayland-1"
  '';
}
