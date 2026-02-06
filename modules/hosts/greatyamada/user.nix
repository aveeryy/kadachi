{ __findFile, ... }:
{
  den.aspects.avery_greatyamada =
    let
      media_group_member =
        { user, ... }:
        {
          nixos.users.groups.media.members = [ user.userName ];
        };
    in
    {

      includes = [
        <kasane/base-user>

        <adachi/nixvim/extras/format-on-save>
        (<adachi/services/gpg-agent> false)

        media_group_member
      ];
    };
}
