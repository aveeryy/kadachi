{ pkgs, ... }: {
  home.packages = with pkgs; [ ripgrep ];
  programs.nixvim.plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>ff" = "find_files";
      "<leader>fg" = "live_grep";
      "<leader>bb" = "buffers";
    };
  };
}
