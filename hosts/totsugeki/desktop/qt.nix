{ pkgs, ... }: {
  home.packages = with pkgs; [ catppuccin-kde lightly-qt ];
  qt = {
    enable = true;
    platformTheme = "qtct";
  };
}
