{ ... }:
{
  kasane.tools._.git.homeManager =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [ git-credential-manager ];
      programs = {
        git = {
          enable = true;
          settings = {
            credential = {
              cacheOptions = "--timeout 7200";
              credentialStore = "gpg";
              helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
              "https://codeberg.org".provider = "generic";
              "https://git.rcia.dev".provider = "generic";
            };
            init.defaultBranch = "main";
            merge.tool = "nvimdiff";
          };
          signing.signByDefault = config.programs.git.signing.key != null;
        };
        lazygit = {
          enable = true;
          enableZshIntegration = false;
          settings = {
            gui.nerdFontsVersion = "3";
            git.autoFetch = false;
          };
        };
        zsh.shellAliases."lg" = "lazygit";
      };
    };
}
