{ ... }:
{
  adachi.services._.podman.nixos =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        podman-compose
      ];
      networking.firewall =
        let
          matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
        in
        {
          trustedInterfaces = [ matchAll ];
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
