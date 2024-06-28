{ pkgs, ... }: {
  services.coturn = {
    enable = true;
    realm = "rcia.dev";
    min-port = 49152;
    max-port = 49200;
    use-auth-secret = true;
    static-auth-secret-file = "/run/turnserver/auth_secret"
    extraConfig = ''
      syslog
      no-rfc5780
      no-stun-backward-compatibility
      response-origin-only-with-rfc5780 
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      no-multicast-peers
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255
      allowed-peer-ip=10.0.0.1
      allowed-peer-ip=10.10.0.1
      allowed-peer-ip=10.10.0.2
      allowed-peer-ip=10.10.0.3
      user-quota=16
      total-quota=128
    '';
  };
  sops.secrets."coturn/static_auth_secret" = {
    path = "/run/turnserver/auth_secret";
    owner = "turnserver";
  };
}
