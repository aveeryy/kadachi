{ lib, ... }:
{
  kasane.tools._.fastfetch.homeManager.programs = {
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          # TODO: change depending on terminal
          type = "kitty-direct";
          # TODO: include images in flake
          source = "/home/avery/.config/fastfetch/logo_nixos.png";
          padding.right = 1;
        };
        display = {
          separator = " ";
          color = "white";
        };
        modules = [
          {
            type = "separator";
            string = " ";
          }
          "title"
          {
            type = "os";
            key = " ";
            keyColor = "blue";
            format = "{2} {9}";
          }
          {
            type = "kernel";
            key = " ";
            keyColor = "red";
            format = "{2}";
          }
          {
            type = "uptime";
            keyColor = "yellow";
            key = " ";
          }
          {
            type = "wm";
            key = " ";
            format = "{2}";
            keyColor = "magenta";
          }
        ];
      };
    };
    zsh.initContent = lib.mkAfter ''
      fastfetch;
    '';
  };
}
