{ __findFile, ... }:
{
  kasane.programs._.compressed-file-tools = {
    includes = [
      (<kasane/desktop/default-applications/compressed-files> "lxqt-archiver.desktop")
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
