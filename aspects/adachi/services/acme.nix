{
  __findFile,
  kadachi-lib,
  lib,
  den,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkOption
    optional
    singleton
    ;

  inherit (kadachi-lib)
    recursiveMerge
    ;

  mkAspect = name: envName: {
    ${name} = domain: {
      nixos = { config, ... }: {
        security.acme.certs.${domain} = {
          credentialFiles.${envName} = config.sops.secrets."acme/${name}/${domain}".path;
          extraDomainNames = mkDefault (singleton "*.${domain}");
          dnsProvider = name;
        };

        sops.secrets."acme/${name}/${domain}".owner = "acme";
      };
    };
  };

  defaultHostAspect = { host }: {
    includes = optional (host.services.internetDomain != null && host.services.acme.aspect != null) (
      host.services.acme.aspect host.services.internetDomain
    );
  };
in
{
  den.schema.host = { host, ... }: {
    options.services.acme = {
      aspect = mkOption {
        default = null;
      };
    };
  };

  den.default.includes = singleton defaultHostAspect;

  adachi.services._.acme = {
    description = "Automatic TLS certificate renewal using ACME and Let's Encrypt. This is a dummy aspect, use the children aspects.";

    provides = recursiveMerge [
      (mkAspect "cloudflare" "CLOUDFLARE_DNS_API_TOKEN_FILE")
      (mkAspect "desec" "DESEC_TOKEN_FILE")
      (mkAspect "hetzner" "HETZNER_API_TOKEN_FILE")
    ];
  };
}
