{ lib }:
let
  inherit (lib)
    join
    mkOption
    optional
    optionalAttrs
    optionalString
    singleton
    updateManyAttrsByPath
    ;

  inherit (lib.types)
    listOf
    nullOr
    str
    ;

  constants = import ./constants.nix { };

  mkHttpServiceOptions =
    {
      name,
      subdomain ? name,
      options ? { ... }: { },
    }:
    { host, ... }@ctx:
    {
      options.services.${name} = {
        domains = {
          internet = mkOption {
            type = str;
            default = "${subdomain}.${host.services.internetDomain}";
          };
          kadachi-wg = mkOption {
            type = str;
            default = "${subdomain}.${host.name}.${constants.wireguardBaseDomain}";
          };
        };
        allowedInternetAddresses = mkOption {
          type = nullOr (listOf str);
          default = null;
          description = "Allowed addresses when accessing through the internet domain";
        };
        allowedWireguardAddresses = mkOption {
          type = listOf str;
          default = singleton constants.networks.kadachi-wg;
          description = "Allowed addresses when accessing through the internet domain";
        };
      }
      // (options ctx);
    };

  mkNginxConfiguration =
    host: service: vHostConfig:
    let
      hasInternetDomain = host.services.internetDomain != null;

      domainFilterConfig =
        allowedAddresses:
        optionalString (allowedAddresses != null) ''
          error_page 403 ${host.services.fallbackUrl};
          ${join "\n" (map (x: "allow ${x};") allowedAddresses)}
          deny all;
        '';

      getPrevString =
        prev:
        let
          evaluated = builtins.tryEval prev;
        in
        optionalString evaluated.success evaluated.value;

      applyExtraConfig =
        vHosts:
        updateManyAttrsByPath (
          optional hasInternetDomain {
            path = [
              "virtualHosts"
              service.domains.internet
              "extraConfig"
            ];
            update = prev: (getPrevString prev) + "\n" + domainFilterConfig service.allowedInternetAddresses;
          }
          ++ singleton {
            path = [
              "virtualHosts"
              service.domains.kadachi-wg
              "extraConfig"
            ];
            update = prev: (getPrevString prev) + "\n" + domainFilterConfig service.allowedWireguardAddresses;
          }
        ) vHosts;

      httpsConfig = {
        forceSSL = true;
        useACMEHost = host.services.internetDomain;
      };

    in
    applyExtraConfig {
      virtualHosts =
        optionalAttrs hasInternetDomain {
          ${service.domains.internet} = httpsConfig // vHostConfig;
        }
        // {
          ${service.domains.kadachi-wg} = httpsConfig // vHostConfig;
        };

    };
in
{
  inherit
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
}
