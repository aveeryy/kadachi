{ ... }:
let
  neovim.setLanguageIndentation = pattern: indentation: /* lua */ ''
    vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
      pattern = "${pattern}",
      callback = function()
        vim.opt_local.shiftwidth = ${toString indentation}
        vim.opt_local.tabstop = ${toString indentation}
      end,
    })
  '';

  kadachi-lib = { inherit neovim; };
in
{
  _module.args.kadachi-lib = kadachi-lib;
}
