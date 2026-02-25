{ kadachi-lib, ... }:
{
  adachi.neovim._.languages._.nix.homeManager =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins = {
          lsp.servers.nil_ls.enable = true;
          none-ls.sources.formatting.nixfmt = {
            enable = true;
            package = pkgs.nixfmt;
          };
        };
        extraConfigLuaPost = kadachi-lib.neovim.setLanguageIndentation "*.nix" 2;
      };
    };
}
