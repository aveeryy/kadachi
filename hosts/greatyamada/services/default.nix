{ ... }: {
  imports = [
    ./acme.nix
    ./ddclient.nix
    ./forgejo.nix
    ./jellyfin.nix
    ./minecraft
    ./nginx.nix
    ./postgresql.nix
    ./radicale.nix
    ./wireguard.nix
  ];
  # paperlessngx
}
