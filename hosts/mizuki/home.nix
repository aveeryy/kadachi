{ lib, pkgs, ... }: {
  imports = [ ./development.nix ];
  home = {
    stateVersion = lib.mkForce "24.11";
    packages = with pkgs; [ python3 ];
  };
  programs.zsh.initContent = lib.mkAfter ''
    setxkbmap -layout es -variant dvorak > /dev/null
    WAYLAND_DISPLAY="wayland-1"
  '';
}
