{ ... }:
{
  kasane.neovim._.plugins._.autopairs.neovim.plugins.nvim-autopairs.luaConfig.post = ''
    npairs.add_rule(Rule("<", ">"):with_pair(
      cond.before_regex("%a+:?:?$", 3)
    ):with_move(function(opts)
      return opts.char == ">"
    end))
  '';
}
