{ config, pkgs, inputs, ... }:
let serverIcon = ./server-icon.png;
in {
  environment.systemPackages = with pkgs; [ mcrcon ];
  networking.firewall.allowedTCPPorts = [ 13914 ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  services.minecraft-servers = {
    enable = true;
    eula = true;
    # dataDir = "/mnt/ssd-01/minecraft";
    # dataDir = "/mnt/Datos/minecraft";
    environmentFile = config.sops.templates."minecraft.env".path;
    managementSystem = {
      tmux.enable = false;
      systemd-socket.enable = true;
    };
    servers.main = {
      enable = true;
      package = pkgs.paperServers.paper-1_21_6;
      enableReload = true;
      autoStart = false;
      jvmOpts =
        "-Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
      serverProperties = {
        difficulty = "hard";
        enable-rcon = true;
        enable-query = false;
        enforce-secure-profile = false;
        enforce-whitelist = true;
        hide-online-players = true;
        max-players = 10;
        motd = "NixOS server";
        online-mode = true;
        pvp = true;
        "rcon.password" = "@MINECRAFT_RCON_PASSWORD@";
        server-port = 13914;
        spawn-protection = 0;
        white-list = true;
      };
      symlinks = {
        "server-icon.png" = serverIcon;
        "plugins/EssentialsX.jar" = pkgs.fetchurl {
          url =
            "https://github.com/EssentialsX/Essentials/releases/download/2.21.1/EssentialsX-2.21.1.jar";
          hash = "sha256-Fd1/hxPmE6Hd6tp5LbZgqIyL9pAVvBPxqfnjf21Ez1o=";
        };
        "plugins/EssentialsX-Chat.jar" = pkgs.fetchurl {
          url =
            "https://github.com/EssentialsX/Essentials/releases/download/2.21.1/EssentialsXChat-2.21.1.jar";
          hash = "sha256-M3ThA5j5DI1qTdNw8OvLIprxRCD5q5ya/AfO5jGyU6Y=";
        };
        "plugins/TabTPS.jar" = pkgs.fetchurl {
          url =
            "https://cdn.modrinth.com/data/cUhi3iB2/versions/DlhrDe98/tabtps-spigot-1.3.27.jar";
          hash = "sha256-pWmcNKB0iAlVK4Ki5/vBOv8npOMyrUdxJ/7TbPXlpcI=";
        };
      };
      files = {
        "ops.json".value = [{
          name = "engullejamones";
          uuid = "b65a1bc3-c6a0-4e8c-99b8-3538cfec0cfc";
          level = 4;
          bypassesPlayerLimit = true;
        }];
        "whitelist.json".value = [{
          name = "engullejamones";
          uuid = "b65a1bc3-c6a0-4e8c-99b8-3538cfec0cfc";
        }];
        "plugins/TabTPS/display-configs/default.conf" = pkgs.writeTextFile {
          name = "tabtps-display-config.conf";
          text = ''
            action-bar-settings {
                allow=false
                enable-on-login=false
            }
            boss-bar-settings {
                allow=false
                enable-on-login=false
            }
            permission=""
            tab-settings {
                allow=true
                enable-on-login=true
                footer-modules="ping,tps,mspt,cpu,memory"
                header-modules=""
                separator="<br>"
                theme=default
            }
          '';
        };
      };
    };
  };
  sops = {
    secrets."minecraft_rcon".owner = "minecraft";
    templates."minecraft.env" = {
      content = ''
        MINECRAFT_RCON_PASSWORD=${config.sops.placeholder."minecraft_rcon"}
      '';
      owner = "minecraft";
    };
  };
  users.groups.minecraft.members = [ "avery" ];
}
