{ ... }:
{
  kasane.gaming._.steam.nixos.programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
  };
}
