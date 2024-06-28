{ ... }: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "aveeryy@protonmail.com";
    certs."rcia.dev" = {
      credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE =
        "/run/secrets/cloudflare_api_token";
      dnsProvider = "cloudflare";
      extraDomainNames = [ "*.rcia.dev" ];
    };
  };
  sops.secrets."cloudflare/api_token" = {
    path = "/run/secrets/cloudflare_api_token";
    group = "root";
  };
}
