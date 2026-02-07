{ ... }:
{
  adachi.services._.gpg-agent = hostHasGui: {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ gnupg ];

        services.gpg-agent = {
          defaultCacheTtl = 3600;
          enable = true;
          enableZshIntegration = true;
          pinentry.package = if hostHasGui then pkgs.pinentry-qt else pkgs.pinentry-curses;
        };
      };
  };
}
