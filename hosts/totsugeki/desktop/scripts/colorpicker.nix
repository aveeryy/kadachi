{ pkgs }:

pkgs.writeShellApplication {
  name = "colorpicker";
  runtimeInputs = with pkgs; [ dunst hyprpicker imagemagick wl-clipboard ];
  text = ''
    COLOR=$(hyprpicker --no-fancy --autocopy)
    convert -size 1x1 xc:"$COLOR" "$HOME/.cache/.tmp_colorpicker.jpg"
    dunstify -i "$HOME/.cache/.tmp_colorpicker.jpg" "Color copiado" "$COLOR"
    rm "$HOME/.cache/.tmp_colorpicker.jpg"
  '';
}
