{
  den,
  kadachi-lib,
  lib,
  ...
}:
let
  inherit (lib)
    defaultTo
    filter
    singleton
    ;

  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "gatus";
    subdomain = "status";
    options = { ... }: { };
  };

  adachi.services._.gatus = { host }: {
    includes = singleton den.policies.collect-monitored-services;

    nixos =
      { config, monitoredServices, ... }:
      let
        serviceToEndpoint =
          collected:
          let
            service = collected.value;
            inherit (collected) source;
          in
          {
            inherit (service) name;
            url = "https://${defaultTo service.config.domains.internet service.config.domains.kadachi-wg}${service.path or ""}";
            group = source.host.name;
            interval = "5m";
            conditions = singleton "[STATUS] == 200";
          }
          // (service.additionalConfig.gatus or { });

      in
      {
        services = {
          gatus = {
            enable = true;
            settings = {
              web.port = 8100;
              endpoints = filter (endpoint: endpoint.url != null) (map serviceToEndpoint monitoredServices);
            };
          };

          nginx = mkNginxConfiguration host host.services.gatus {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.gatus.settings.web.port}";
          };
        };
      };
  };
}
