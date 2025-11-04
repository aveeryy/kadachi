{ ... }:
{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      keymaps.lspBuf."<leader>ca" = "code_action";
      luaConfig.post = ''
        vim.api.nvim_create_augroup("FormatOnSave", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = "FormatOnSave",
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      '';
      servers = {
        cssls.enable = true;
        dartls.enable = true;
        jdtls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          settings.rustfmt.extraArgs = [
            "--edition"
            "2024"
          ];
        };
        svelte.enable = true;
        volar = {
          enable = true;
          extraOptions.on_init.__raw = ''
            function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
              client.handlers['tsserver/request'] = function(_, result, context)
                local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
                if #clients == 0 then
                  vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
                  return
                end
                local ts_client = clients[1]

                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  command = 'typescript.tsserverRequest',
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                    local response_data = { { id, r.body } }
                    ---@diagnostic disable-next-line: param-type-mismatch
                    client:notify('tsserver/response', response_data)
                  end)
              end
            end,
          '';
        };
      };
    };
    typescript-tools = {
      enable = true;
      settings = {
        on_attach.__raw = ''
          function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        '';
        filetypes = [
          "javascript"
          "typescript"
          "vue"
        ];
        settings = {
          single_file_support = false;
          tsserver_plugins = [ "@vue/typescript-plugin" ];
        };
      };
    };
  };
}
