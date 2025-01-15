{ pkgs, ... }: {
  imports = [ ./nixvim ];
  home = {
    packages = with pkgs; [
      android-studio
      android-tools
      git-credential-manager
      gnupg
      pass
      dotnet-sdk_8
      unityhub
      mitmproxy
    ];
  };
  programs = {
    git = {
      enable = true;
      extraConfig = {
        credential = {
          credentialStore = "gpg";
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
          "https://codeberg.org".provider = "generic";
          "https://git.rcia.dev".provider = "generic";
        };
        init.defaultBranch = "main";
        merge.tool = "nvim -d";
      };
      signing = {
        key = "B684FD451B692E04";
        signByDefault = true;
      };
      userEmail = "aveeryy@protonmail.com";
      userName = "Avery";
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
      pinentryPackage = pkgs.pinentry-qt;
    };
  };
}
