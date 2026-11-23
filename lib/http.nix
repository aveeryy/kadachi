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
    bool
    listOf
    nullOr
    str
    ;

  constants = import ./constants.nix { };

  mkHttpServiceOptions =
    {
      name,
      subdomain ? name,
      enableWireguardByDefault ? true,
      useMainSSLCertificateByDefault ? true,
      options ? { ... }: { },
    }:
    { host, ... }@ctx:
    {
      options.services.${name} = {
        domains = {
          internet = mkOption {
            type = nullOr str;
            default =
              if host.services.internetDomain != null then
                "${subdomain}.${host.services.internetDomain}"
              else
                null;
          };
          kadachi-wg = mkOption {
            type = nullOr str;
            default =
              if enableWireguardByDefault then
                "${subdomain}.${host.name}.${constants.wireguardBaseDomain}"
              else
                null;
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
          description = "Allowed addresses when accessing through the Wireguard domain";
        };
        useMainSSLCertificate = mkOption {
          type = bool;
          default = useMainSSLCertificateByDefault;
          description = "Whether this service should use the main certificate or it's own";
        };
      }
      // (options ctx);
    };

  mkNginxConfiguration =
    host: service: vHostConfig:
    let
      hasInternetDomain = service.domains.internet != null;
      hasWireguardDomain = service.domains.kadachi-wg != null;

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
          ++ optional hasWireguardDomain {
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
        useACMEHost =
          if service.useMainSSLCertificate then host.services.internetDomain else service.domains.internet;
      };

    in
    applyExtraConfig {
      virtualHosts =
        optionalAttrs hasInternetDomain {
          ${service.domains.internet} = httpsConfig // vHostConfig;
        }
        // optionalAttrs hasWireguardDomain {
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
