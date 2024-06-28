{ config, pkgs, ... }: {
  imports = [ ./plasma ./firefox.nix ./gtk.nix ./kitty.nix ];
  home = {
    packages = with pkgs; [
      gimp
      fastfetch
      inkscape
      libreoffice-qt
      obs-studio
      picard
      protonup-qt
      kdePackages.ark
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kimageformats
      kdePackages.qtimageformats
      kdePackages.sddm-kcm
      mpv
      noto-fonts-cjk-sans
      nsxiv
      osu-lazer-bin
      playerctl
      prismlauncher
      qbittorrent
      r2modman
      wl-clipboard
      element-desktop
      vesktop
    ];
  };
  nixpkgs.config.allowUnfree = true;
  services.easyeffects.enable = true;
  xdg.enable = true;
}
