{ ... }:
{
  kasane.gaming._.minecraft.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ prismlauncher ];
      services.ludusavi.settings.customGames = [
        {
          files = [
            "~/.local/share/PrismLauncher/instances/*/minecraft/saves"
          ];
          name = "Minecraft";
        }
      ];
    };
}
