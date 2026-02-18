{ ... }:
{
  adachi.neovim._.extras._.format-on-save.homeManager.programs.nixvim = {
    globals.rustfmt_autosave = 1;
    plugins.lsp.luaConfig.post = ''
      vim.api.nvim_create_augroup("FormatOnSave", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = "FormatOnSave",
        callback = function()
          vim.lsp.buf.format {
            async = false,
            filter = function(client) 
                local disabled_clients = { "ts_ls", "vue_ls" }
                for _index, disabled_client_name in ipairs(disabled_clients) do
                    if client.name == disabled_client_name then
                      return false
                    end
                end
                return true
            end
          }
        end,
      })
    '';
  };
}
