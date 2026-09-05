{
  inputs,
  kadachi-lib,
  lib,
  ...
}:
let
  inherit (lib)
    genAttrs
    genAttrs'
    mkOption
    nameValuePair
    singleton
    ;

  inherit (lib.types)
    listOf
    str
    ;

  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  flake-file.inputs.copyparty = {
    url = "github:9001/copyparty/v1.20.14";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.schema.host = mkHttpServiceOptions {
    name = "copyparty";
    options = { host, ... }: {
      accounts = mkOption {
        type = listOf str;
        default = singleton "avery";
      };
    };
  };

  kasane.services._.copyparty =
    { host }:
    {
      nixos =
        { config, ... }:
        {
          imports = singleton inputs.copyparty.nixosModules.default;

          nixpkgs.overlays = singleton inputs.copyparty.overlays.default;

          services = {
            copyparty = {
              enable = true;
              settings = {
                e2dsa = true;
                e2ts = true;
                shr = "/share";
                rproxy = "1";
              };
              accounts = genAttrs host.services.copyparty.accounts (name: {
                passwordFile = config.sops.secrets."copyparty/users/${name}".path;
              });
            };
            nginx = mkNginxConfiguration host host.services.copyparty {
              # TODO: allow restricting non-shared paths by address
              locations = {
                "/" = {
                  proxyPass = "http://localhost:3923";
                  extraConfig = "client_max_body_size 1G;";
                };
                "/.cpr".proxyPass = "http://localhost:3923";
                "/share" = {
                  proxyPass = "http://localhost:3923";
                  extraConfig = "client_max_body_size 1G;";
                };
              };
              forceSSL = true;
              useACMEHost = host.services.internetDomain;
            };
          };

          sops.secrets = genAttrs' host.services.copyparty.accounts (
            user: nameValuePair "copyparty/users/${user}" { owner = config.services.copyparty.user; }
          );

          users = {
            groups.disk-write.gid = 900;
            users.copyparty.extraGroups = singleton "disk-write";
          };
        };
    };
}
