{ pkgs, ... }: {
  home.packages = with pkgs; [ ripgrep ];
  programs.nixvim.plugins.fzf-lua = {
    enable = true;
    keymaps = {
      "<leader>ff" = "files";
      "<leader>fg" = "live_grep";
      "<leader>bb" = "buffers";
      "<leader>dg" = {
        action = "diagnostics_document";
        settings = {
          previewer = "none";
          diag_icons = ''{"","","",""}'';
          multiline = 1;
        };
      };
    };
  };
}
