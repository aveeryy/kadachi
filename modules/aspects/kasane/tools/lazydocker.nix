{ ... }:
{
  kasane.tools._.lazydocker.homeManager =
    { config, ... }:
    {
      programs = {
        lazydocker.enable = true;
        zsh.shellAliases = {
          "lazydocker" =
            "CONFIG_DIR=${config.home.homeDirectory}/.config/lazydocker sudo --preserve-env=CONFIG_DIR lazydocker";
          "ld" = "lazydocker";
        };
      };
    };
}
