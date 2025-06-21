{ config, pkgs, ... }:
let portDefinitions = import ./_port-definitions.nix;
in {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    dataDir =
      "/mnt/ssd-01/postgresql/${config.services.postgresql.package.psqlSchema}";
    settings.port = portDefinitions.postgresql;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust

      # Allow containers access to the database
      host all all 10.89.0.0/16 trust
    '';
  };
}
