{ __findFile, ... }:
{
  den.aspects."avery@mizuki" = {
    includes = [
      <kasane/base-user>

      <kasane/services/syncthing>
      <kasane/theme>
      <kasane/tools/obsidian>
      <kasane/tools/xh>
    ];

    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages = with pkgs; [ setxkbmap ];
        programs = {
          obsidian.vaults = {
            Personal.target = "Notas/Personal";
            Trabajo.target = "Notas/Trabajo";
          };
          zsh.initContent = lib.mkAfter ''
            setxkbmap -layout es -variant dvorak 2> /dev/null
            WAYLAND_DISPLAY="wayland-1"
          '';
        };
      };

  };
}
