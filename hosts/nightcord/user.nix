{ __findFile, ... }:
{
  den.aspects."avery@nightcord" = {
    includes = [
      <kasane/base-user>
    ];
  };
}
