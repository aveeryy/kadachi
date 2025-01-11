{ ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = "$HOME/.local/share/wallpapers/.current_image";
        blur_size = 4;
        blur_passes = 3;
      };
      label = [
        {
          text = "$TIME";
          color = "rgba(255, 255, 255, 1.0)";
          font_size = 96;
          position = "0, -90";
          font_family = "Inter Medium";
          halign = "center";
          valign = "top";
        }
        {
          text = ''cmd[update:1000] date "+%A, %-e de %B del %Y"'';
          font_family = "Inter";
          font_size = 20;
          position = "0, -235";
          halign = "center";
          valign = "top";
        }
        {
          text = "$DESC";
          font_family = "Inter";
          position = "0, -35";
          font_size = 18;
          halign = "center";
          valign = "center";
        }
      ];
      image = {
        size = "150, 150";
        position = "0, 65";
        path = "$HOME/.face.icon";
        rounding = -1;
        halign = "center";
        valign = "center";
      };
      input-field = {
        size = "300, 50";
        outline_thickness = 0;
        dots_size = 0.2;
        dots_spacing = 0.15;
        dots_center = true;
        dots_rounding = -1;
        fade_on_empty = false;
        placeholder_text =
          ''<span color="##ffffffb7">Introduce la contraseña</span>'';
        outer_color = "rgba(255, 255, 255, 0.5)";
        inner_color = "rgba(255, 255, 255, 0.0)";
        font_color = "rgba(255, 255, 255, 1.0)";
        rounding = -1;
        position = "0, -80";
        halign = "center";
        valign = "center";
      };
    };
  };
}
