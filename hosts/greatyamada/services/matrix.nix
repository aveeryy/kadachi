{ pkgs, ... }:
let dataDir = "/mnt/Datos/synapse";
in {
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "rcia.dev";
      listeners = [{
        port = 8008;
        bind_addresses = [ "synapse" ];
        tls = false;
        type = http;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = false;
        }];
      }];
      media_store_path = dataDir + "/media_store";
      max_upload_size = "100M";
      enable_registration = false;
      report_stats = true;
      signing_key_path = "/var/lib/matrix-synapse/matrix.rcia.dev.signing.key";
      turn_user_lifetime = "1h";
      turn_uris = [ "turn:rcia.dev:3478" "turn:rcia.dev:3479" ];
    };
  };
  sops.secrets = {
    "matrix/secrets" = {
        path = "/var/lib/matrix-synapse/secrets";
        owner = "matrix-synapse";
    }
  }
}
