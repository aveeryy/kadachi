{ ... }: {
  services.ddclient = {
    enable = true;
    interval = "5min";
    quiet = true;
    protocol = "cloudflare";
    zone = "rcia.dev";
    passwordFile = "/run/secrets/cloudflare_api_token";
    domains = [ "@" "*" ];"
  };
}
