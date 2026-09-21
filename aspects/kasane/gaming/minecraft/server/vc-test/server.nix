{ kadachi-lib, ... }:
{
  kasane.gaming._.minecraft._.server._.vc-test = { host }: {
    nixos = { pkgs, inputs', ... }: {
      services.minecraft-servers.servers.vc-test = {
        enable = true;
        autoStart = false;
        restart = "no";

        package = inputs'.nix-minecraft.legacyPackages.paperServers.paper-26_2;
        jvmOpts = "-Xmx512M -Xms512M -XX:+UseZGC -XX:+UseCompactObjectHeaders";

        whitelist = {
          inherit (kadachi-lib.minecraft.players)
            gbrii
            dankoszz
            Santos_H
            PableteOmg12
            MAGRADER
            Jeepic10
            Perichi2005
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
            url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/IhqyykOv/voicechat-bukkit-2.6.23.jar";
            sha512 = "3f01340bb29e03c0ba3ebb250b461bea6503a76544c9468fb228738a04fe9c21bfee83b5606e9b403c2b0587da9ad8d08687f6442e0dee392bf6010697641d96";
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
