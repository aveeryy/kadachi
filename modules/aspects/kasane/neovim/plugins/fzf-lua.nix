{ ... }:
{
  kasane.neovim._.plugins._.fzf-lua = {
    neovim.plugins.fzf-lua = {
      enable = true;
      keymaps = {
        "<leader>ff" = "files";
        "<leader>fg" = "live_grep";
        "<leader>bb" = "buffers";
        "<leader>ca" = {
          action = "lsp_code_actions";
          settings = {
            previewer = "none";
            filter.__raw = ''
              function(code_action, _)
                return not code_action.disabled
              end
            '';
          };
        };
        "<leader>dg" = {
          action = "diagnostics_document";
          settings = {
            previewer = "none";
            diag_icons = ''{"","","",""}'';
            multiline = 1;
          };
        };
      };
      luaConfig.post = ''
        vim.ui.select = require("fzf-lua.providers.ui_select").ui_select;
      '';
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ripgrep ];
      };
  };
}
