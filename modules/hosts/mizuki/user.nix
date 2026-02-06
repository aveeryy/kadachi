{ __findFile, ... }:
{
  den.aspects.avery_mizuki = {
    includes = [
      <kasane/base-user>

      <adachi/nixvim/extras/format-on-save>
      <adachi/nixvim/languages/markdown>
      <adachi/nixvim/languages/python>
      <adachi/nixvim/languages/vue>
      (<adachi/services/gpg-agent> true)

      <kasane/tools/xh>
      <kasane/theme>
    ];

    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages = with pkgs; [ xorg.setxkbmap ];
        programs.zsh.initContent = lib.mkAfter ''
          setxkbmap -layout es -variant dvorak 2> /dev/null
          WAYLAND_DISPLAY="wayland-1"
        '';
      };

  };
}
