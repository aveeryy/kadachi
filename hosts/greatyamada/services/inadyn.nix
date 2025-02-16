{ config, ... }: {
  services.inadyn = {
    enable = true;
    provider."cloudflare.com" = {
      hostname = [ "rcia.dev" "*.rcia.dev" ];
      username = "rcia.dev";
      password = "${config.sops.placeholder.cloudflare.api_key}";
    };
  };
}
