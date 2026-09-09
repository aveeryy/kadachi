{ ... }: {
  adachi.desktop._.default-applications.file-manager = desktopFile: {
    description = "Set the default file manager";
    homeManager.xdg.mimeApps.defaultApplications."inode/directory" = desktopFile;
  };
}
