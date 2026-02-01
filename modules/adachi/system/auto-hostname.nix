{ ... }:
{
  adachi.system._.auto-hostname =
    { host, ... }:
    {
      ${host.class}.networking.hostName = host.hostName;
    };
}
