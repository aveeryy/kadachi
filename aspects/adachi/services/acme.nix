{ lib, ... }:
{
  adachi.services._.acme = {
    nixos.security.acme = {
      acceptTerms = true;
      defaults = {
        profile = lib.mkDefault "shortlived";
        group = lib.mkDefault "nginx";
        webroot = lib.mkDefault null;
        extraLegoFlags = lib.mkDefault [
          "--dns.propagation-wait=300s"
        ];
      };
    };

    provides = {
      cloudflare = domain: {
        nixos =
          { config, ... }:
          {
            security.acme.certs."${domain}" = {
              credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE =
                lib.mkDefault
                  config.sops.secrets."acme/cloudflare/${domain}".path;
              extraDomainNames = lib.mkDefault [ "*.${domain}" ];
              dnsProvider = "cloudflare";
            };
            sops.secrets."acme/cloudflare/${domain}".owner = "acme";
          };
      };
      hetzner = domain: {
        nixos =
          { config, ... }:
          {
            security.acme.certs."${domain}" = {
              credentialFiles.HETZNER_API_TOKEN_FILE =
                lib.mkDefault
                  config.sops.secrets."acme/hetzner/${domain}".path;
              extraDomainNames = lib.mkDefault [ "*.${domain}" ];
              dnsProvider = "hetzner";
            };
            sops.secrets."acme/hetzner/${domain}".owner = "acme";
          };
      };
      desec = domain: {
        nixos =
          { config, ... }:
          {
            security.acme.certs."${domain}" = {
              credentialFiles.DESEC_TOKEN_FILE = lib.mkDefault config.sops.secrets."acme/desec/${domain}".path;
              extraDomainNames = lib.mkDefault [ "*.${domain}" ];
              dnsProvider = "desec";
            };
            sops.secrets."acme/desec/${domain}".owner = "acme";
          };
      };
    };
  };
}
