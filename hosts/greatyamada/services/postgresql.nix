{ config, pkgs, ... }:
let portDefinitions = import ./_port-definitions.nix;
in {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir =
      "/mnt/ssd-01/postgresql/${config.services.postgresql.package.psqlSchema}";
    settings.port = portDefinitions.postgresql;
  };
}
