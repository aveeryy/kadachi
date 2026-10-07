{ kadachi-lib, lib, ... }:
let
  inherit (lib)
    mkDefault
    singleton
    ;

  inherit (kadachi-lib)
    recursiveMerge
    ;

  mkAspect =
    name: providerDomain:
    let
      nixosConfig = domain: { config, ... }: {
        services.inadyn.settings.provider.${providerDomain} = {
          hostname = [
            domain
            "*.${domain}"
          ];
          username = domain;
          include = config.sops.templates."ddns-${name}-${domain}.conf".path;
        };
        sops = {
          secrets."ddns/${name}/${domain}" = { };
          templates."ddns-${name}-${domain}.conf" = {
            content = ''
              password = ${config.sops.placeholder."ddns/${name}/${domain}"}
            '';
            owner = "inadyn";
          };
        };
      };

    in
    {
      ${name} = domain: { nixos = nixosConfig domain; };
      host._.${name} = { host }: { nixos = nixosConfig host.services.internetDomain; };
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
