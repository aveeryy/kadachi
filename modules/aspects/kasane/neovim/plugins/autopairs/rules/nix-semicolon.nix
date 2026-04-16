{ ... }:
{
  kasane.neovim.neovim.plugins.nvim-autopairs.luaConfig.post = ''
    -- Note that when the cursor is at the end of a comment line,
    -- treesitter thinks we are in attrset_expression
    -- because the cursor is "after" the comment, even though it is on the same line.
    local is_not_ts_node_comment_one_back = function()
      return function(info)
        local p = vim.api.nvim_win_get_cursor(0)
        -- Subtract one to account for 1-based row indexing in nvim_win_get_cursor
        -- Also subtract one from the position of the column to see if we are at the end of a comment.
        local pos_adjusted = {p[1] - 1, p[2] - 1}

        vim.treesitter.get_parser():parse()
        local target = vim.treesitter.get_node({ pos = pos_adjusted, ignore_injections = false })
        if target ~= nil and utils.is_in_table({'comment'}, target:type()) then
            return false
        end

        local rest_of_line = info.line:sub(info.col)
        return rest_of_line:match('^%s*$') ~= nil
      end
    end

    npairs.add_rule(
      Rule("= ", ";", "nix")
        :with_pair(is_not_ts_node_comment_one_back())
        :set_end_pair_length(1)
    )
  '';
}
