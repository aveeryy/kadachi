{ pkgs, ... }:
let
  variant = "mocha";
  accent = "mauve";
  catppuccin-kvantum =
    pkgs.catppuccin-kvantum.override { inherit variant accent; };
in {
  home = {
    packages = with pkgs;
      [
        kdePackages.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugin-kvantum
        kdePackages.qtsvg
        kora-icon-theme
      ] ++ [ catppuccin-kvantum ];
  };
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-${variant}-${accent}
    '';
    "Kvantum/catppuccin-${variant}-${accent}".source =
      "${catppuccin-kvantum}/share/Kvantum/catppuccin-${variant}-${accent}";
  };
}
