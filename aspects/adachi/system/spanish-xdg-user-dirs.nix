{ lib, ... }:
{
  adachi.system._.spanish-xdg-user-dirs = {
    description = "Set home-manager.xdg.userDirs directories to Spanish";

    homeManager =
      { config, ... }:
      {
        xdg.userDirs = {
          desktop = lib.mkDefault "${config.home.homeDirectory}/Escritorio";
          documents = lib.mkDefault "${config.home.homeDirectory}/Documentos";
          download = lib.mkDefault "${config.home.homeDirectory}/Descargas";
          music = lib.mkDefault "${config.home.homeDirectory}/Música";
          pictures = lib.mkDefault "${config.home.homeDirectory}/Imágenes";
          projects = lib.mkDefault "${config.home.homeDirectory}/Proyectos";
          publicShare = lib.mkDefault "${config.home.homeDirectory}/Público";
          templates = lib.mkDefault "${config.home.homeDirectory}/Plantillas";
          videos = lib.mkDefault "${config.home.homeDirectory}/Vídeos";
        };
      };
  };
}
