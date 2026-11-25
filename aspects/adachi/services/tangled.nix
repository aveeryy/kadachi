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

  den.schema.host = mkHttpServiceOptions {
    name = "tangled-knot";
    subdomain = "knot";
  };

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
      };
    };
  };
}
