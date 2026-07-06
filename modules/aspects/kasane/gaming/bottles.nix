{ ... }:
{
  kasane.gaming._.bottles.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bottles
        wineWow64Packages.stagingFull
      ];
    };
}
