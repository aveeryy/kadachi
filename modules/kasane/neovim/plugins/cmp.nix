{ ... }:
{
  kasane.neovim._.plugins._.cmp.homeManager.programs.nixvim = {
    opts.completeopt = "menuone,noselect,fuzzy,nosort";
    extraConfigLua = ''
      local cmp = require("cmp")
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    '';
    plugins = {
      cmp = {
        enable = true;
        settings = {
          formatting.fields = [
            "abbr"
            "kind"
            "menu"
          ];
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = false })";
            "<Tab>" = ''
              cmp.mapping(
                  function(callback)
                      if cmp.visible() then
                          cmp.select_next_item()
                      elseif require("luasnip").expand_or_locally_jumpable() then
                          require("luasnip").expand_or_jump()
                      else
                          callback()
                      end
                  end
              , {"i", "s"})
            '';
            "<S-Tab>" = ''
              cmp.mapping(
                  function(callback)
                      if cmp.visible() then
                          cmp.select_prev_item()
                      elseif require("luasnip").jumpable(-1) then
                          require("luasnip").jump(-1)
                      else
                          callback()
                      end
                  end
              , {"i", "s"})
            '';
          };
          snippet.expand = ''
            function(args)
                require("luasnip").lsp_expand(args.body)
            end
          '';
          sources = [
            {
              name = "luasnip";
              priority = 40;
            }
            {
              name = "nvim_lsp";
              priority = 30;
              entry_filter = ''
                function(entry, _)
                    return entry:get_kind() ~= require("cmp").lsp.CompletionItemKind.Text
                end
              '';
            }
          ];
        };
      };
      lspkind.enable = true;
      luasnip = {
        enable = true;
        fromVscode = [ { } ];
      };
      friendly-snippets.enable = true;
    };
  };
}
