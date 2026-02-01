{ ... }:
{
  kasane.gaming._.heroic.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ heroic ];
    };
}
