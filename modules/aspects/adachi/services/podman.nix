{ ... }:
{
  adachi.services._.podman.nixos =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        (podman-compose.overrideAttrs (_: {
          src = fetchFromGitHub {
            owner = "containers";
            repo = "podman-compose";
            rev = "ed3ec99699f692de5440c929ee9e7bfb116871c2";
            hash = "sha256-OxuWnyxhT6sjH6K5b+7KTx4z8DLLn5sLFUDto9Pa6EY=";
          };
        }))
      ];
      networking.firewall =
        let
          matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
        in
        {
          trustedInterfaces = [ matchAll ];
          # "${matchAll}" = {
          #   allowedTCPPorts = [
          #     5432
          #     27017
          #   ];
          #   allowedUDPPorts = [ 53 ];
          # };
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
