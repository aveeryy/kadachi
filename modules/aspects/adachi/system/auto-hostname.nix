{ den, ... }:
{
  adachi.system._.auto-hostname = den.lib.take.exactly (
    { host }:
    {
      ${host.class}.networking.hostName = host.hostName;
    }
  );
}
