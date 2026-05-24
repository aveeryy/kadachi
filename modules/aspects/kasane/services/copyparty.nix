{ inputs, lib, ... }:
let
  inherit (lib)
    genAttrs
    genAttrs'
    mkOption
    nameValuePair
    ;
in
{
  flake-file.inputs.copyparty = {
    url = "github:9001/copyparty/v1.20.14";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.schema.host =
    { host, ... }:
    {
      options.services.copyparty = with lib.types; {
        domain = mkOption {
          type = str;
          default = "copyparty.${host.services.baseDomain}";
        };
        accounts = mkOption {
          type = listOf str;
          default = [ "avery" ];
        };
      };
    };

  kasane.services._.copyparty =
    { host }:
    {
      nixos =
        { config, ... }:
        {
          imports = [ inputs.copyparty.nixosModules.default ];

          nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

          services = {
            copyparty = {
              enable = true;
              accounts = genAttrs host.services.copyparty.accounts (name: {
                passwordFile = config.sops.secrets."copyparty/users/${name}".path;
              });
            };
            nginx.virtualHosts."${host.services.copyparty.domain}" = {
              locations."/".proxyPass = "http://localhost:3923";
              forceSSL = true;
              useACMEHost = host.services.baseDomain;
              extraConfig = host.services.nginx.localServiceConfig;
            };
          };

          sops.secrets = genAttrs' host.services.copyparty.accounts (
            user: nameValuePair "copyparty/users/${user}" { owner = config.services.copyparty.user; }
          );
          users = {
            groups.disk-write = { };
            users.copyparty.extraGroups = [ "disk-write" ];
          };
        };
    };
}
