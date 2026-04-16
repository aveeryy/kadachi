{ ... }:
{
  kasane.neovim.neovim.plugins.nvim-autopairs.luaConfig.post = ''
    npairs.add_rule(Rule("Array.<", ">", "typescript"))
  '';
}
