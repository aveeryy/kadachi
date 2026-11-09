{ lib, ... }:
let
  inherit (lib)
    attrValues
    filter
    ;
in
{
  megurine.has._.wifi = { host }: {
    nixos = {
      networking.networkmanager = {
        enable = true;
        unmanaged = map (interface: interface.name) (
          filter (interface: interface.type == "wired") (attrValues host.networking.interfaces)
        );
      };
    };
  };
}
