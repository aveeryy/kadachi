{ ... }: {
  imports = [ ./invidious.nix ./inv-sig-helper.nix ];
  users = {
    groups.invidious = { };
    users.invidious = {
      group = "invidious";
      isSystemUser = true;
    };
  };
}
