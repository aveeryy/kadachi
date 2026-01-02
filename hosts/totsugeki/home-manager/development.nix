{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      android-tools
      mitmproxy
      python3
      xh
    ];
    sessionPath = [ "$HOME/.dotnet/tools" ];
  };
}
