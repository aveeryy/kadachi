{ ... }: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "aveeryy@protonmail.com";
    certs."rcia.dev" = {
      credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE = "/run/secrets/acme_token";
      extraDomainNames = [ "*.rcia.dev" ];
      dnsProvider = "cloudflare";
      group = "nginx";
      webroot = null;
    };
  };
  sops.secrets."acme_token".group = "acme";
}
