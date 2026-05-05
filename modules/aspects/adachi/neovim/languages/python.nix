{ ... }:
{
  adachi.neovim._.languages._.python.neovim = {
    plugins = {
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
    extraFiles."queries/python/injections.scm".text = /* query */ ''
      ; extends

      (assignment
        right: (string
          (string_start) @_ss
          (string_content) @injection.content)
        (#match? @_ss "[^rR]?[rR][^rR]?[\"']")
        (#set! injection.language "regex"))

      (assignment
        right: (parenthesized_expression
        	(string
            (string_start) @_ss
            (string_content) @injection.content))
        (#match? @_ss "[^rR]?[rR][^rR]?[\"']")
        (#set! injection.language "regex"))
    '';
  };
}
