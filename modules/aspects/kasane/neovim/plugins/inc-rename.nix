{ ... }:
{
  kasane.neovim.neovim = {
    plugins.inc-rename.enable = true;
    keymaps = [
      {
        action.__raw = ''
          function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end
        '';
        key = "<leader>rn";
        mode = [ "n" ];
        options = {
          desc = "Incremental rename";
          expr = true;
        };
      }
      {
        action = ":IncRename ";
        key = "<leader>rr";
        mode = [ "n" ];
        options.desc = "Incremental rename (clearing existing name)";
      }
    ];
  };
}
