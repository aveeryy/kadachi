{ ... }:
{
  wireguardBaseDomain = "wg.rcia.dev";
  networks = {
    local = "10.0.0.0/16";
    kadachi-wg = "10.10.0.1/16";
  };
}
