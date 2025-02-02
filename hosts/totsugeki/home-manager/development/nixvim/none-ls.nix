{ ... }: {
  programs.nixvim.plugins.none-ls = {
    enable = true;
    settings.on_attach = ''
      function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end
    '';
    sources = {
      formatting = {
        black.enable = true;
        dart_format.enable = true;
        nixfmt.enable = true;
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
          settings = { extra_filetypes = [ "svelte" ]; };
        };
        xmllint.enable = true;
      };
    };
  };
}
