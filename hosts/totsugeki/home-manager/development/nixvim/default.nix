{ pkgs, ... }: {
  imports = [
    ./completion.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    ./none-ls.nix
    ./treesitter.nix
    ./telescope.nix
    ./trouble.nix
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

    extraPlugins = with pkgs.vimPlugins; [ nvim-web-devicons ];
  };
}
