{ __findFile, ... }:
{
  kasane.services._.acme = {
    description = "Wrapper around adachi ACME configurations using the host values";
    provides = {
      cloudflare =
        { host, ... }:
        {
          includes = [
            <adachi/services/acme>
            (<adachi/services/acme/cloudflare> host.services.baseHost host.services.email)
          ];
        };
    };
  };
}
