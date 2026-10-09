{ kadachi-lib, ... }:
{
  adachi.services._.minecraft-server._.vc-test = { host }: {
    nixos = { pkgs, inputs', ... }: {
      services.minecraft-servers.servers.vc-test = {
        enable = true;
        autoStart = false;
        restart = "no";

        package = inputs'.nix-minecraft.legacyPackages.paperServers.paper-26_3;
        jvmOpts = "-Xmx512M -Xms512M -XX:+UseZGC -XX:+UseCompactObjectHeaders";

        whitelist = {
          inherit (kadachi-lib.minecraft.players)
            gbrii
            ;
        };
        operators = {
          inherit (kadachi-lib.minecraft.players)
            gbrii
            ;
        };

        serverProperties = {
          server-port = 55003;
          motd = "voice chat test server";
          white-list = true;
          level-type = "minecraft:flat";
          difficulty = "peaceful";
          gamemode = "adventure";
          online-mode = false;
          pause-when-empty-seconds = 60;
          spawn-protection = 0;
          view-distance = 5;
        };

        symlinks = {
          "plugins/voice-chat.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/EJth3OAr/voicechat-bukkit-2.6.24.jar";
            sha512 = "7f1d5765e79cd42616f14f40322d1171a8505e1116dfff71c7bd0e59af9d255c06f70a68a5b622015c0407d40c80e70298c172992007ff339cedcef0116fec42";
          };
        };

        files = {
          "config/paper-global.yml".value = {
            proxies.velocity = {
              enabled = true;
              secret = "@MINECRAFT_PROXY_FORWARDING_SECRET@";
            };
          };

          "plugins/voicechat/voicechat-server.properties".value = {
            port = 56003;
          };
        };
      };
    };
  };
}
