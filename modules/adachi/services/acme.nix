{ ... }:
{
  adachi.services._.acme = {
    nixos.security.acme = {
      acceptTerms = true;
      defaults.profile = "shortlived";
    };
    provides = {
      cloudflare = hostName: email: {
        nixos =
          { config, ... }:
          {
            security.acme.certs."${hostName}" = {
              credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE =
                config.sops.secrets."acme/cloudflare/${hostName}".path;
              email = email;
              extraDomainNames = [ "*.${hostName}" ];
              dnsProvider = "cloudflare";
              group = "nginx";
              webroot = null;
            };
            sops.secrets."acme/cloudflare/${hostName}".owner = "acme";
          };
      };
      hetzner = hostName: email: {
        nixos =
          { config, ... }:
          {
            security.acme.certs."${hostName}" = {
              credentialFiles.HETZNER_API_TOKEN = config.sops.secrets."acme/hetzner/${hostName}".path;
              email = email;
              extraDomainNames = [ "*.${hostName}" ];
              dnsProvider = "hetzner";
              group = "nginx";
              webroot = null;
            };
            sops.secrets."acme/hetzner/${hostName}".owner = "acme";
          };
      };
    };
  };
}
