{ ... }: {
  programs.nixvim.plugins.spider = {
    enable = true;
    extraOptions = { subwordMovement = true; };
    keymaps.motions = {
      b = "b";
      e = "e";
      ge = "ge";
      w = "w";
    };
  };
}
