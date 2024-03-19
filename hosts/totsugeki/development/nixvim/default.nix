{ inputs, pkgs, ... }: {
  imports = [
    ./completion.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    ./none-ls.nix
    ./treesitter.nix
  ];
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      disableItalic = true;
      integrations = {
        cmp = true;
        neotree = true;
      };
    };

    globals.mapleader = " ";

    options = {
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

    plugins.nvim-autopairs.enable = true;

    extraPlugins = with pkgs.vimPlugins; [ nvim-web-devicons ];
  };
}
