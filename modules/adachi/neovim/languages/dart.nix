{ ... }:
{
  adachi.neovim._.languages._.dart.homeManager.programs.nixvim.plugins = {
    lsp.servers.dartls.enable = true;
    none-ls.sources.formatting.dart_format.enable = true;
  };
}
