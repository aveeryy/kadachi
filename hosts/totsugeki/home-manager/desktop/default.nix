{ pkgs, ... }: {
  imports = [
    ./ags
    ./cursor.nix
    ./dunst.nix
    ./firefox.nix
    ./gtk.nix
    ./hypr
    ./kitty.nix
    ./qt.nix
  ];
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
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
      vesktop
      swww
      lxqt.lxqt-policykit
      qdiskinfo
      mangohud
      heroic
      filen-desktop
      p7zip
      scrcpy
      # Media management tools
      mediainfo-gui
      sound-juicer
      mkvtoolnix
      handbrake
    ];
  };
  nixpkgs.config.allowUnfree = true;
  services = { easyeffects.enable = true; };
  xdg.enable = true;
}
