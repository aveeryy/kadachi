{ __findFile, den, ... }:
let
  makeAspect =
    serviceAspect:
    den.lib.take.exactly (
      { host }:
      {
        includes = [
          <adachi/services/ddns>
          (serviceAspect host.services.baseDomain)
        ];
      }
    );
in
{
  kasane.services._.ddns = {
    description = "Wrapper around adachi DDNS configurations using the host values";
    provides = {
      cloudflare = (makeAspect <adachi/services/ddns/cloudflare>);
      desec = (makeAspect <adachi/services/ddns/desec>);
    };
  };
}
