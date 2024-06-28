{ ... }: {
  imports = [
    ./nginx.nix
    ./forgejo.nix
    ./invidious.nix
    ./jellyfin.nix
    ./postgresql.nix
    ./radicale.nix
  ];
  # TODO: adguardhome matrix matrix-second minecraft terraria factorio coturn mautrix-whatsapp wireguard
  # paperlessngx
}
