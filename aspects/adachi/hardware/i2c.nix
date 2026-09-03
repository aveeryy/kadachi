{ ... }:
{
  adachi.hardware._.i2c =
    { user, ... }:
    {
      nixos = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.ddcutil ];
        hardware.i2c.enable = true;
        users.groups.i2c.members = [ user.userName ];
      };
    };
}
