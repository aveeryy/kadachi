{ config, lib, pkgs, inputs, ... }:
let
  serverIcon = ./server-icon.png;
  players = import ./players.nix;
  ports = import ../_port-definitions.nix;
  packageNameToHumanString = packageName:
    (let
      getSections = packageName:
        # Probably only matches Fabric servers, change as needed
        builtins.match
        "^minecraft-server-([0-9a-zA-Z.]*)-([a-zA-Z-]*)-([0-9a-zA-Z.]*)$"
        packageName;
      sections = (getSections packageName);
      getSection = idx:
        if sections == null then "Unknown" else builtins.elemAt sections idx;
    in "Minecraft ${getSection 0} with ${
      lib.strings.toSentenceCase (getSection 1)
    } ${getSection 2}");
  playersToOps = players:
    map (player: {
      name = player.name;
      uuid = player.uuid;
      level = 4;
      bypassesPlayerLimit = true;
    }) players;
  portsToOpen = map (server: server.serverProperties.server-port)
    (lib.attrValues (lib.filterAttrs (_: server: server.enable)
      config.services.minecraft-servers.servers));
in {
  environment.systemPackages = with pkgs; [ mcrcon ];
  networking.firewall.allowedTCPPorts = portsToOpen;
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  services = {
    minecraft-servers = {
      enable = true;
      eula = true;
      dataDir = "/mnt/ssd-01/minecraft";
      environmentFile = config.sops.templates."minecraft.env".path;
      managementSystem = {
        tmux.enable = false;
        systemd-socket.enable = true;
      };
      servers.fabric_prod = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_8;
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
          motd = "${
              packageNameToHumanString
              config.services.minecraft-servers.servers.fabric_prod.package.name
            } on ${config.networking.hostName}";
          online-mode = true;
          pause-when-empty-seconds = 60;
          pvp = true;
          "rcon.password" = "@MINECRAFT_RCON_PASSWORD@";
          server-port = ports.tcp.minecraft.fabric_prod.server;
          simulation-distance = 10;
          spawn-protection = 0;
          view-distance = 10;
          white-list = true;
        };
        symlinks = {
          "server-icon.png" = serverIcon;
          "mods/Fabric-API.jar" = pkgs.fetchurl {
            url =
              "https://cdn.modrinth.com/data/P7dR8mSH/versions/X2hTodix/fabric-api-0.129.0%2B1.21.8.jar";
            sha512 =
              "471babff84b36bd0f5051051bc192a97136ba733df6a49f222cb67a231d857eb4b1c5ec8dea605e146f49f75f800709f8836540a472fe8032f9fbd3f6690ec3d";
          };
          "mods/Ferrite-Core.jar" = pkgs.fetchurl {
            url =
              "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
            sha512 =
              "131b82d1d366f0966435bfcb38c362d604d68ecf30c106d31a6261bfc868ca3a82425bb3faebaa2e5ea17d8eed5c92843810eb2df4790f2f8b1e6c1bdc9b7745";
          };
          "mods/Lithium.jar" = pkgs.fetchurl {
            url =
              "https://cdn.modrinth.com/data/gvQqBUqZ/versions/pDfTqezk/lithium-fabric-0.18.0%2Bmc1.21.8.jar";
            sha512 =
              "6c69950760f48ef88f0c5871e61029b59af03ab5ed9b002b6a470d7adfdf26f0b875dcd360b664e897291002530981c20e0b2890fb889f29ecdaa007f885100f";
          };
          "mods/Krypton.jar" = pkgs.fetchurl {
            url =
              "https://cdn.modrinth.com/data/fQEb0iXm/versions/neW85eWt/krypton-0.2.9.jar";
            sha512 =
              "2e2304b1b17ecf95783aee92e26e54c9bfad325c7dfcd14deebf9891266eb2933db00ff77885caa083faa96f09c551eb56f93cf73b357789cb31edad4939ffeb";
          };
          "mods/spark.jar" = pkgs.fetchurl {
            url =
              "https://cdn.modrinth.com/data/l6YH9Als/versions/qW2mPW6y/spark-1.10.139-fabric.jar";
            sha512 =
              "cd991acee93c074912f2934b5a9c3967be2f1e9157ca5a7254fd3fce8d280c5aa9a3ab06d3ee19f06c5111181853cf12048d000bf8b9f722c902c080fe258a97";
          };
          "mods/BlueMap.jar" = pkgs.fetchurl {
            url =
              "https://cdn.modrinth.com/data/swbUV1cr/versions/fB6f4XRA/bluemap-5.9-fabric.jar";
            sha512 =
              "a76a2b1019efe35175f8df91f69ec7ec58e26f148ea9bba4f1eb9bb1b16ffa6f395b76c1362f452d33f94f0f1045403da3b04f25bc6d40feadbc58f64d34f1e4";
          };
          "mods/TabTPS.jar" = pkgs.fetchurl {
            url =
              "https://cdn.modrinth.com/data/cUhi3iB2/versions/w0oIAEFo/tabtps-fabric-mc1.21.8-1.3.28.jar";
            sha512 =
              "b29e19114efdadeadf5fedbf5b743aa35f36ab6fa8c32a1cbaa6591106677a3163801ba8010142899822298fefebb9621aa5db54db49ecc58719b7ef5dcbde85";
          };
          "mods/DiscordIntegration.jar" = pkgs.fetchurl {
            url =
              "https://cdn.modrinth.com/data/rbJ7eS5V/versions/JOLMTAVo/dcintegration-fabric-MC1.21.6-3.1.0.1.jar";
            sha512 =
              "fbb6bdf5b6461db1018d1b7a6c5eb8ba42cd09035c304aad389f1a1877514b71fd9c87344ef05ad92efe342b4288292fc10b234bf53f5168f3943b3c0cae2504";
          };
        };
        files = {
          "ops.json".value = playersToOps (with players; [ engullejamones ]);
          "whitelist.json".value = with players; [
            engullejamones
            dankoszz
            Santos_H
            PableteOmg12
          ];
          "config/TabTPS/display-configs/default.conf" = pkgs.writeTextFile {
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
                  footer-modules="ping,mspt"
                  header-modules=""
                  separator="<br>"
                  theme=default
              }
            '';
          };
          "config/Discord-Integration.toml".value = {
            general = {
              botToken = "@MINECRAFT_DISCORD_BOT@";
              botChannel = "1320828973499809893";
              botStatusName = "%online% personas en línea";
              botStatusNameSingular = "1 persona en línea";
              botStatusNameEmpty = "0 personas en línea";
            };
            votifier.enabled = false;
            webhook = {
              enable = true;
              serverName = "Servidor de Minecraft";
            };
          };
        };
      };
    };
    nginx.virtualHosts."minecraft.rcia.dev" = {
      extraConfig = "gzip_static always;";
      locations = {
        "/".return = "307 $scheme://$host/fabric_prod/";
        "/fabric_prod".return = "308 $scheme://$host/fabric_prod/";
        "/fabric_prod/" = {
          alias =
            "${config.services.minecraft-servers.dataDir}/fabric_prod/bluemap/web/";
          extraConfig = "error_page 404 = @no-content;";
        };
        "~* ^/fabric_prod/(maps/[^/\\s]*/live/.*)" = {
          proxyPass = "http://127.0.0.1:${
              toString ports.tcp.minecraft.fabric_prod.bluemap
            }/$1";
          extraConfig = ''
            error_page 502 504 = @server-offline;
          '';
        };
        "@no-content" = {
          return = "204";
          extraConfig = "internal;";
        };
        "@server-offline" = {
          root =
            "${config.services.minecraft-servers.dataDir}/fabric_prod/bluemap/web";
          tryFiles = "$uri =410";
          extraConfig = "internal;";
        };
      };
      forceSSL = true;
      useACMEHost = "rcia.dev";
    };
  };
  sops = {
    secrets."minecraft/rcon".owner = "minecraft";
    secrets."minecraft/discord_bot".owner = "minecraft";
    templates."minecraft.env" = {
      content = ''
        MINECRAFT_RCON_PASSWORD=${config.sops.placeholder."minecraft/rcon"}
        MINECRAFT_DISCORD_BOT=${config.sops.placeholder."minecraft/discord_bot"}
      '';
      owner = "minecraft";
    };
  };
  users.groups.minecraft.members = [ "avery" "nginx" ];
}
