{ kadachi-lib, ... }:
{
  kasane.gaming._.ludusavi =
    { user, host }:
    {
      nixos =
        { config, pkgs, ... }:
        {
          imports = [
            (kadachi-lib.createBackupConfiguration "ludusavi-${user.userName}" host {
              source_directories = [
                config.home-manager.users."${user.userName}".services.ludusavi.settings.backup.path
              ];
              commands = [
                {
                  before = "configuration";
                  when = [ "check" ];
                  run = [
                    ''/run/wrappers/bin/su -c "${pkgs.ludusavi}/bin/ludusavi backup --force" -- ${user.userName}''
                  ];
                }
              ];
              keep_daily = 7;
            })
          ];
          # Configuration requires su permissions
          systemd.services.borgmatic.serviceConfig = {
            NoNewPrivileges = false;
            CapabilityBoundingSet = "CAP_DAC_READ_SEARCH CAP_NET_RAW CAP_SETUID CAP_SETGID";
          };
        };

      homeManager =
        { config, lib, ... }:
        {
          services.ludusavi = {
            enable = true;
            backupNotification = true;
            settings = {
              backup = {
                filter = {
                  excludeStoreScreenshots = true;
                  ignoredPaths = [
                    # Balatro mods
                    "**/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/Mods"
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
                path = lib.mkDefault "${config.home.homeDirectory}/.local/state/backups/ludusavi";
              };
              restore.path = lib.mkDefault "${config.home.homeDirectory}/.local/state/backups/ludusavi";
              theme = "dark";
            };
          };
          # Backups are automatically managed by Borgmatic, disable the systemd timer
          systemd.user.timers.ludusavi = lib.mkForce { };
        };
    };
}
