{ __findFile, den, ... }:
{
  kasane.services._.ddns = {
    description = "Wrapper around adachi DDNS configurations using the host values";
    provides = {
      cloudflare = den.lib.take.exactly (
        { host }:
        {
          includes = [
            <adachi/services/ddns>
            (<adachi/services/ddns/cloudflare> host.services.baseHost)
          ];
        }
      );
      desec = den.lib.take.exactly (
        { host }:
        {
          includes = [
            <adachi/services/ddns>
            (<adachi/services/ddns/desec> host.services.baseHost)
          ];
        }
      );
    };
  };
}
