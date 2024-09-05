{ pkgs, ... }: {
  imports = [
    ./ags
    ./cursor.nix
    ./dunst.nix
    ./firefox.nix
    ./lf.nix
    ./gtk.nix
    ./kitty.nix
    ./sway.nix
  ];
  home = {
    packages = with pkgs; [
      gimp
      fastfetch
      inkscape
      kdePackages.ark
      libreoffice-qt
      obs-studio
      picard
      protonup-qt
      mpv
      noto-fonts-cjk-sans
      nsxiv
      osu-lazer-bin
      playerctl
      prismlauncher
      qbittorrent
      r2modman
      wl-clipboard
      wineWowPackages.stagingFull
      element-desktop
      vesktop
      swww
    ];
  };
  nixpkgs.config.allowUnfree = true;
  services.easyeffects.enable = true;
  xdg.enable = true;
}
