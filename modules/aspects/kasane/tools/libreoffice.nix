{ ... }:
{
  kasane.tools._.libreoffice.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ libreoffice-qt ];
    };
}
