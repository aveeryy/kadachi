{ withSystem, ... }:
{
  flake.overlays.default =
    final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { config, ... }:
      {
        screenshot = config.packages.screenshot;
        wallpaperctl = config.packages.wallpaperctl;
      }
    );
}
