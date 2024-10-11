{ ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;
        pyright.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        svelte.enable = true;
      };
    };
  };
}
