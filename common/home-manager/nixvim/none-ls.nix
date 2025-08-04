{ pkgs, ... }: {
  programs.nixvim.plugins.none-ls = {
    enable = true;
    sources = {
      formatting = {
        black.enable = true;
        dart_format.enable = true;
        mdformat = {
          enable = true;
          package = pkgs.mdformat.withPlugins
            (packages: with packages; [ mdformat-tables ]);
        };
        nixfmt.enable = true;
        xmllint.enable = true;
      };
    };
  };
}
