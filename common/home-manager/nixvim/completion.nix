{ lib, ... }: {
  programs.nixvim = {
    extraConfigLua = ''
      function has_words_before()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0
              and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      function leave_snippet()
          if
              ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
              and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
              and not require("luasnip").session.jump_active
          then
              require("luasnip").unlink_current()
          end
      end

      -- stop snippets when you leave to normal mode
      vim.api.nvim_command([[
          autocmd ModeChanged * lua leave_snippet()
      ]])
    '';
    plugins = {
      cmp = {
        enable = true;
        settings = {
          formatting.format = lib.mkForce ''
            function(entry, vim_item)
                if vim.tbl_contains({ "path" }, entry.source.name) then
                    local icon, hl_group =
                        require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
                    if icon then
                        vim_item.kind = icon
                        vim_item.kind_hl_group = hl_group
                        return vim_item
                    end
                end
                return require("lspkind").cmp_format({ with_text = true })(entry, vim_item)
            end
          '';
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = false })";
            "<Tab>" = ''
              cmp.mapping(
                  function(callback)
                      if cmp.visible() then
                          cmp.select_next_item()
                      elseif require("luasnip").expand_or_locally_jumpable() then
                          require("luasnip").expand_or_jump()
                      elseif has_words_before() then
                          cmp.complete()
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
      lspkind = { enable = true; };
      luasnip = {
        enable = true;
        fromVscode = [ { } ];
      };
      friendly-snippets.enable = true;
    };
  };
}
