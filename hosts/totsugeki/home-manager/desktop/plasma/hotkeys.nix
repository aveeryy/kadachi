{ ... }: {
  programs.plasma.shortcuts = {
    kwin = {
      "Switch to Desktop 1" = "Meta+1";
      "Window to Desktop 1" = "Meta+!";
      "Switch to Desktop 2" = "Meta+2";
      "Window to Desktop 2" = ''Meta+"'';
      "Switch to Desktop 3" = "Meta+3";
      "Window to Desktop 3" = "Meta+·";
      "Switch to Desktop 4" = "Meta+4";
      "Window to Desktop 4" = "Meta+$";
      "Switch to Desktop 5" = "Meta+5";
      "Window to Desktop 5" = "Meta+%";
      "Switch to Desktop 6" = "Meta+6";
      "Window to Desktop 6" = "Meta+&";
      "Switch to Desktop 7" = "Meta+7";
      "Window to Desktop 7" = "Meta+/";
      "Switch to Desktop 8" = "Meta+8";
      "Window to Desktop 8" = "Meta+(";
      "Switch to Desktop 9" = "Meta+9";
      "Window to Desktop 9" = "Meta+)";
      "Switch to Desktop 10" = "Meta+0";
      "Window to Desktop 10" = "Meta+=";
    };
    "services/kitty.desktop"."_launch" = "Ctrl+Alt+T";
  };
}
