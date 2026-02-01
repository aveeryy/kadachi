{ __findFile, ... }:
{
  kasane.base-user = <den.lib.parametric> {
    includes = [
      <den/primary-user>
      <kasane/nixvim>
      <kasane/tools/git>
      <kasane/zsh>
    ];

    nixos =
      { config, ... }:
      {
        users.users.avery = {
          description = "Avery";
          hashedPasswordFile = config.sops.secrets.avery_password.path;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtRRFXoFER38RXhmvzUsckxd+eqcWO7B6oHW6oDbZf0 avery@totsugeki"
          ];
        };
      };
  };
}
