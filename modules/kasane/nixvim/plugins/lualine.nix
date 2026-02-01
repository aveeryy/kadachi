{ ... }:
{
  kasane.nixvim._.plugins._.lualine.homeManager.programs.nixvim.plugins.lualine = {
    enable = true;
    settings.options = {
      component_separators = {
        left = "";
        right = "";
      };
      section_separators = {
        left = "";
        right = "";
      };
      disabled_filetypes.statusline = [ "neo-tree" ];
    };
  };
}
