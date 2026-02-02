{ ... }:
{
  kasane.gaming._.steam = {
    nixos.programs.steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
    };
    homeManager.services.ludusavi.settings.roots = [
      {
        path = "~/.local/share/Steam";
        store = "steam";
      }
    ];
  };
}
