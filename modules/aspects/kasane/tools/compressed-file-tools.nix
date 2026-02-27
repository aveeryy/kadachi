{ __findFile, ... }:
{
  kasane.tools._.compressed-file-tools = {
    includes = [
      (<adachi/desktop/default-applications/compressed-files> "lxqt-archiver.desktop")
    ];
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          lxqt.lxqt-archiver
          p7zip
          unrar
        ];
      };
  };
}
