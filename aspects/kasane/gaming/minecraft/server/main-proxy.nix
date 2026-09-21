{
  kadachi-lib,
  ...
}:
{
  kasane.gaming._.minecraft._.server =
    { host }:
    {
      nixos =
        {
          pkgs,
          config,
          lib,
          inputs',
          ...
        }:
        let
          inherit (lib) nameValuePair singleton;
          inherit (lib.attrsets) mapAttrs mapAttrs';
          inherit (kadachi-lib) getAsset;
          inherit (kadachi-lib.minecraft) getActiveServers;

          servers = getActiveServers config.services.minecraft-servers.servers;
        in
        {
          networking.firewall.allowedUDPPorts = singleton 61337;

          services.minecraft-servers.servers.main-proxy = {
            enable = true;
            autoStart = true;
            restart = "always";
            package = inputs'.nix-minecraft.packages.velocity-server.override ({
              jre_headless = pkgs.openjdk25_headless;
            });
            openFirewall = true;

            symlinks = {
              "plugins/voice-chat.jar" = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/ES87t4lm/voicechat-velocity-2.6.18.jar";
                sha512 = "ca8238c3f4d8c0f023912373f6dfe932961fcd83b061c70941b83cf29421d969c65d1771a4ebd7d1e5804057ae8fb92069fbc64a8e66668da119033e0e7ac3cf";
              };
              "server-icon.png" = getAsset "minecraft-server-icons/proxy.png";
            };

            files = {
              "velocity.toml".value = {
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
                  name: _: nameValuePair ("${name}.mc.${host.services.internetDomain}") ([ name ])
                ) servers;

                advanced = {
                  login-ratelimit = 0;
                  tcp-fast-open = true;
                };
              };
              "plugins/voicechat/voicechat-proxy.properties" = builtins.toFile "voicechat-server.properties" ''
                port=61337
              '';
            };
          };
        };
    };
}
