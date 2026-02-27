{ ... }:
{
  kasane.neovim._.plugins._.treesitter.neovim.plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight.enable = true;
    };
    nixvimInjections = true;
  };
}
