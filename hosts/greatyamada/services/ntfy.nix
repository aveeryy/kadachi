{ ... }:
let ports = import ./_port-definitions.nix;
in {
  services = {
    ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.rcia.dev";
        auth-file = "/etc/ntfy-users.db";
        auth-default-access = "deny-all";
      };
    };
    nginx.virtualHosts."ntfy.rcia.dev" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString ports.ntfy-http}";
        recommendedProxySettings = true;
      };
    };
  };
}
