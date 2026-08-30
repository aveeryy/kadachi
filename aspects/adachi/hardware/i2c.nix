{ ... }:
{
  adachi.hardware._.i2c =
    { user, ... }:
    {
      nixos = {
        hardware.i2c.enable = true;
        users.groups.i2c.members = [ user.userName ];
      };
    };
}
