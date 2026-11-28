{
  inputs,
  kadachi-lib,
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    singleton
    ;

  inherit (kadachi-lib)
    recursiveMerge
    ;

  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;

  inherit (kadachi-lib.constants)
    atproto
    ;

in
{
  flake-file.inputs.tangled.url = "git+https://tangled.org/did:plc:j5hmlfdrwkvtxm7cjmu7j2is";

  den.schema.host =
    { host, ... }@ctx:
    recursiveMerge [
      (mkHttpServiceOptions {
        name = "tangled-knot";
        subdomain = "knot";
      } ctx)
      (mkHttpServiceOptions {
        name = "tangled-spindle";
        subdomain = "spindle";
      } ctx)
    ];

  adachi.services._.tangled = {
    provides = {

      knot = { host }: {
        nixos = { config, ... }: {
          imports = singleton inputs.tangled.nixosModules.knot-rs;

          services = {
            tangled.knot-rs = {
              enable = true;
              environmentFile = config.sops.templates."tangled_knot.env".path;
              openFirewall = false;
              settings = {
                server = {
                  hostname = host.services.tangled-knot.domains.internet;
                  admins = mkDefault (singleton atproto.did);
                  ssh_listen_addr = "0.0.0.0:1337";
                };
                atproto = {
                  inherit (atproto) plc_directory;
                };
                contact.email = host.services.email;
                git.object_format = "sha1";
                xrpc = {
                  trustedProxyHeader = "x-forwarded-for";
                  trustedProxies = [
                    "127.0.0.1"
                    "::1"
                  ];
                };
              };
            };

            nginx = mkNginxConfiguration host host.services.tangled-knot {
              locations."/" = {
                proxyPass = "http://${config.services.tangled.knot-rs.settings.server.listen_addr}";
                proxyWebsockets = true;
              };
            };
          };

          sops = {
            secrets."tangled/knot/master_key" = { };
            templates."tangled_knot.env" = {
              content = ''
                KNOT_MASTER_KEY=${config.sops.placeholder."tangled/knot/master_key"}
              '';
              owner = config.services.tangled.knot-rs.user;
            };
          };
        };

        monitoredServices = singleton ({
          name = "Tangled Knot";
          config = host.services.tangled-knot;
        });
      };

      spindle = { host }: {
        nixos = { config, inputs', ... }: {
          imports = singleton inputs.tangled.nixosModules.spindle;

          services = {
            tangled.spindle = {
              enable = true;
              server = {
                hostname = host.services.tangled-spindle.domains.internet;
                owner = atproto.did;
                listenAddr = "127.0.0.1:6555";
              };
              keyPath = config.sops.secrets."tangled/spindle/key".path;
              contact.email = host.services.email;
            };

            nginx = mkNginxConfiguration host host.services.tangled-spindle {
              locations."/" = {
                proxyPass = "http://${config.services.tangled.spindle.server.listenAddr}";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_buffering off;
                  proxy_read_timeout 1h;
                '';
              };
            };
          };

          sops.secrets."tangled/spindle/key" = {
            sopsFile = "${inputs.secrets}/${host.name}/tangled/spindle-key.pem";
            format = "binary";
          };

          systemd.tmpfiles.rules = [
            "L+ /var/lib/spindle/images/nixos - - - - ${inputs'.tangled.packages.spindle-nixos-image}"
          ];
        };

        monitoredServices = singleton ({
          name = "Tangled Spindle";
          config = host.services.tangled-spindle;
        });
      };
    };
  };
}
