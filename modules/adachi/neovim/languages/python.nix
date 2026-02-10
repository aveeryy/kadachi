{ ... }:
{
  adachi.neovim._.languages._.python.homeManager.programs.nixvim.plugins = {
    lsp.servers.pyright.enable = true;
    none-ls.sources.formatting.black.enable = true;
  };
}
