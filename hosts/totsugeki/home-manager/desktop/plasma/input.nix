{ ... }: {
  programs.plasma.configFile = {
    kcminputrc."Libinput/9610/54/Glorious Model O" = {
      PointerAcceleration = -0.4;
      PointerAccelerationProfile = 1;
    };
    kxkbrc.Layout = {
      LayoutList = "es";
      Use = true;
      VariantList = "dvorak";
      Options = "caps:menu";
      ResetOldOptions = true;
    };
  };
}
