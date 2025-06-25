{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ android-tools mitmproxy python3 xh ];
    sessionVariables = { DOTNET_ROOT = "${pkgs.dotnet-sdk_8}"; };
    sessionPath = [ "$HOME/.dotnet/tools" ];
  };
}
