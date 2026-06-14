{ kadachi-lib, ... }:
{
  kasane.gaming._.minecraft._.server =
    { host }:
    {
      nixos =
        { pkgs, ... }:
        {
          services.minecraft-servers.servers.skyblock = {
            enable = true;
            autoStart = true;
            restart = "no";
            package = pkgs.fabricServers.fabric-26_1_2.override ({
              jre_headless = pkgs.openjdk25_headless;
            });
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
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/yALY9gHM/fabric-api-0.151.0%2B26.1.2.jar";
                sha512 = "d087349842b962414ba89248f9ef7bc75f537848f4d783435de633ddae8924cd50fd9bffc606aae0f1c2c3ed9b4339623244e1fd34c6b9c17f977528d1303cdd";
              };
              "mods/FabricProxy-Lite.jar" = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/CsEpiziv/FabricProxy-Lite-2.12.0.jar";
                sha512 = "b479c3ed1fe83929cad40e5c925ae2702da879b88a0271a24266cd21ecc037953f347cbe61ac7b7334e087544ee2ce5bf1f041fc3e64f50474404ad564c146f7";
              };
              "mods/Skyblock-Infinite.jar" = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/YVMr2l79/versions/7s07Rlsc/skyblock-infinite-1.1.14.jar";
                sha512 = "52c030f41e6c3192846c5b54e06d1da173ed27a6fe29264fb7653248fa087eb9befb00bb0f115875cc159bffb84d2e82cb385d41b892a1877829fa6f0b133ed5";
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
