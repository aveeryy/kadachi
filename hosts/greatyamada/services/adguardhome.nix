{ ... }:
let
  portDefinitions = import ./_port-definitions.nix;
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
in {
  networking.firewall.allowedTCPPorts = [ portDefinitions.adguardhome-dns ];
  networking.firewall.allowedUDPPorts = [ portDefinitions.adguardhome-dns ];
  services = {
    adguardhome = {
      enable = true;
      allowDHCP = true;
      port = portDefinitions.adguardhome-http;
      mutableSettings = true;
      settings = {
        http = {
          address = "127.0.0.1:${toString portDefinitions.adguardhome-http}";
          session_ttl = "1440h";
        };
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          port = portDefinitions.adguardhome-dns;
          anonymize_client_ip = false;
          ratelimit = 0;
          upstream_dns = [ "https://dns10.quad9.net/dns-query" ];
          bootstrap_dns =
            [ "9.9.9.10" "149.112.112.10" "2620:fe::10" "2620:fe::fe:10" ];
        };
        dhcp = {
          enabled = true;
          interface_name = "enp5s0";
          local_domain_name = "lan";
          dhcpv4 = {
            gateway_ip = "10.0.0.254";
            subnet_mask = "255.255.255.0";
            range_start = "10.0.0.10";
            range_end = "10.0.0.199";
            lease_duration = 86400;
            icmp_timeout_msec = 1000;
          };
        };
      };
    };
    nginx.virtualHosts."dns.rcia.dev" = {
      locations."/".proxyPass =
        "http://127.0.0.1:${toString portDefinitions.adguardhome-http}";
      extraConfig = nginxLocalServiceConfig;
    };
  };
}
