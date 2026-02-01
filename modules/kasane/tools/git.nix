{ ... }:
{
  kasane.tools._.git.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ git-credential-manager ];
      programs = {
        git = {
          enable = true;
          settings = {
            credential = {
              credentialStore = "gpg";
              helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
              "https://codeberg.org".provider = "generic";
              "https://git.rcia.dev".provider = "generic";
            };
            init.defaultBranch = "main";
            merge.tool = "nvimdiff";
            user.name = "Avery";
            user.email = "aveeryy@protonmail.com";
          };
          signing = {
            key = "B684FD451B692E04";
            signByDefault = true;
          };
        };
        lazygit = {
          enable = true;
          enableZshIntegration = false;
        };
        zsh.shellAliases."lg" = "lazygit";
      };
    };
}
