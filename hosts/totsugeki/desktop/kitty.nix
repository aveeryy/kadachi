{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 14;
    };
    keybindings = {
      "ctrl+alt+1" = "goto_tab 1";
      "ctrl+alt+2" = "goto_tab 2";
      "ctrl+alt+3" = "goto_tab 3";
      "ctrl+alt+4" = "goto_tab 4";
      "ctrl+alt+5" = "goto_tab 5";
      "ctrl+alt+6" = "goto_tab 6";
      "ctrl+alt+7" = "goto_tab 7";
      "ctrl+alt+8" = "goto_tab 8";
      "ctrl+alt+9" = "goto_tab 9";
    };
    settings = {
      "background_opacity" = "0.90";
      "dynamic_background_opacity" = true;
      "force_ltr" = "yes";
      "disable_ligatures" = "never";
      "cursor_shape" = "beam";
      "scrollback_lines" = 8000;
      "enable_audio_bell" = "no";
      "window_padding_width" = 8;
      "tab_bar_min_tabs" = 2;
      "tab_bar_edge" = "bottom";
      "tab_bar_style" = "powerline";
      "tab_powerline_style" = "round";
      "tab_title_template" =
        "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      "background" = "#1E1E2F";
    };
    theme = "Catppuccin-Mocha";
  };
}
