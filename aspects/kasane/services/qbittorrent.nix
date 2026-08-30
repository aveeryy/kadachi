{ lib, ... }:
let
  inherit (lib)
    mkOption
    optional
    ;

  inherit (lib.types)
    str
    ;
in
{
  den.schema.host = { host, ... }: {
    options.services.qui = {
      domain = mkOption {
        type = str;
        default = "torrent.${host.services.baseDomain}";
      };
      database = mkOption {
        type = str;
        default = host.services.database.default;
      };
    };
  };

  kasane.services._.qbittorrent =
    { host }:
    let
      postgresConfiguration.nixos =
        { config, ... }:
        {
          services = {
            postgresql = {
              ensureDatabases = [ "qui" ];
              ensureUsers = [
                {
                  name = config.services.qui.user;
                  ensureDBOwnership = true;
                }
              ];
            };
            qui.settings.databaseEngine = "postgres";
          };

          systemd.services.qui.serviceConfig = {
            LoadCredential = [
              "sessionSecret:${config.services.qui.secretFile}"
              "databaseDsn:${config.sops.secrets."qui/database_dsn".path}"
            ];
            Environment = [ "QUI__DATABASE_DSN_FILE=%d/databaseDsn" ];
          };

          sops.secrets."qui/database_dsn".owner = "qui";
        };
    in
    {
      description = "Headless qBitTorrent using qui as a WebUI";

      includes = optional (host.services.qui.database == "postgres") postgresConfiguration;

      nixos =
        { config, ... }:
        {
          networking.firewall.allowedTCPPorts = [ config.services.qbittorrent.torrentingPort ];

          services = {
            qbittorrent = {
              enable = true;

              webuiPort = 25210;
              torrentingPort = 25827;

              serverConfig = {
                BitTorrent = {
                  Session = {
                    # Re-enable these when I get a better router
                    DHTEnabled = false;
                    LSDEnabled = false;
                    PeXEnabled = false;

                    MaxConnections = 500;
                  };
                };

                LegalNotice.Accepted = true;

                Network.PortForwardingEnabled = false;

                Preferences = {
                  WebUI = {
                    Address = "127.0.0.1";
                    Enabled = true;
                    LocalHostAuth = false;
                    UseUPnP = false;
                  };
                };
              };
            };

            qui = {
              enable = true;
              secretFile = config.sops.secrets."qui/secret".path;
              settings = {
                host = "127.0.0.1";
                port = 25430;
              };
            };

            nginx.virtualHosts.${host.services.qui.domain} = {
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString config.services.qui.settings.port}";
              };
              forceSSL = true;
              useACMEHost = host.services.baseDomain;
              extraConfig = host.services.nginx.localServiceConfig;
            };
          };

          sops.secrets."qui/secret".owner = "qui";
        };
    };
}
