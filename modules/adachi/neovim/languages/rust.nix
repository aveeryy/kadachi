{ ... }:
{
  adachi.neovim._.languages._.rust.neovim.plugins = {
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

}
