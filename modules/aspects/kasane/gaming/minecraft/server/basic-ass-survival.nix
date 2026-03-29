{ den, kadachi-lib, ... }:
{
  kasane.gaming._.minecraft._.server = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { pkgs, ... }:
        {
          services.minecraft-servers.servers.basic-survival = {
            enable = true;
            autoStart = true;
            restart = "no";
            package = pkgs.paperServers.paper-1_21_8;
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
              server-port = 55001;
              motd = "Survival server";
              white-list = true;
              difficulty = "peaceful";
              gamemode = "survival";
              online-mode = false;
            };
            files."config/paper-global.yml".value = {
              proxies.velocity = {
                enabled = true;
                secret = "@MINECRAFT_PROXY_FORWARDING_SECRET@";
              };
            };
          };
        };
    }
  );

}
