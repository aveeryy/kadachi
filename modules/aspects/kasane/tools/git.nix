{ lib, ... }:
{
  kasane.tools._.git.homeManager =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [ git-credential-manager ];
      programs = {
        git = {
          enable = true;
          settings = {
            init.defaultBranch = "main";
            merge.tool = "nvimdiff";
          };
          signing.signByDefault = config.programs.git.signing.key != null;
        };

        difftastic = {
          enable = true;
          git = {
            enable = true;
            mode = "both";
          };
        };

        lazygit = {
          enable = true;
          enableZshIntegration = false;
          settings = {
            gui.nerdFontsVersion = "3";
            git = {
              autoFetch = false;
              overrideGpg = true;
              pagers = [
                { externalDiffCommand = "${lib.getExe config.programs.difftastic.package} --color=always"; }
              ];
            };
          };
        };

        zsh.shellAliases."lg" = "lazygit";
      };
    };
}
