{ ... }:
{
  kasane.gaming._.ludusavi.homeManager.services.ludusavi = {
    enable = true;
    backupNotification = true;
    frequency = "*-*-* 23:00:00";
    settings = {
      backup = {
        filter = {
          excludeStoreScreenshots = true;
          ignoredPaths = [
            # Balatro mods
            "~/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/Mods"
            # Shader cache
            "**/shader_cache/*"
            "**/vulkan/pipelines.cache"
            "**/*.ushaderprecache"
            "**/*.upipelinecache"
            # Log files
            "**/*.log"
          ];
        };
        format = {
          chosen = "zip";
          compression.zstd.level = 10;
          zip.compression = "zstd";
        };
        path = "~/.local/state/backups/ludusavi";
      };
      restore.path = "~/.local/state/backups/ludusavi";
      theme = "dark";
    };
  };
}
