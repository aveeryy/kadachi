{ ... }:
{
  imports = [ ../nixos/theme.nix ];
  programs.lazygit.settings.gui.theme = {
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
  stylix = {
    targets = {
      lazygit.enable = false;
      kitty.enable = false;
      hyprlock.enable = false;
      hyprland.enable = false;
      neovim.enable = false;
      nixvim.enable = false;
      gtk.extraCss = ''
        .dialog-action-area > .text-button {
          color: @dialog_fg_color;
        }
      '';
    };
  };
}
