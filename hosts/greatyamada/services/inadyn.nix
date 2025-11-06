{ config, ... }: {
  services.inadyn = {
    enable = true;
    settings.allow-ipv6 = false;
    settings.provider."cloudflare.com" = {
      hostname = [ "rcia.dev" "*.rcia.dev" ];
      username = "rcia.dev";
      include = config.sops.templates."inadyn-password.conf".path;
    };
  };
  sops = {
    secrets."cloudflare/api_token" = { };
    templates."inadyn-password.conf" = {
      content = ''
        password = ${config.sops.placeholder."cloudflare/api_token"}
      '';
      owner = "inadyn";
    };
  };
}
