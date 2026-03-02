{ ... }:
{
  kasane.gaming._.bottles.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (bottles.override { removeWarningPopup = true; })
        wineWow64Packages.stagingFull
      ];
    };
}
