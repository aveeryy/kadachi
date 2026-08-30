{ ... }:
{
  adachi.services._.ddns = {
    nixos =
      { config, ... }:
      {
        services.inadyn = {
          enable = true;
          settings.allow-ipv6 = config.networking.enableIPv6;
        };
      };

    provides = {
      cloudflare = domain: {
        nixos =
          { config, ... }:
          {
            services.inadyn.settings.provider."cloudflare.com" = {
              hostname = [
                domain
                "*.${domain}"
              ];
              username = domain;
              include = config.sops.templates."ddns-cloudflare-${domain}.conf".path;
            };
            sops = {
              secrets."ddns/cloudflare/${domain}" = { };
              templates."ddns-cloudflare-${domain}.conf" = {
                content = ''
                  password = ${config.sops.placeholder."ddns/cloudflare/${domain}"}
                '';
                owner = "inadyn";
              };
            };

          };
      };
      desec = domain: {
        nixos =
          { config, ... }:
          {
            services.inadyn.settings.provider."desec.io" = {
              hostname = [
                domain
                "*.${domain}"
              ];
              username = domain;
              include = config.sops.templates."ddns-desec-${domain}.conf".path;
            };
            sops = {
              secrets."ddns/desec/${domain}" = { };
              templates."ddns-desec-${domain}.conf" = {
                content = ''
                  password = ${config.sops.placeholder."ddns/desec/${domain}"}
                '';
                owner = "inadyn";
              };
            };

          };
      };
    };
  };
}
