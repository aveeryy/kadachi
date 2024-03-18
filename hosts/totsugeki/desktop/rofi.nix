{ config, pkgs, ... }:
let inherit (config.lib.formats.rasi) mkLiteral;
in {
  programs.rofi = {
    enable = true;
    extraConfig = {
      drun-display-format = "{name}";
      display-drun = " ";
      show-icons = true;
      icon-theme = "kora";
      steal-focus = true;
    };
    package = pkgs.rofi-wayland;
    font = "Iosevka Nerd Font 11";
    terminal = "kitty";
    theme = {
      "*" = {
        background = mkLiteral "#1e1d2f";
        background-alt = mkLiteral "#282839";
        foreground = mkLiteral "#d9e0ee";
        selected = mkLiteral "#7aa2f7";
        active = mkLiteral "#abe9b3";
        urgent = mkLiteral "#f28fad";
      };
      window = {
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "500px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";

        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "12px";
        border-color = mkLiteral "@selected";
        background-color = mkLiteral "#1e1e2e99";
        cursor = "default";
      };

      mainbox = {
        enabled = true;
        spacing = mkLiteral "20px";
        margin = mkLiteral "0px";
        padding = mkLiteral "12px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px 0px 0px 0px";
        border-color = mkLiteral "@selected";
        background-color = mkLiteral "transparent";
        children = map mkLiteral [ "inputbar" "listview" ];
      };

      inputbar = {
        enabled = true;
        spacing = mkLiteral "8px";
        margin = mkLiteral "0px";
        padding = mkLiteral "4px 8px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "12px";
        border-color = mkLiteral "@selected";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        children = map mkLiteral [ "prompt" "entry" ];
      };

      prompt = {
        enabled = true;
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
      };
      textbox-prompt-colon = {
        enabled = true;
        expand = false;
        str = "::";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
      };
      entry = {
        enabled = true;
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "";
        placeholder-color = mkLiteral "inherit";
      };

      listview = {
        enabled = true;
        columns = 1;
        lines = 18;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = "vertical";
        reverse = false;
        fixed-height = false;
        fixed-columns = true;

        spacing = mkLiteral "0px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@selected";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        cursor = mkLiteral "default";
      };
      scrollbar = {
        handle-width = mkLiteral "5px";
        handle-color = mkLiteral "@selected";
        border-radius = mkLiteral "0px";
        background-color = mkLiteral "@background-alt";
      };

      element = {
        enabled = true;
        spacing = mkLiteral "4px";
        margin = mkLiteral "0px";
        padding = mkLiteral "4px 8px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "12px";
        border-color = mkLiteral "@selected";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        orientation = mkLiteral "horizontal";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
      };

      "element selected.normal" = {
        background-color = mkLiteral "#cdd6f422";
        text-color = mkLiteral "@foreground";
      };

      element-icon = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "24px";
        cursor = mkLiteral "inherit";
      };

      element-text = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = 0;
      };

      error-message = {
        padding = mkLiteral "15px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@selected";
        background-color = mkLiteral "black / 10%";
        text-color = mkLiteral "@foreground";
      };
      textbox = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        vertical-align = mkLiteral "0.5";
        horizontal-align = 0;
        highlight = mkLiteral "none";
      };
    };
  };
}
