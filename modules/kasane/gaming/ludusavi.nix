{ ... }:
{
  kasane.gaming._.ludusavi = {
    homeManager =
      { config, ... }:
      {
        services = {
          ludusavi = {
            enable = true;
            backupNotification = true;
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
        };
      };
    provides.automatic-backup =
      { user, host, ... }:
      {
        description = "Provides automatic backups of ludusavi's using the system backup tool";

        nixos =
          { config, pkgs, ... }:
          {
            services.borgmatic.configurations."ludusavi-${user.userName}" = {
              source_directories = [
                (builtins.replaceStrings
                  [
                    "~"
                  ]
                  [
                    "/home/${user.userName}"
                  ]
                  config.home-manager.users."${user.userName}".services.ludusavi.settings.backup.path
                )
              ];
              repositories = host.services.backups.repositories "ludusavi-${user.userName}";
              commands = [
                {
                  before = "everything";
                  when = [ "check" ];
                  run = [
                    ''/run/wrappers/bin/su -c "${pkgs.ludusavi}/bin/ludusavi backup --force" -- ${user.userName}''
                  ];
                }
              ];
              encryption_passcommand = "cat /run/secrets/backups/password/ludusavi-${user.userName}";
              ssh_command = "ssh -p 23 -i ${config.sops.templates."backups_ssh_private_key".path}";
              keep_daily = 7;
            };
            sops.secrets."backups/password/ludusavi-${user.userName}".owner = "root";
            # Configuration requires sudo
            systemd.services.borgmatic.serviceConfig = {
              NoNewPrivileges = false;
              CapabilityBoundingSet = "CAP_DAC_READ_SEARCH CAP_NET_RAW CAP_SETUID CAP_SETGID";
            };
          };
      };
  };
}
