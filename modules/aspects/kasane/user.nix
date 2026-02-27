{
  __findFile,
  inputs,
  ...
}:
let
  username = "avery";
  name = "Avery";
in
{
  kasane.base-user = <den.lib.parametric> {
    includes = [
      <den/primary-user>
      <kasane/neovim>
      <kasane/tools/git>
      <kasane/zsh>
    ];

    nixos =
      { config, ... }:
      {
        services.openssh.settings.AllowUsers = [ username ];
        sops.secrets."${username}_password" = {
          sopsFile = "${inputs.secrets}/common.yaml";
          owner = "root";
          neededForUsers = true;
        };
        users.users."${username}" = {
          description = name;
          hashedPasswordFile = config.sops.secrets."${username}_password".path;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtRRFXoFER38RXhmvzUsckxd+eqcWO7B6oHW6oDbZf0 ${username}@totsugeki"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGxbFhJuLDn1nGytao5RhBOyckMEQtpxrLJZR6G7Aax ${username}@mizuki"
          ];
        };
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ python3 ];
        programs.git = {
          settings.user = {
            name = name;
            email = "aveeryy@protonmail.com";
          };
          signing.key = "B684FD451B692E04";
        };
      };

    jovian.steam.user = username;

    wsl.defaultUser = username;
  };
}
