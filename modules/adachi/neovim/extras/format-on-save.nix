{ ... }:
{
  adachi.neovim._.extras._.format-on-save.homeManager.programs.nixvim = {
    globals.rustfmt_autosave = 1;
    plugins.lsp.luaConfig.post = ''
      vim.api.nvim_create_augroup("FormatOnSave", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = "FormatOnSave",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    '';
  };
}
