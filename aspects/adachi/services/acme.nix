{
  __findFile,
  kadachi-lib,
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    singleton
    ;

  inherit (kadachi-lib)
    recursiveMerge
    ;

  mkAspect =
    name: envName:
    let
      nixosConfig = domain: { config, ... }: {
        security.acme.certs.${domain} = {
          credentialFiles.${envName} = config.sops.secrets."acme/${name}/${domain}".path;
          extraDomainNames = mkDefault (singleton "*.${domain}");
          dnsProvider = name;
        };

        sops.secrets."acme/${name}/${domain}".owner = "acme";
      };
    in
    {
      ${name} = domain: { nixos = nixosConfig domain; };
      host._.${name} = { host }: { nixos = nixosConfig host.services.internetDomain; };
    };
in
{
  adachi.services._.acme = {
    description = "Automatic TLS certificate renewal using ACME and Let's Encrypt. This is a dummy aspect, use the children aspects.";

    provides = recursiveMerge [
      (mkAspect "cloudflare" "CLOUDFLARE_DNS_API_TOKEN_FILE")
      (mkAspect "desec" "DESEC_TOKEN_FILE")
      (mkAspect "hetzner" "HETZNER_API_TOKEN_FILE")
    ];
  };
}
