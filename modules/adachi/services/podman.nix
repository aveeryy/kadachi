{ ... }:
{
  adachi.services._.podman.nixos =
    { config, ... }:
    {
      networking.firewall.interfaces =
        let
          matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
        in
        {
          "${matchAll}" = {
            allowedTCPPorts = [ 5432 ];
            allowedUDPPorts = [ 53 ];
          };
        };
      virtualisation = {
        oci-containers.backend = "podman";
        podman = {
          enable = true;
          autoPrune.enable = true;
          dockerSocket.enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };
}
