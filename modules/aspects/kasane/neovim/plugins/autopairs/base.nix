{ lib, ... }:
{
  kasane.neovim._.plugins._.autopairs.neovim.plugins.nvim-autopairs = {
    enable = true;
    luaConfig.post = lib.mkBefore ''
      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")
      local cond = require("nvim-autopairs.conds")
    '';
  };
}
