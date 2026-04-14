{ ... }:
{
  kasane.neovim._.plugins._.lsp.neovim.plugins = {
    lsp = {
      enable = true;
      keymaps.lspBuf = {
        "<leader>ca" = "code_action";
      };
    };
  };
}
