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
      cloudflare = hostName: {
        nixos =
          { config, ... }:
          {
            security.acme.certs."${hostName}" = {
              credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE =
                lib.mkDefault
                  config.sops.secrets."acme/cloudflare/${hostName}".path;
              extraDomainNames = lib.mkDefault [ "*.${hostName}" ];
              dnsProvider = "cloudflare";
            };
            sops.secrets."acme/cloudflare/${hostName}".owner = "acme";
          };
      };
      hetzner = hostName: {
        nixos =
          { config, ... }:
          {
            security.acme.certs."${hostName}" = {
              credentialFiles.HETZNER_API_TOKEN_FILE =
                lib.mkDefault
                  config.sops.secrets."acme/hetzner/${hostName}".path;
              extraDomainNames = lib.mkDefault [ "*.${hostName}" ];
              dnsProvider = "hetzner";
            };
            sops.secrets."acme/hetzner/${hostName}".owner = "acme";
          };
      };
      desec = hostName: {
        nixos =
          { config, ... }:
          {
            security.acme.certs."${hostName}" = {
              credentialFiles.DESEC_TOKEN_FILE = lib.mkDefault config.sops.secrets."acme/desec/${hostName}".path;
              extraDomainNames = lib.mkDefault [ "*.${hostName}" ];
              dnsProvider = "desec";
            };
            sops.secrets."acme/desec/${hostName}".owner = "acme";
          };
      };
    };
  };
}
