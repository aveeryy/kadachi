{ ... }:
{
  # TODO: allow configuration of ips and other stuff
  kasane.services._.adguardhome =
    { host, ... }:
    {
      nixos =
        { config, lib, ... }:
        {
          networking.firewall =
            let
              tlsEnabled = config.services.adguardhome.settings.tls.enabled;
              tlsTcpPorts = lib.optional (tlsEnabled) config.services.adguardhome.settings.tls.port_dns_over_tls;
              tlsUdpPorts = lib.optional (tlsEnabled) config.services.adguardhome.settings.tls.port_dns_over_quic;
              dhcpPorts = lib.optional (config.services.adguardhome.settings.dhcp.enabled) 67;
            in
            {
              allowedTCPPorts = [ config.services.adguardhome.port ] ++ tlsTcpPorts;
              allowedUDPPorts = [ config.services.adguardhome.settings.dns.port ] ++ tlsUdpPorts ++ dhcpPorts;
            };
          services = {
            adguardhome = {
              enable = true;
              port = 3001;
              settings = {
                http = {
                  address = "127.0.0.1:${toString config.services.adguardhome.port}";
                  session_ttl = "720h";
                };
                dns = {
                  bind_hosts = [ "10.0.0.1" ];
                  port = 53;
                  anonymize_client_ip = false;
                  ratelimit = 0;
                  upstream_dns = [
                    "tls://1.1.1.1"
                    "https://dns10.quad9.net/dns-query"
                  ];
                  bootstrap_dns = [
                    "9.9.9.10"
                    "1.1.1.1"
                    "1.0.0.1"
                  ];
                };
                tls = {
                  enabled = true;
                  server_name = "dns.${host.services.baseHost}";
                  port_https = 4430;
                  port_dns_over_tls = 853;
                  port_dns_over_quic = 853;
                  certificate_path = "/var/lib/acme/${host.services.baseHost}/fullchain.pem";
                  private_key_path = "/var/lib/acme/${host.services.baseHost}/key.pem";
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
                filtering = {
                  safe_search.enabled = false;
                  filtering_enabled = true;
                  parental_enabled = false;
                  safebrowsing_enabled = false;
                  protection_enabled = true;
                  cache_time = 30;
                  filters_update_interval = 24;
                  rewrites = [
                    {
                      domain = host.services.baseHost;
                      answer = "10.0.0.1";
                    }
                    {
                      domain = "*.${host.services.baseHost}";
                      answer = "10.0.0.1";
                    }
                  ];
                };
                clients = {
                  runtime_sources = {
                    whois = true;
                    arp = true;
                    rdns = true;
                    dhcp = true;
                    hosts = true;
                  };
                  persistent = [
                    {
                      name = "Decodificador";
                      ids = [ "10.0.0.200" ];
                      tags = [ "device_tv" ];
                      upstreams = [ "172.26.23.3" ];
                      use_global_settings = true;
                    }
                    {
                      name = "Poco X3";
                      ids = [ "10.0.0.202" ];
                      tags = [ "device_phone" ];
                      use_global_settings = false;
                      filtering_enabled = false;
                    }
                    {
                      name = "Tablet Samsung";
                      ids = [ "10.0.0.201" ];
                      tags = [ "device_tablet" ];
                      use_global_settings = false;
                      filtering_enabled = false;
                    }
                  ];
                };
                filters = [
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
                    name = "AdGuard DNS filter";
                    id = 1;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
                    name = "AdAway Default Blocklist";
                    id = 2;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_23.txt";
                    name = "WindowsSpyBlocker - Hosts spy rules";
                    id = 1687062393;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_6.txt";
                    name = "Dandelion Sprout's Game Console Adblock List";
                    id = 1687062394;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt";
                    name = "Phishing URL Blocklist (PhishTank and OpenPhish)";
                    id = 1687062395;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt";
                    name = "Perflyst and Dandelion Sprout's Smart-TV Blocklist";
                    id = 1687062396;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt";
                    name = "Dandelion Sprout's Anti-Malware List";
                    id = 1687062397;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt";
                    name = "Scam Blocklist by DurableNapkin";
                    id = 1687062398;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt";
                    name = "The Big List of Hacked Malware Web Sites";
                    id = 1687062399;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
                    name = "Steven Black's List";
                    id = 1687062400;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt";
                    name = "Dan Pollock's List";
                    id = 1687062401;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
                    name = "Malicious URL Blocklist (URLHaus)";
                    id = 1687062402;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt";
                    name = "Peter Lowe's Blocklist";
                    id = 1687062403;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_32.txt";
                    name = "The NoTracking blocklist";
                    id = 1687062404;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_31.txt";
                    name = "Stalkerware Indicators List";
                    id = 1694924469;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt";
                    name = "HaGeZi's Threat Intelligence Feeds";
                    id = 1694924470;
                  }
                  {
                    enabled = true;
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt";
                    name = "NoCoin Filter List";
                    id = 1694924471;
                  }
                ];
                user_rules = [
                  "||www.googleadservices.com^$important"
                  "||rdvs.alljoyn.org^$important"
                  "||safebrowsing.google.com^$client='10.0.0.28'"
                  "||fm.nvc.heil.nuancemobility.net^$client='10.0.0.230'"
                  "@@||npdl.cdn.nintendowifi.net^$important"
                  "||tse3.mm.bing.net^$important"
                  "@@||repo.webosbrew.org^$important"
                  "||es.lgeapi.com^$important"
                  "||discovery.meethue.com^$important"
                  "||eic.lgtviot.com^$important"
                  "||qs2-nevoai-iothub-02-prod.azure-devices.net^$important"
                  "||snu.lge.com^$important"
                  "||su.lge.com^$important"
                  "||su-ssl.lge.com^$important"
                  "||snu-dev.lge.com^$important"
                  "||su-dev.lge.com^$important"
                  "||nsu.lge.com^$important"
                  "||eic.commonpush.lgtviot.com^$important"
                  "||eic.sports.lgtviot.com^$important"
                  "||es.lgtvsdp.com^$important"
                  "||prod-ripcut-delivery.disney-plus.net^$client='TV'"
                  "||ngfts.lge.com^$important"
                  "||lgtvonline.lge.com^$important"
                  "||www.ueiwsp.com^$important"
                  "||temu.com^$important"
                  "||www.temu.com^$important"
                  "@@||unity3d.com^$client='10.0.0.7'"
                  "@@||config.ads.vungle.com^$client='10.0.0.7'"
                  "@@||rayjump.com^$client='10.0.0.7'"
                  "@@||vungle.com^$client='10.0.0.7'"
                  "@@||mtgglobals.com^$client='10.0.0.7'"
                  "@@||fundingchoicesmessages.google.com^$client='10.0.0.7'"
                  "@@||applovin.com^$client='10.0.0.7'"
                  "@@||rovio.com^$client='10.0.0.7'"
                  "@@||gov.aniview.com^$client='10.0.0.7'"
                  "@@||unity3d.com^$client='10.10.0.3'"
                  "@@||config.ads.vungle.com^$client='10.10.0.3'"
                  "@@||rayjump.com^$client='10.10.0.3'"
                  "@@||vungle.com^$client='10.10.0.3'"
                  "@@||mtgglobals.com^$client='10.10.0.3'"
                  "@@||fundingchoicesmessages.google.com^$client='10.10.0.3'"
                  "@@||googleads.g.doubleclick.net^$client='10.10.0.3'"
                  "@@||applovin.com^$client='10.10.0.3'"
                  "@@||rovio.com^$client='10.10.0.3'"
                  "@@||gov.aniview.com^$client='10.10.0.3'"
                  "@@||cdn.liftoff-creatives.io^$client='10.0.0.7'"
                  "||googleads.g.doubleclick.net^$client='Tablet'"
                ];
              };
            };
            nginx.virtualHosts."dns.${host.services.baseHost}" =
              let
                port =
                  if config.services.adguardhome.settings.tls.enabled then
                    config.services.adguardhome.settings.tls.port_https
                  else
                    config.services.adguardhome.port;
              in
              {
                forceSSL = true;
                locations."/".proxyPass = "https://127.0.0.1:${toString port}";
                extraConfig = host.services.nginx.localServiceConfig;
                useACMEHost = host.services.baseHost;
              };
          };
        };
    };
}
