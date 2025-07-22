{ pkgs, ... }: {
  home.packages = [ (import ./get-minecraft-uuid.nix { inherit pkgs; }) ];
}
