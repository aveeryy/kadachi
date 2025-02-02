{ ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
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
      };
    };
    nvim-jdtls = {
      enable = true;
      data = "~/.cache/jdtls/workspace";
    };
  };
}
