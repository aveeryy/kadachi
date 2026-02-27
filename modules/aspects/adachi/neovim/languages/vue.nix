{ ... }:
{
  adachi.neovim._.languages._.vue.neovim.plugins = {
    lsp.servers = {
      ts_ls.enable = true;
      vue_ls = {
        enable = true;
        tslsIntegration = true;
      };
    };
    neo-tree.settings.filesystem.filtered_items.hide_by_name = [ "node_modules" ];
    none-ls.sources.formatting.prettier = {
      enable = true;
      disableTsServerFormatter = true;
      settings.extra_filetypes = [ "vue" ];
    };
  };

}
