{ ... }:
{
  kasane.neovim.neovim.plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight.enable = true;
    };
    nixvimInjections = true;
  };
}
