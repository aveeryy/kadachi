{ config, pkgs, ... }:
let
  ports = import ./_port-definitions.nix;
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
in {
  services = {
    searx = {
      enable = true;
      package = pkgs.searxng;
      environmentFile = config.sops.templates."searxng_secret_key.env".path;
      redisCreateLocally = true;
      # runInUwsgi = true;
      # uwsgiConfig = {
      #   socket = "/run/searx/searxng.sock";
      #   http = ":${toString ports.searxng}";
      #   chmod-socket = "660";
      # };
      settings = {
        base_url = "https://searxng.rcia.dev";
        bind_address = "127.0.0.1";
        port = ports.tcp.searxng;
        public_instance = false;
        limiter = false;
      };

    };
    nginx.virtualHosts."searxng.rcia.dev" = {
      locations."/".proxyPass =
        "http://127.0.0.1:${toString ports.tcp.searxng}";
      extraConfig = nginxLocalServiceConfig;
      forceSSL = true;
      useACMEHost = "rcia.dev";
    };
  };
  sops = {
    secrets."searxng_secret_key".owner = "searx";
    templates."searxng_secret_key.env" = {
      content = ''
        SEARXNG_SECRET=${config.sops.placeholder."searxng_secret_key"}
      '';
      owner = "searx";
    };
  };
  systemd.services.nginx.serviceConfig.ProtectHome = false;
  users.groups.searx.members = [ "nginx" ];
}
