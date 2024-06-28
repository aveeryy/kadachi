{ ... }: {
  imports = [ ./input.nix ./hotkeys.nix ./krohnkite.nix ./theme.nix ];
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace.clickItemTo = "open";
    kwin = {
      virtualDesktops = {
        rows = 1;
        number = 10;
      };
      effects.desktopSwitching.animation = "slide";
    };
    configFile = { "kded5rc" = { Module-gtkconfig.autoload = false; }; };
  };
}
