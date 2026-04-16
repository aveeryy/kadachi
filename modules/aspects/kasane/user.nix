{
  __findFile,
  inputs,
  lib,
  ...
}:
{
  kasane.base-user =
    { user, ... }:
    let
      username = user.userName;
    in
    {
      includes = [
        <den/primary-user>

        <adachi/system/spanish-xdg-user-dirs>
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
            description = lib.strings.toSentenceCase username;
            hashedPasswordFile = config.sops.secrets."${username}_password".path;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtRRFXoFER38RXhmvzUsckxd+eqcWO7B6oHW6oDbZf0 ${username}@totsugeki"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGxbFhJuLDn1nGytao5RhBOyckMEQtpxrLJZR6G7Aax ${username}@mizuki"
            ];
          };
        };

      homeManager =
        { pkgs, config, ... }:
        {
          home.packages = with pkgs; [ python3 ];
          programs.fzf.enable = true;
          programs.git = {
            settings.user = {
              name = lib.mkDefault (lib.strings.toSentenceCase username);
              email = lib.mkDefault "aveeryy@protonmail.com";
            };
            signing = {
              format = lib.mkDefault "ssh";
              key = lib.mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
            };
          };
          xdg.userDirs = {
            desktop = config.home.homeDirectory;
            publicShare = config.home.homeDirectory;
            templates = config.home.homeDirectory;
          };
        };

      jovian.steam.user = username;
    };
}
