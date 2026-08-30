{ ... }:
{
  kasane.gaming._.heroic.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ heroic ];
      services.ludusavi.settings.roots = [
        {
          path = "~/.config/heroic";
          store = "heroic";
        }
      ];
    };
}
