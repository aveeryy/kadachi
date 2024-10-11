{ ... }: {
  services.dunst = {
    enable = false;
    settings = {
      global = {
        timeout = 3;
        corner_radius = 14;
        frame_width = 2;
        font = "Iosevka Nerd Font 10";
        format = ''
          <span font='Iosevka Nerd Font 12'><b>%s</b></span>
          %b'';
        icon_position = "left";
        max_icon_size = 48;
        icon_corner_radius = 4;
        origin = "bottom-right";
        offset = "8x8";
        width = "(100, 400)";
        background = "#11111b";
        foreground = "#cdd6f4";
        frame_color = "#cba6f7";
        highlight = "#cba6f7";
        separator_color = "frame";
        progress_bar = true;
        progress_bar_corner_radius = 4;
      };
      volumectl = {
        appname = "volumectl";
        alignment = "center";
      };
    };
  };
}
