{ ... }:
{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      keymaps.lspBuf."<leader>ca" = "code_action";
      luaConfig.post = ''
        vim.api.nvim_create_augroup("FormatOnSave", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = "FormatOnSave",
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      '';
      servers = {
        cssls.enable = true;
        dartls.enable = true;
        jdtls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          settings.rustfmt.extraArgs = [
            "--edition"
            "2024"
          ];
        };
        svelte.enable = true;
        ts_ls.enable = true;
        vue_ls = {
          enable = true;
          tslsIntegration = true;
        };
      };
    };
  };
}
