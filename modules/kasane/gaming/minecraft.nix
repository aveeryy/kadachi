{ ... }:
{
  kasane.gaming._.minecraft.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ prismlauncher ];
    };
}
