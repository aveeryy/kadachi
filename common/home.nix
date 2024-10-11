{ pkgs, ... }: {
  home = {
    username = "avery";
    homeDirectory = "/home/avery";
    stateVersion = "24.05";
    packages = with pkgs; [ python3 rclone xdg-utils ];
    sessionVariables = {
      EDITOR = "nvim";
      DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    };
    sessionPath = [ "$HOME/.dotnet/tools" ];
  };
  programs.home-manager.enable = true;
}
