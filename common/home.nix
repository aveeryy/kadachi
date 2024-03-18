{
  pkgs,
  config,
  inputs,
  ...
}: {
  home = {
    username = "avery";
    homeDirectory = "/home/avery";
    stateVersion = "24.05";
    packages = with pkgs; [
      python3
      rclone
      xdg-user-dirs
      xdg-utils
    ];
  };
  programs.home-manager.enable = true;
}
