{ lib, pkgs, ... }: {
  services.gpg-agent.pinentry.package = lib.mkForce pkgs.pinentry-curses;
}
