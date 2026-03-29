{ den, kadachi-lib, ... }:
{
  kasane.gaming._.minecraft._.server = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { pkgs, ... }:
        {
          services.minecraft-servers.servers.basic-creative = {
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
              server-port = 55002;
              motd = "Creative server";
              white-list = true;
              difficulty = "peaceful";
              level-type = "flat";
              gamemode = "creative";
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
