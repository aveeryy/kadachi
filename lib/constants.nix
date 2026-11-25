{ ... }:
{
  wireguardBaseDomain = "wg.rcia.dev";
  networks = {
    local = "10.0.0.0/16";
    kadachi-wg = "10.10.0.0/16";
  };

  atproto = {
    did = "did:plc:gabri67ltcparekugqrro55b";
    pds = "https://pds.rcia.dev";
    plc_directory = "https://plc.directory";
  };
}
