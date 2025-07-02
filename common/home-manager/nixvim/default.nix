{ ... }: {
  imports = [
    ./completion.nix
    ./fzf-lua.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    ./none-ls.nix
    ./spider.nix
    ./treesitter.nix
  ];
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        no_italic = true;
        transparent_background = true;
        integrations = {
          cmp = true;
          neotree = true;
        };
      };
    };

    diagnostic.settings = {
      signs.text.__raw = ''
        {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        }
      '';
    };

    globals.mapleader = " ";

    opts = {
      number = true;
      cursorline = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      ttyfast = true;
      wrap = false;
      mousemoveevent = true;
      signcolumn = "yes";
    };

    plugins = {
      web-devicons.enable = true;
      nvim-autopairs.enable = true;
    };
  };
}
