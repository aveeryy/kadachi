{ ... }:
{
  adachi.neovim._.languages._.markdown.neovim =
    { pkgs, ... }:
    {
      plugins.none-ls.sources.formatting.mdformat = {
        enable = true;
        package = pkgs.mdformat.withPlugins (plugins: with plugins; [ mdformat-tables ]);
      };
    };
}
