{ inputs, ... }:
let
  blur = {
    size = 2;
    passes = 3;
  };

  inactiveWindowDim = 0.4;

  windowGaps = {
    inner = 4;
    outer = 8;
  };

  windowRounding = 12;
in
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-parts.follows = "flake-parts";
    };
  };

  kasane.theme = {
    description = "System-wide theme configuration, this only configures common properties, not everything that is customizable";

    nixos =
      { pkgs, config, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];
        fonts = {
          packages = with pkgs; [
            mplus-outline-fonts.githubRelease
            noto-fonts-cjk-sans
            vista-fonts
          ];
          fontconfig = {
            defaultFonts = {
              serif = [
                "Mplus1"
              ];
              sansSerif = [
                "Mplus1"
              ];
              monospace = [
                "Mplus1Code"
              ];
            };
          };
        };
        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
          polarity = "dark";
          cursor = {
            package = pkgs.phinger-cursors;
            name = "phinger-cursors-dark";
            size = 32;
          };
          icons = {
            enable = true;
            package = pkgs.kora-icon-theme;
            light = "kora-light";
            dark = "kora";
          };
          fonts = {
            serif = config.stylix.fonts.sansSerif;
            sansSerif = {
              name = "Inter";
              package = pkgs.inter;
            };
            monospace = {
              name = "Iosevka Nerd Font";
              package = pkgs.nerd-fonts.iosevka;
            };
            sizes = {
              applications = 10;
              terminal = 12;
            };
          };
          opacity.terminal = 0.85;
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
        programs = {
          kitty.themeFile = "Catppuccin-Mocha";

          lazydocker.settings.gui.theme = with config.lib.stylix.colors.withHashtag; {
            activeBorderColor = [
              blue
              "bold"
            ];
            inactiveBorderColor = [ base04 ];
            optionsTextColor = [ bright-blue ];
            selectedLineBgColor = [ base01 ];
          };

          lazygit.settings.gui.theme = with config.lib.stylix.colors.withHashtag; {
            activeBorderColor = [
              blue
              "bold"
            ];
            inactiveBorderColor = [ base04 ];
            optionsTextColor = [ bright-blue ];
            selectedLineBgColor = [ base01 ];
            selectedRangeBgColor = [ base01 ];
            cherryPickedCommitBgColor = [ base02 ];
            cherryPickedCommitFgColor = [ bright-blue ];
            unstagedChangesColor = [ red ];
            defaultFgColor = [ base05 ];
            searchingActiveBorderColor = [ yellow ];
          };
        };

        stylix = {
          autoEnable = false;
          targets = {
            fontconfig.enable = true;
            kitty = {
              enable = true;
              colors.enable = false;
              fonts.enable = true;
              opacity.enable = true;
            };
            gtk.enable = true;
            qt.enable = true;
          };
        };

        wayland.windowManager.hyprland.settings = {
          exec-once = lib.mkOrder 20 [
            "hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}"
          ];

          general = {
            gaps_in = windowGaps.inner;
            gaps_out = windowGaps.outer;
          };

          decoration = {
            blur = {
              enabled = blur.size > 0;
              inherit (blur) size passes;
            };
            dim_inactive = inactiveWindowDim > 0;
            dim_strength = inactiveWindowDim;
            rounding = windowRounding;
            shadow.enabled = false;
          };
        };
      };

    noctaliaShell =
      { osConfig, ... }:
      {
        settings = {
          bar = {
            marginHorizontal = windowGaps.outer;
            marginVertical = windowGaps.outer;
          };
          colorSchemes.predefinedScheme = "Catppuccin";
          general.enableShadows = false;
          ui.panelBackgroundOpacity = osConfig.stylix.opacity.terminal;
        };
      };
  };
}
