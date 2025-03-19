{ ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      keymaps.lspBuf."<leader>ca" = "code_action";
      luaConfig.post = ''
        local signs = {
            Error = "",
            Warn = "",
            Hint = "",
            Info = ""
        }

        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
        end
      '';
      servers = {
        cssls.enable = true;
        dartls.enable = true;
        jdtls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        ts_ls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        svelte.enable = true;
        volar = {
          enable = true;
          tslsIntegration = true;
          # extraOptions.init_options.vue.hybridMode = false;
        };
      };
    };
    nvim-jdtls = {
      enable = true;
      data = "~/.cache/jdtls/workspace";
    };
  };
}
