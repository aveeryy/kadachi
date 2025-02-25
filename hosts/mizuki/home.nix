{ pkgs, ... }: {
  home = {
    username = "avery";
    homeDirectory = "/home/avery";
    stateVersion = "24.11";
    packages = with pkgs; [ python3 ];
    sessionVariables.EDITOR = "nvim";
  };
  programs.home-manager.enable = true;
}
