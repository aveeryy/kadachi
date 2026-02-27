{ ... }:
{
  kasane.tools._.android =
    { user, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            android-tools
            scrcpy
          ];
          users.groups.adbusers.members = [ user.userName ];
        };
    };
}
