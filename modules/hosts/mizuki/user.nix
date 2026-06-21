{ __findFile, ... }:
{
  den.aspects."avery@mizuki" = {
    includes = [
      <kasane/base-user>

      <kasane/theme>
      <kasane/tools/lazydocker>
      <kasane/tools/xh>
    ];

    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages = with pkgs; [ setxkbmap ];
        programs.zsh.initContent = lib.mkAfter ''
          setxkbmap -layout es -variant dvorak 2> /dev/null
          WAYLAND_DISPLAY="wayland-1"
        '';
      };

  };
}
