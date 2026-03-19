{ ... }:
{
  kasane.neovim._.plugins._.autopairs.neovim.plugins.nvim-autopairs.luaConfig.post = ''
    npairs.add_rule(Rule("Array.<", ">", "typescript"))
  '';
}
