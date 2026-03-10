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
      cloudflare = hostName: {
        nixos =
          { config, ... }:
          {
            services.inadyn.settings.provider."cloudflare.com" = {
              hostname = [
                hostName
                "*.${hostName}"
              ];
              username = hostName;
              include = config.sops.templates."ddns-cloudflare-${hostName}.conf".path;
            };
            sops = {
              secrets."ddns/cloudflare/${hostName}" = { };
              templates."ddns-cloudflare-${hostName}.conf" = {
                content = ''
                  password = ${config.sops.placeholder."ddns/cloudflare/${hostName}"}
                '';
                owner = "inadyn";
              };
            };

          };
      };
      desec = hostName: {
        nixos =
          { config, ... }:
          {
            services.inadyn.settings.provider."desec.io" = {
              hostname = [
                hostName
                "*.${hostName}"
              ];
              username = hostName;
              include = config.sops.templates."ddns-desec-${hostName}.conf".path;
            };
            sops = {
              secrets."ddns/desec/${hostName}" = { };
              templates."ddns-desec-${hostName}.conf" = {
                content = ''
                  password = ${config.sops.placeholder."ddns/desec/${hostName}"}
                '';
                owner = "inadyn";
              };
            };

          };
      };
    };
  };
}
