export const date = Variable("", {
  poll: [1000, 'date "+%H %M %S %Y-%m-%d"'],
});

class User {
  constructor(user_string) {
    var split_string = user_string.split(":");
    this.username = split_string[0];
    this.uid = split_string[2];
    this.gid = split_string[3];
    this.real_name = split_string[4];
    if (this.real_name == "") {
      this.real_name = this.username;
    }
    this.home_directory = split_string[5];
  }
}

var is_bar_extended = false;
var current_menu = "bar";

// TODO(maybe): watch for changes to real name
var uid = Utils.exec("sh -c 'echo $UID'");
export const CURRENT_USER = new User(
  Utils.exec(`grep -P '\\w+:x:${uid}' /etc/passwd`),
);
export const HOSTNAME = Utils.exec("hostname");

export function on_window_event(_, window_name, visible) {
  console.log(`is ${window_name} visible => ${visible}`);
  console.log(`current menu is ${current_menu}`);
  console.log(`is bar extended => ${is_bar_extended}`);
  if (window_name != "bar" && visible) {
    var previous_menu = current_menu;
    current_menu = window_name;
    if (previous_menu != "bar") {
      App.getWindow(previous_menu).visible = false;
    }
    App.getWindow("bar").css = "opacity: 0";
    if (window_name == "bar_extended") {
      is_bar_extended = true;
    }
  } else if (window_name != "bar" && !visible) {
    if (
      (window_name == "bar_extended" && current_menu == "bar_extended") ||
      !is_bar_extended
    ) {
      is_bar_extended = false;
      current_menu = "bar";
      App.getWindow("bar").css = "opacity: 1";
    } else if (window_name != "bar_extended" && is_bar_extended) {
      App.getWindow("bar_extended").visible = true;
    }
  }
}
