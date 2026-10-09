{ kadachi-lib, ... }:
{
  adachi.services._.minecraft-server._.bccg-2026 = { host }: {
    nixos = { pkgs, inputs', ... }: {
      services.minecraft-servers.servers.bccg-2026 = {
        enable = true;
        autoStart = true;
        restart = "no";

        package = inputs'.nix-minecraft.legacyPackages.paperServers.paper-26_3;
        jvmOpts = "-Xmx3G -Xms3G -XX:+UseZGC -XX:+UseCompactObjectHeaders";

        whitelist = {
          inherit (kadachi-lib.minecraft.players)
            gbrii
            dankoszz
            Santos_H
            PableteOmg12
            MAGRADER
            Jeepic10
            Perichi2005
            DemocleTH
            AngelMT9
            ;
        };
        operators = {
          inherit (kadachi-lib.minecraft.players)
            gbrii
            ;
        };

        serverProperties = {
          server-port = 55002;
          motd = "miau";
          white-list = true;
          difficulty = "hard";
          gamemode = "survival";
          online-mode = false;
          pause-when-empty-seconds = 60;
          simulation-distance = 8;
          spawn-protection = 0;
          view-distance = 10;
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
            unsupported-settings = {
              allow-headless-pistons = true;
              allow-permanent-block-break-exploits = true;
              allow-piston-duplication = true;
            };
            update-checker.enabled = false;
          };

          "config/paper-world-defaults.yml".value = {
            anticheat.anti-xray.enabled = true;
          };

          "plugins/voicechat/voicechat-server.properties".value = {
            port = 56002;
          };
        };
      };
    };
  };
}
