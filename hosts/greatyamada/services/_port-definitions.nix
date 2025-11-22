{
  tcp = {
    adguardhome = {
      dns = 53;
      http = 3001;
      https = 4430;
      dns_over_tls = 853;
    };
    flippydrive = {
      server = 7031;
      ftp = 7021;
    };
    forgejo = 3000;
    jellyfin = 8096;
    koito = 4110;
    minecraft = {
      fabric_prod = {
        server = 13914;
        bluemap = 8100;
      };
    };
    nginx = 443;
    pgadmin = 5050;
    postgresql = 5432;
    radicale = 5232;
    searxng = 8888;
    vaultwarden = 8222;
  };
  udp = {
    adguardhome = {
      dns = 53;
      dhcp = 67;
      dns_over_quic = 853;
    };
    wireguard = 51820;
  };
}
