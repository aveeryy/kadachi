{ __findFile, ... }:
{
  den.aspects."avery@mizuki" = {
    includes = [
      <kasane/base-user>

      <adachi/neovim/extras/format-on-save>
      <adachi/neovim/languages/markdown>
      <adachi/neovim/languages/rust>
      <adachi/neovim/languages/shell>
      <adachi/neovim/languages/python>
      <adachi/neovim/languages/vue>

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
