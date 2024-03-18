{ ... }: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<leader>fi";
     }
    ];
    plugins.neo-tree = {
      enable = true;
      closeIfLastWindow = true;
      enableGitStatus = true;
      enableDiagnostics = true;
      sourceSelector = {
          winbar = true;
          statusline = false;
          tabsLayout = "equal";
          sources = [
              { source = "filesystem"; displayName = " 󰉓  Archivos "; }
          ];
      };
      defaultComponentConfigs = {
          container = {
              enableCharacterFade = true;
          };
          indent = {
              indentSize = 2;
              padding = 1;
              withMarkers = true;
              indentMarker = "│";
              lastIndentMarker = "└";
              highlight = "NeoTreeIndentMarker";
              withExpanders = true;
              expanderCollapsed = "";
              expanderExpanded = "";
              expanderHighlight = "NeoTreeExpander";
          };
          icon = {
              folderClosed = "";
              folderOpen = "";
              folderEmpty = "";
              default = " ";
              highlight = "NeoTreeFileIcon";
          };
          modified = {
              symbol = "[+]";
              highlight = "NeoTreeModified";
          };
          name = {
              trailingSlash = false;
              useGitStatusColors = true;
              highlight = "NeoTreeFileName";
          };
          gitStatus = {
              symbols = {
                  added = "";
                  modified = "";
                  deleted = "";
                  renamed = "";
                  untracked = "";
                  ignored = "";
                  unstaged = "U";
                  staged = "";
                  conflict = "";
              };
          };
          diagnostics = {
              symbols = {
                  error = "";
                  warn = "";
                  hint = "";
                  info = "";
              };
              highlights = {
                  hint = "DiagnosticSignHint";
                  info = "DiagnosticSignInfo";
                  warn = "DiagnosticSignWarn";
                  error = "DiagnosticSignError";
              };
          };
      };
      window = {
          position = "left";
          width = 40;
          mappingOptions = {
              noremap = true;
              nowait = true;
          };
      };
      filesystem = {
          bindToCwd = true;
          filteredItems = {
              visible = false;
              hideDotfiles = false;
              hideGitignored = false;
              hideByName = [
                  "nodeModules"
              ];
          };
          groupEmptyDirs = false;
          useLibuvFileWatcher = true;
      };
      buffers = {
          groupEmptyDirs = true;
      };
      renderers = {
          directory = [
            "indent"
            "icon"
            "current_filter"
            {
              name = "container";
              content = [
                {
                  name = "name";
                  zindex = 10;
                }
                {
                  name = "symlink_target";
                  zindex = 10;
                  highlight = "NeoTreeSymbolicLinkTarget";
                }
                {
                  name = "clipboard";
                  zindex = 10;
                }
                {
                  name = "diagnostics";
                  errorsOnly = true;
                  zindex = 20;
                  align = "right";
                  hideWhenExpanded = false;
                }
                {
                  name = "git_status";
                  zindex = 10;
                  align = "right";
                  hideWhenExpanded = true;
                }
              ];
            }
          ];
          file = [
              "indent"
              "icon"
              {
                name = "container";
                content = [
                  { name = "name"; zindex = 10; }
                  { name = "clipboard"; zindex = 10;}
                  { name = "bufnr"; zindex = 10;}
                  { name = "modified"; zindex = 20; align = "right";}
                  { name = "diagnostics"; zindex = 20; align = "right";}
                  { name = "git_status"; zindex = 15; align = "right";}
                ];
            }
        ];
      };
   };
 };
}
