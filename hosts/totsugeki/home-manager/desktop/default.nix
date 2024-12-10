{ pkgs, ... }: {
  imports = [
    ./ags
    ./cursor.nix
    ./dunst.nix
    ./firefox.nix
    ./gtk.nix
    ./kitty.nix
    ./sway.nix
    ./qt.nix
  ];
  home = {
    packages = with pkgs; [
      gimp
      fastfetch
      inkscape
      kdePackages.ark
      kdePackages.qtwayland
      libreoffice-qt
      obs-studio
      picard
      protonup-qt
      mpv
      noto-fonts-cjk-sans
      nsxiv
      osu-lazer-bin
      pcmanfm-qt
      playerctl
      prismlauncher
      qbittorrent
      r2modman
      wl-clipboard
      wineWowPackages.stagingFull
      element-desktop
      vesktop
      swww
      lxqt.lxqt-policykit
      qdiskinfo
      mangohud
      heroic
    ];
  };
  nixpkgs.config.allowUnfree = true;
  services.easyeffects.enable = true;
  xdg.enable = true;
}
