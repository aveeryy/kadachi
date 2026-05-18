{ kadachi-lib, ... }:
{
  kasane.gaming._.minecraft._.server =
    { host }:
    {
      nixos =
        {
          pkgs,
          config,
          lib,
          ...
        }:
        let
          inherit (lib) nameValuePair;
          inherit (lib.attrsets) mapAttrs mapAttrs';
          inherit (kadachi-lib) getAsset;
          inherit (kadachi-lib.minecraft) getActiveServers;

          servers = getActiveServers config.services.minecraft-servers.servers;
        in
        {
          services.minecraft-servers.servers.main-proxy = {
            enable = true;
            autoStart = true;
            restart = "always";
            package = pkgs.velocityServers.velocity;
            openFirewall = true;

            symlinks."server-icon.png" = getAsset "minecraft-server-icons/proxy.png";

            files."velocity.toml".value = {
              config-version = "2.7";
              bind = "0.0.0.0:25565";
              motd = "Servidor no disponible<br><#DDAACC>ᓚᘏᗢ miau";
              show-max-players = -1;

              online-mode = true;
              player-info-forwarding-mode = "modern";
              ping-passthrough = "all";
              forwarding-secret-file = config.sops.secrets."minecraft/proxy_forwarding_secret".path;

              servers = {
                try = [ ];
              }
              // mapAttrs (_: server: "127.0.0.1:${toString server.serverProperties.server-port}") servers;

              forced-hosts = mapAttrs' (
                name: _: nameValuePair ("${name}.mc.${host.services.baseDomain}") ([ name ])
              ) servers;

              advanced = {
                login-ratelimit = 0;
                tcp-fast-open = true;
              };
            };
          };
        };
    };
}
