{ ... }:
{
  adachi.services._.acme = {
    nixos.security.acme.acceptTerms = true;
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
    };
  };
}
