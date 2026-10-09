{ kadachi-lib, ... }:
{
  adachi.services._.minecraft-server = { host }: {
    nixos = { pkgs, inputs', ... }: {
      services.minecraft-servers.servers.skyblock = {
        enable = true;
        autoStart = true;
        restart = "no";

        package = inputs'.nix-minecraft.legacyPackages.fabricServers.fabric-26_3.override ({
          jre_headless = pkgs.openjdk25_headless;
        });
        jvmOpts = "-Xmx2G -Xms2G -XX:+UseZGC -XX:+UseCompactObjectHeaders";

        whitelist = {
          inherit (kadachi-lib.minecraft.players)
            gbrii
            dankoszz
            ;
        };
        operators = {
          inherit (kadachi-lib.minecraft.players)
            gbrii
            ;
        };

        serverProperties = {
          server-port = 55001;
          motd = "Skyblock server";
          white-list = true;
          difficulty = "hard";
          gamemode = "survival";
          online-mode = false;
          spawn-protection = 0;
          view-distance = 32;
        };

        symlinks = {
          "mods/Fabric-API.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/v2j28coa/fabric-api-0.162.0%2B26.3.jar";
            sha512 = "5ab70908952f1d2346d16b122ca31327f4055db59c279a1bc3c3c581ce359bb541cba15730f55b0727be7c7c4debc4a4412a183c228e0d4dea81c734f7b412ce";
          };
          "mods/FabricProxy-Lite.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/CsEpiziv/FabricProxy-Lite-2.12.0.jar";
            sha512 = "b479c3ed1fe83929cad40e5c925ae2702da879b88a0271a24266cd21ecc037953f347cbe61ac7b7334e087544ee2ce5bf1f041fc3e64f50474404ad564c146f7";
          };
          "mods/Skyblock-Infinite.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/YVMr2l79/versions/OiLq671i/skyblock-infinite-1.1.18.jar";
            sha512 = "9b8414945eaa2c9724d76e1695e93ff168c7d369003c8c0831f7fa2a65d8eec172832b06c3a26f79fb8275d182fe3c2b26fcefb9d5c316d200c8bf3e3b88a477";
          };
        };

        files."config/FabricProxy-Lite.toml".value = {
          hackOnlineMode = false;
          secret = "@MINECRAFT_PROXY_FORWARDING_SECRET@";
        };
      };
    };
  };
}
