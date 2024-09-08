{ pkgs, ... }: {
  home.packages = with pkgs; [ pciutils ];
  programs.ags = {
    enable = true;
    # configDir = ./widgets;
  };
}
