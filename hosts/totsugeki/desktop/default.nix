{ config, pkgs, ... }: {
  imports = [
    ./dunst.nix
    ./firefox.nix
    ./gtk.nix
    ./hyprland.nix
    ./kitty.nix
    ./qt.nix
    ./rofi.nix
    ./waybar.nix
  ];
  home = {
    packages = with pkgs; [
      gimp
      fastfetch
      inkscape
      libreoffice-qt
      libsForQt5.qt5ct
      obs-studio
      picard
      protonup-qt
      grim
      libsForQt5.ark
      libsForQt5.dolphin
      libsForQt5.dolphin-plugins
      libsForQt5.kio
      libsForQt5.kio-extras
      libsForQt5.kimageformats
      libsForQt5.qt5.qtimageformats
      mpv
      noto-fonts-cjk-sans
      nsxiv
      pamixer
      playerctl
      qbittorrent
      r2modman
      slurp
      swww
      wl-clipboard
      (import ./scripts/colorpicker.nix { inherit pkgs; })
      (import ./scripts/currently-playing.nix { inherit pkgs; })
      (pkgs.buildEnv {
        name = "desktop-scripts";
        paths = [ ./scripts_legacy ];
      })
    ];
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.phinger-cursors;
      name = "phinger-cursors";
      size = 32;
    };
  };
  services.easyeffects.enable = true;
  xdg.enable = true;
}
