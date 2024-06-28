{ pkgs, ... }: {
  home.packages = with pkgs; [
    (import ./play-on-soundboard.nix { inherit pkgs; })
    (import ./setup-soundboard.nix { inherit pkgs; })
  ];
}
