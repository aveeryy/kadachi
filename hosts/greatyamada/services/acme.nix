{ ... }: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "aveeryy@protonmail.com";
    # Temporarily use staging server for testing
    defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    certs."rcia.dev" = {
      credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE =
        "/run/secrets/cloudflare_api_token";
      dnsProvider = "cloudflare";
      group = "nginx";
    };
  };
  sops.secrets."cloudflare/api_token" = {
    path = "/run/secrets/cloudflare_api_token";
    group = "root";
  };
}
