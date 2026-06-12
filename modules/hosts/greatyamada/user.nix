{ __findFile, ... }:
{
  den.aspects."avery@greatyamada" =
    let
      media_group_member =
        { user, ... }:
        {
          nixos.users.groups.media.members = [ user.userName ];
        };

      minecraft_group_member =
        { user, ... }:
        {
          nixos.users.groups.minecraft.members = [ user.userName ];
        };
    in
    {

      includes = [
        <kasane/base-user>

        <adachi/neovim/extras/format-on-save>

        media_group_member
        minecraft_group_member
      ];
    };
}
