{ lib, ... }:
let
  inherit (lib)
    generators
    join
    singleton
    ;
in
{
  kasane.programs._.pcmanfm-qt.homeManager =
    { config, pkgs, ... }:
    {
      home = {
        file.".config/pcmanfm-qt/default/settings.conf".text = generators.toINI { } {
          Behavior = {
            AutoSelectionDelay = 600;
            BookmarkOpenMethod = "current_tab";
            ConfirmDelete = true;
            ConfirmTrash = false;
            CtrlRightClick = false;
            NoUsbTrash = true;
            QuickExec = false;
            RecentFilesNumber = 0;
            SelectNewFiles = true;
            SingleClick = true;
            SingleWindowMode = false;
            UseTrash = true;
          };

          FolderView = {
            BackupAsHidden = false;
            BigIconSize = 48;
            Mode = "icon";
            NoItemTooltip = false;
            ScrollPerPixel = true;
            ShadowHidden = true;
            ShowFilter = false;
            ShowFullNames = true;
            ShowHidden = true;
            SidePaneIconSize = 24;
            SmallIconSize = 24;
            SortCaseSensitive = false;
            SortColumn = "name";
            SortFolderFirst = true;
            SortHiddenLast = false;
            SortOrder = "ascending";
            ThumbnailIconSize = 128;
          };

          Places.HiddenPlaces = join ", " [
            config.xdg.userDirs.desktop
            "menu://applications/"
            "network:///"
          ];

          System = {
            # TODO: modularize this
            Archiver = "lxqt-archiver";
            Terminal = "kitty";
          };

          Thumbnail = {
            MaxExternalThumbnailFileSize = -1;
            MaxThumbnailFileSize = 8192;
            ShowThumbnails = true;
            ThumbnailLocalFilesOnly = true;
          };

          Volume = {
            AutoRun = false;
            CloseOnUnmount = true;
            MountOnStartup = true;
            MountRemovable = true;
          };

          Window = {
            AlwaysShowTabs = false;
            PathBarButtons = true;
            ShowMenuBar = false;
            ShowTabClose = false;
            SidePaneMode = "places";
            SidePaneVisible = true;
            SplitView = false;
          };

        };
        packages = singleton pkgs.pcmanfm-qt;
      };
      wayland.windowManager.hyprland.settings.bind = singleton "SUPER, E, exec, pcmanfm-qt";
    };
}
