{ ... }:
{
  adachi.desktop._.default-applications._.compressed-files = desktopFile: {
    description = "Set the default application for opening some compressed formats";
    # Reference list: https://en.wikipedia.org/wiki/List_of_archive_formats
    # Updated as of 2026-01-04
    homeManager.xdg.mimeApps.defaultApplications = {
      "application/zip" = desktopFile;
      "application/x-tar" = desktopFile;
      "application/x-bzip2" = desktopFile;
      "application/gzip" = desktopFile;
      "application/lzip" = desktopFile;
      "application/x-7z-compressed" = desktopFile;
      "application/x-rar-compressed" = desktopFile;
      "application/x-gtar" = desktopFile;
    };
  };
}
