{ ... }: {
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
      settings = {
        auto_refresh = true;
        focus = true;
        follow = false;
        keys = {
          "<cr>" = "jump_close";
          "s" = "jump_vsplit";
          "S" = "jump_split";
        };
        win = {
          type = "float";
          border = "rounded";
        };
      };
    };
    keymaps = [
      {
        action = "<cmd>Trouble diagnostics toggle<cr>";
        key = "<leader>dg";
      }
      {
        action = "<cmd>Trouble symbols toggle auto_close=true focus=true<cr>";
        key = "<leader>sy";
      }
    ];
  };
}
