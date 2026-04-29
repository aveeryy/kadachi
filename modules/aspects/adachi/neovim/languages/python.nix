{ ... }:
{
  adachi.neovim._.languages._.python.neovim.plugins = {
    lsp.servers = {
      basedpyright = {
        enable = true;
        # Let ruff handle these diagnostics
        settings.basedpyright.analysis.diagnosticSeverityOverrides = {
          reportUnusedVariable = false;
          reportUndefinedVariable = false;
        };
      };
      ruff.enable = true;
    };
    none-ls.sources.formatting.black.enable = true;
  };
}
