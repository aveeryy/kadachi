{ pkgs, ... }:
let cursorThemeName = "catppuccin-mocha-mauve-cursors";
in {
  home = {
    packages = with pkgs; [
      (catppuccin-kde.override {
        flavour = [ "mocha" ];
        accents = [ "mauve" ];
      })
      catppuccin-cursors.mochaMauve
    ];
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = cursorThemeName;
      size = 32;
    };
  };
  programs.plasma = {
    fonts = {
      general = {
        family = "Inter Display";
        pointSize = 11;
        weight = "medium";
      };
      fixedWidth = {
        family = "Iosevka Nerd Font";
        pointSize = 12;
      };
      small = {
        family = "Inter Display";
        pointSize = 8;
      };
      toolbar = {
        family = "Inter Display";
        pointSize = 11;
        weight = "medium";
      };
      menu = {
        family = "Inter Display";
        pointSize = 11;
        weight = "medium";
      };
      windowTitle = {
        family = "Inter Display";
        pointSize = 11;
        weight = "medium";
      };
    };
    workspace = {
      colorScheme = "CatppuccinMochaMauve";
      lookAndFeel = "Catppuccin-Mocha-Mauve";
      cursor = {
        theme = cursorThemeName;
        size = 32;
      };
    };
  };
}
