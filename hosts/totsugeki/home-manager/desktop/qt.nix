{ pkgs, ... }:
let
  variant = "Mocha";
  accent = "Mauve";
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
      theme=Catppuccin-${variant}-${accent}
    '';
    "Kvantum/Catppuccin-${variant}-${accent}".source =
      "${catppuccin-kvantum}/share/Kvantum/Catppuccin-${variant}-${accent}";
  };
}
