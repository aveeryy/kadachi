{ __findFile, ... }:
let
  getDiagnosticJumpAction = count: /* lua */ ''
    function()
      vim.diagnostic.jump({
        count = ${count},
        severity = {
          min = vim.diagnostic.severity.WARN
        },
        wrap = true,
      })
    end
  '';
in
{
  kasane.neovim = {
    description = "Base Neovim configuration";

    includes = [
      <adachi/neovim>
      <adachi/neovim/languages/nix>
      <kasane/neovim/plugins/cmp>
      <kasane/neovim/plugins/fzf-lua>
      <kasane/neovim/plugins/lsp>
      <kasane/neovim/plugins/lualine>
      <kasane/neovim/plugins/neo-tree>
      <kasane/neovim/plugins/none-ls>
      <kasane/neovim/plugins/spider>
      <kasane/neovim/plugins/treesitter>
    ];

    homeManager.home.sessionVariables.EDITOR = "nvim";

    neovim = {
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

      keymaps = [
        {
          action = "<C-]>";
          key = "<leader>gd";
          mode = [ "n" ];
          options.desc = "Go to definition under cursor";
        }
        {
          action.__raw = getDiagnosticJumpAction "1";
          key = "<leader>dn";
          mode = [ "n" ];
          options.desc = "Go to next diagnostic";
        }
        {
          action.__raw = getDiagnosticJumpAction "-1";
          key = "<leader>dp";
          mode = [ "n" ];
          options.desc = "Go to previous diagnostic";
        }
      ];

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
  };
}
