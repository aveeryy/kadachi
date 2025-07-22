{ ... }: {
  programs.nixvim.plugins.none-ls = {
    enable = true;
    sources = {
      formatting = {
        black.enable = true;
        dart_format.enable = true;
        nixfmt.enable = true;
        xmllint.enable = true;
      };
    };
  };
}
