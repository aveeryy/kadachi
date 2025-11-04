{ pkgs, ... }: {
  imports = [ ./nixvim ];
  home = { packages = with pkgs; [ git-credential-manager gnupg pass ]; };
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
      settings = {
        gui.theme = {
          activeBorderColor = [ "#89b4fa" "bold" ];
          inactiveBorderColor = [ "#a6adc8" ];
          optionsTextColor = [ "#89b4fa" ];
          selectedLineBgColor = [ "#313244" ];
          selectedRangeBgColor = [ "#313244" ];
          cherryPickedCommitBgColor = [ "#45475a" ];
          cherryPickedCommitFgColor = [ "#89b4fa" ];
          unstagedChangesColor = [ "#f38ba8" ];
          defaultFgColor = [ "#cdd6f4" ];
          searchingActiveBorderColor = [ "#f9e2af" ];
        };
      };
    };
  };
  services = {
    gpg-agent = {
      defaultCacheTtl = 3600;
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      pinentry.package = pkgs.pinentry-qt;
    };
  };
}
