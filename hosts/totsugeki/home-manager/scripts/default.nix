{ pkgs, ... }: {
  home.packages = [
    (import ./change-wallpaper.nix { inherit pkgs; })
    (import ./ddc-brightness.nix { inherit pkgs; })
    (import ./play-on-soundboard.nix { inherit pkgs; })
    (import ./screenshot.nix { inherit pkgs; })
    (import ./setup-soundboard.nix { inherit pkgs; })
    (import ./volumectl.nix { inherit pkgs; })
  ];
}
