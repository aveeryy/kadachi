{ lib, ... }:
{
  kasane.neovim.neovim.plugins.nvim-autopairs = {
    enable = true;
    luaConfig.post = lib.mkBefore ''
      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")
      local cond = require("nvim-autopairs.conds")
      local ts_conds = require('nvim-autopairs.ts-conds')
      local utils = require('nvim-autopairs.utils')
    '';
  };
}
