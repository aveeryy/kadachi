{ __findFile, ... }:
{
  den.aspects."avery@hatsune" = {

    includes = [
      <kasane/base-user>

      <adachi/neovim/extras/format-on-save>
    ];
  };
}
