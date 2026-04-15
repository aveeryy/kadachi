{ ... }:
{
  kasane.neovim.neovim = {
    keymaps = [
      {
        action = "<cmd>Oil<CR>";
        key = "<leader>fe";
      }
    ];
    plugins.oil = {
      enable = true;
    };
  };
}
