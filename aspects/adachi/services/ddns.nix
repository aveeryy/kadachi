{ kadachi-lib, ... }:
let
  inherit (kadachi-lib)
    recursiveMerge
    ;

  mkAspect = name: providerDomain: {
    ${name} = { host }: {
      nixos = { config, ddnsDomains, ... }: {
        services.inadyn.settings.provider.${providerDomain} = {
          hostname = [
            host.services.internetDomain
            "*.${host.services.internetDomain}"
          ]
          ++ ddnsDomains;
          username = host.services.internetDomain;
          include = config.sops.templates."ddns-${name}.conf".path;
        };
        sops = {
          secrets."ddns/${name}" = { };
          templates."ddns-${name}.conf" = {
            content = ''
              password = ${config.sops.placeholder."ddns/${name}"}
            '';
            owner = "inadyn";
          };
        };
      };
    };
  };
in
{
  adachi.services._.ddns = {
    description = "Dynamic DNS. This is a dummy aspect, use the children aspects.";

    provides = recursiveMerge [
      (mkAspect "cloudflare" "cloudflare.com")
      (mkAspect "desec" "desec.io")
    ];
  };
}
