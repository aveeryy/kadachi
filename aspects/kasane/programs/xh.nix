{ ... }:
{
  kasane.programs._.xh.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ xh ];
    };
}
