{ __findFile, den, ... }:
let
  makeAspect =
    serviceAspect:
    den.lib.take.exactly (
      { host }:
      {
        includes = [
          <adachi/services/acme>
          (serviceAspect host.services.baseHost)
        ];
        nixos.security.acme.defaults.email = host.services.email;
      }
    );
in
{
  kasane.services._.acme = {
    description = "Wrapper around adachi ACME configurations using the host values";
    provides = {
      cloudflare = (makeAspect <adachi/services/acme/cloudflare>);
      desec = (makeAspect <adachi/services/acme/desec>);
    };
  };
}
