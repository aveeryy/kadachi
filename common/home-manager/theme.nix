{ ... }:
{
  imports = [ ../nixos/theme.nix ];
  stylix = {
    targets = {
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
