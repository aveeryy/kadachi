{ ... }:
{
  kasane.tools._.android =
    { user, ... }:
    {
      nixos = {
        users.groups.adbusers.members = [ user.userName ];
      };

      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            android-tools
            scrcpy
          ];
        };

    };
}
