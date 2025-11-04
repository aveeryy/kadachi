{ ... }: {
  programs.nixvim.plugins.spider = {
    enable = true;
    settings = { subwordMovement = true; };
    keymaps.motions = {
      b = "b";
      e = "e";
      ge = "ge";
      w = "w";
    };
  };
}
