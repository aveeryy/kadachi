{ ... }:
{
  kasane.neovim._.plugins._.treesitter.homeManager.programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight.enable = true;
    };
    nixvimInjections = true;
  };
}
