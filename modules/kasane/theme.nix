{ inputs, ... }:
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-parts.follows = "flake-parts";
      systems.follows = "systems";
    };
  };

  kasane.theme = {
    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];
        fonts = {
          packages = with pkgs; [
            inter
            mplus-outline-fonts.githubRelease
            nerd-fonts.iosevka
            noto-fonts-cjk-sans
            vista-fonts
          ];
          fontconfig = {
            defaultFonts = {
              serif = [
                "Inter"
                "Mplus1"
              ];
              sansSerif = [
                "Inter"
                "Mplus1"
              ];
              monospace = [
                "Iosevka Nerd Font"
                "Mplus1Code"
              ];
            };
          };
        };
        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
          polarity = "dark";
          icons = {
            enable = true;
            package = pkgs.kora-icon-theme;
            light = "kora-light";
            dark = "kora";
          };
          fonts = {
            serif = {
              package = pkgs.inter;
              name = "Inter";
            };
            sansSerif = {
              package = pkgs.inter;
              name = "Inter";
            };
            monospace = {
              package = pkgs.nerd-fonts.iosevka;
              name = "Iosevka Nerd Font";
            };
            sizes.applications = 10;
          };
        };
      };
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        home.pointerCursor = {
          gtk.enable = true;
          hyprcursor.enable = true;
          package = pkgs.phinger-cursors;
          name = "phinger-cursors-dark";
          size = 32;
        };
        programs = {
          kitty = {
            font = {
              name = "Iosevka Nerd Font";
              size = 12;
            };
            settings.background_opacity = "0.85";
            themeFile = "Catppuccin-Mocha";
          };
          lazygit.settings.gui.theme = {
            activeBorderColor = [
              "#89b4fa"
              "bold"
            ];
            inactiveBorderColor = [ "#a6adc8" ];
            optionsTextColor = [ "#89b4fa" ];
            selectedLineBgColor = [ "#313244" ];
            selectedRangeBgColor = [ "#313244" ];
            cherryPickedCommitBgColor = [ "#45475a" ];
            cherryPickedCommitFgColor = [ "#89b4fa" ];
            unstagedChangesColor = [ "#f38ba8" ];
            defaultFgColor = [ "#cdd6f4" ];
            searchingActiveBorderColor = [ "#f9e2af" ];
          };
        };
        stylix.targets = {
          lazygit.enable = false;
          firefox.enable = false;
          kitty.enable = false;
          hyprlock.enable = false;
          hyprland.colors.enable = false;
          neovim.enable = false;
          nixvim.enable = false;
          gtk.extraCss = ''
            .dialog-action-area > .text-button {
              color: @dialog_fg_color;
            }
          '';
        };
        wayland.windowManager.hyprland.settings.exec-once = lib.mkOrder 20 [
          "hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}"
        ];
      };
  };
}
