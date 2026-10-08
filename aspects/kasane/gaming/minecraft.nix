{ ... }:
{
  kasane.gaming._.minecraft.homeManager =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [ prismlauncher ];
      services.ludusavi.settings.customGames = [
        {
          files = [
            "${config.home.homeDirectory}/.local/share/PrismLauncher/instances/*/minecraft/saves"
          ];
          name = "Minecraft";
        }
      ];
    };
}
