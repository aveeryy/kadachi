{ ... }: {
  imports = [
    ./acme.nix
    ./ddclient.nix
    ./forgejo.nix
    ./invidious
    ./jellyfin.nix
    ./minecraft
    ./nginx.nix
    ./postgresql.nix
    ./radicale.nix
    ./wireguard.nix
  ];
  # paperlessngx
}
