{ ... }:
{
  kasane.services._.database = {
    nixos =
      { pkgs, config, ... }:
      {
        services = {
          postgresql = {
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
          forgejo.database = {
            type = "postgres";
            port = config.services.postgresql.settings.port;
            passwordFile = config.sops.secrets."forgejo/database_password".path;
          };
          vaultwarden.dbBackend = "postgresql";
        };
      };
  };
}
