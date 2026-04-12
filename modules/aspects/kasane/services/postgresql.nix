{
  kadachi-lib,
  den,
  ...
}:
{
  kasane.services._.postgresql = den.lib.take.exactly (
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
              local sameuser all peer map=superuser_map
              # Ask password in pgadmin
              host sameuser all 127.0.0.1/32 scram-sha-256
              # Podman containers
              host sameuser all 10.89.0.0/16 scram-sha-256
            '';
            identMap = ''
              superuser_map      root      postgres
              superuser_map      postgres  postgres
              superuser_map      /^(.*)$   \1
            '';
            initialScript = config.sops.templates."postgresql/init_script".path;
          };
          sops = {
            secrets."postgresql/admin_password".owner = "postgres";
            templates."postgresql/init_script" = {
              content = ''
                ALTER USER postgres WITH PASSWORD '${config.sops.placeholder."postgresql/admin_password"}';
              '';
              owner = "postgres";
            };
          };
        };
    }
  );
}
