{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      android-studio
      android-tools
      dotnet-sdk_8
      mitmproxy
      python3
      unityhub
      xh
    ];
    sessionVariables = { DOTNET_ROOT = "${pkgs.dotnet-sdk_8}"; };
    sessionPath = [ "$HOME/.dotnet/tools" ];
  };
}
