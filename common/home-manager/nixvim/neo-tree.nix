{ ... }: {
  programs.nixvim = {
    keymaps = [{
      action = "<cmd>Neotree toggle<CR>";
      key = "<leader>fi";
    }];
    plugins.neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        enable_git_status = true;
        enable_diagnostics = true;
        source_selector = {
          winbar = true;
          statusline = false;
          tabs_layout = "equal";
          sources = [{
            source = "filesystem";
            display_name = " 󰉓  Archivos ";
          }];
        };
        default_component_configs = {
          container = { enable_character_fade = true; };
          indent = {
            indent_size = 2;
            padding = 1;
            with_markers = true;
            indent_marker = "│";
            last_indent_marker = "└";
            highlight = "NeoTreeIndentMarker";
            with_expanders = true;
            expander_collapsed = "";
            expander_expanded = "";
            expander_highlight = "NeoTreeExpander";
          };
          icon = {
            folder_closed = "";
            folder_open = "";
            folder_empty = "";
            default = " ";
            highlight = "NeoTreeFileIcon";
          };
          modified = {
            symbol = "[+]";
            highlight = "NeoTreeModified";
          };
          name = {
            trailing_slash = false;
            use_git_status_colors = true;
            highlight = "NeoTreeFileName";
          };
          git_status = {
            symbols = {
              added = "";
              modified = "";
              deleted = "";
              renamed = "";
              untracked = "";
              ignored = "";
              unstaged = "";
              staged = "";
              conflict = "";
            };
          };
          diagnostics = {
            symbols = {
              error = "";
              warn = "";
              hint = "";
              info = "";
            };
            highlights = {
              hint = "diagnostic_sign_hint";
              info = "diagnostic_sign_info";
              warn = "diagnostic_sign_warn";
              error = "diagnostic_sign_error";
            };
          };
        };
        window = {
          position = "left";
          width = 40;
          mapping_options = {
            noremap = true;
            nowait = true;
          };
        };
        filesystem = {
          bind_to_cwd = true;
          filtered_items = {
            visible = false;
            hide_dotfiles = false;
            hide_gitignored = false;
            hide_by_name = [ "node_modules" ];
          };
          group_empty_dirs = false;
          use_libuv_file_watcher = true;
        };
        buffers = { group_empty_dirs = true; };
      };
    };
  };
}
