{ kadachi-lib, ... }:
{
  kasane.gaming._.minecraft._.server._.bccg-2026 = { host }: {
    nixos = { pkgs, inputs', ... }: {
      services.minecraft-servers.servers.bccg-2026 = {
        enable = true;
        autoStart = true;
        restart = "no";
        package = inputs'.nix-minecraft.legacyPackages.paperServers.paper-26_2;
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
          spawn-protection = 0;
          view-distance = 8;
        };
        files = {
          "config/paper-global.yml".value = {
            proxies.velocity = {
              enabled = true;
              secret = "@MINECRAFT_PROXY_FORWARDING_SECRET@";
            };
          };
        };
      };
    };
  };
}
