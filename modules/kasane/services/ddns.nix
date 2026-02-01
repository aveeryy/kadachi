{ __findFile, ... }:
{
  kasane.services._.ddns = {
    description = "Wrapper around adachi DDNS configurations using the host values";
    provides = {
      cloudflare =
        { host, ... }:
        {
          includes = [
            <adachi/services/ddns>
            (<adachi/services/ddns/cloudflare> host.services.baseHost)
          ];
        };
    };
  };
}
