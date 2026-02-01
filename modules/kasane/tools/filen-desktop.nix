{ ... }:
{
  kasane.tools._.filen-desktop.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ filen-desktop ];
    };
}
