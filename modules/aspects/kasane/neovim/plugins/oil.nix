{ ... }:
{
  kasane.neovim.neovim = {
    keymaps = [
      {
        action = "<cmd>Oil --float<CR>";
        key = "<leader>fe";
      }
    ];
    plugins.oil = {
      enable = true;
    };
  };
}
