{ pkgs, ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        cssls.enable = true;
        dartls.enable = true;
        jdtls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        # ts_ls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        svelte.enable = true;
        volar = {
          enable = true;
          filetypes = [
            "typescript"
            "javascript"
            "javascriptreact"
            "typescriptreact"
            "vue"
          ];
          extraOptions.init_options.vue.hybridMode = false;
        };
      };
    };
    nvim-jdtls = {
      enable = true;
      data = "~/.cache/jdtls/workspace";
    };
  };
}
