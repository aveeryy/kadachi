{ ... }:
{
  adachi.system._.greetd-autologin =
    command:
    { user, ... }:
    {
      nixos.services.greetd = {
        enable = true;
        settings =
          let
            session = {
              command = command;
              user = user.userName;
            };
          in
          {
            initial_session = session;
            default_session = session;
          };
      };
    };
}
