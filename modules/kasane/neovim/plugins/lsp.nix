{ ... }:
{
  kasane.neovim._.plugins._.lsp.homeManager.programs.nixvim.plugins = {
    lsp = {
      enable = true;
      keymaps.lspBuf."<leader>ca" = "code_action";
    };
  };
}
