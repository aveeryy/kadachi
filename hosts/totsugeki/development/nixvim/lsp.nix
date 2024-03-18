{ inputs, ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;

      servers = { pyright.enable = true; };
    };
  };
}
