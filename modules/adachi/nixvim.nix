{ inputs, ... }:
{
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
      systems.follows = "systems";
    };
  };

  adachi.nixvim = {
    description = "Building blocks for Nixvim configuration";
    homeManager.imports = [ inputs.nixvim.homeModules.nixvim ];
    provides = {
      extras.provides = {
        format-on-save.homeManager.programs.nixvim = {
          globals.rustfmt_autosave = 1;
          plugins.lsp.luaConfig.post = ''
            vim.api.nvim_create_augroup("FormatOnSave", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = "FormatOnSave",
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          '';
        };
      };
      languages.provides = {
        dart.homeManager.programs.nixvim.plugins = {
          lsp.servers.dartls.enable = true;
          none-ls.sources.formatting.dart_format.enable = true;
        };
        markdown.homeManager =
          { pkgs, ... }:
          {
            programs.nixvim.plugins.none-ls.sources.formatting.mdformat = {
              enable = true;
              package = pkgs.mdformat.withPlugins (plugins: with plugins; [ mdformat-tables ]);
            };
          };
        nix.homeManager =
          { pkgs, ... }:
          {
            programs.nixvim.plugins = {
              lsp.servers.nil_ls.enable = true;
              none-ls.sources.formatting.nixfmt = {
                enable = true;
                package = pkgs.nixfmt;
              };
            };
          };
        python.homeManager.programs.nixvim.plugins = {
          lsp.servers.pyright.enable = true;
          none-ls.sources.formatting.black.enable = true;
        };
        rust.homeManager.programs.nixvim.plugins = {
          lsp.servers.rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            installRustfmt = false;
            settings.rustfmt.extraArgs = [
              "--edition"
              "2024"
            ];
          };
        };
        vue.homeManager.programs.nixvim.plugins = {
          lsp.servers = {
            ts_ls.enable = true;
            vue_ls = {
              enable = true;
              tslsIntegration = true;
            };
          };
          neo-tree.settings.filesystem.filtered_items.hide_by_name = [ "node_modules" ];
        };
      };
    };
  };
}
