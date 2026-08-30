{ ... }:
{
  kasane.services._.mullvad-vpn = {
    nixos =
      { pkgs, ... }:
      {
        services = {
          mullvad-vpn = {
            enable = true;
            package = pkgs.mullvad-vpn;
          };
          resolved.enable = true;
        };
      };
    homeManager.programs.mullvad-vpn.enable = true;
  };
}
