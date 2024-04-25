{ inputs, ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;

      servers = {
        pyright.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        svelte.enable = true;
      };
    };
  };
}
