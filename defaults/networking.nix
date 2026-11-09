{ lib, ... }:
let
  inherit (lib)
    mapAttrs'
    mkDefault
    nameValuePair
    singleton
    ;
in
{
  den.default = {
    includes = singleton (
      { host }: {
        nixos = {
          systemd.network.networks = mapAttrs' (
            name: config:
            nameValuePair ("0-interface-${name}") ({
              matchConfig.Name = config.name;
              networkConfig.DHCP = config.dhcp;
              linkConfig.RequiredForOnline = if config.requiredForOnline then "routable" else "no";
              address = config.addresses;
              routes = config.routes;
            })
          ) host.networking.interfaces;
        };
      }
    );

    nixos = {
      networking = {
        dhcpcd.enable = false;
        useNetworkd = true;
      };

      systemd.network = {
        enable = true;
        wait-online = {
          enable = mkDefault true;
          anyInterface = mkDefault true;
        };
      };
    };
  };
}
