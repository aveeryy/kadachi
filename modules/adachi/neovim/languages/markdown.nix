{ ... }:
{
  adachi.neovim._.languages._.markdown.homeManager =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.none-ls.sources.formatting.mdformat = {
        enable = true;
        package = pkgs.mdformat.withPlugins (plugins: with plugins; [ mdformat-tables ]);
      };
    };
}
