{
  kadachi-lib,
  den,
  lib,
  ...
}:
let
  inherit (lib.attrsets) optionalAttrs;
in
{
  kasane.services._.database = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { pkgs, config, ... }:
        {
          imports = [
            (kadachi-lib.createBackupConfiguration "postgresql" host {
              postgresql_databases = [
                {
                  name = "all";
                  format = "directory";
                  compression = "none";
                  no_owner = false;
                  # Small hack to run the pg_* commands as root while using the
                  # postgres user for the database connection
                  username = "root";
                  options = "--username postgres";
                  list_options = "--username postgres";
                  restore_options = "--username postgres";
                }
              ];
              keep_hourly = 24;
              keep_daily = 7;
              keep_weekly = 4;
            })
          ];

          services.postgresql = {
            enable = true;
            package = pkgs.postgresql_16;
            enableTCPIP = true;
            settings.port = 5432;
            authentication = pkgs.lib.mkOverride 10 ''
              local all all trust
              host all all 127.0.0.1/32 trust
              host all all ::1/128 trust

              # Allow OCI containers access to the database
              host all all 10.89.0.0/16 trust
            '';
          };

        };
    }
  );
}
