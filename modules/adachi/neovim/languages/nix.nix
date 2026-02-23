{ ... }:
{
  adachi.neovim._.languages._.nix.homeManager =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins = {
          lsp.servers.nil_ls.enable = true;
          none-ls.sources.formatting.nixfmt = {
            enable = true;
            package = pkgs.nixfmt;
          };
        };
        # TODO: modularize this for use in other languages
        extraConfigLuaPost = ''
          vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
            pattern = "*.nix";
            callback = function()
              vim.opt_local.shiftwidth = 2
              vim.opt_local.tabstop = 2
            end
          });
        '';
      };
    };
}
