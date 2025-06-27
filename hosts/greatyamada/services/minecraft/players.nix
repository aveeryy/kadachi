builtins.listToAttrs (map (player: {
  name = builtins.elemAt player 0;
  value = {
    name = builtins.elemAt player 0;
    uuid = builtins.elemAt player 1;
  };
}) [

  [ "engullejamones" "b65a1bc3-c6a0-4e8c-99b8-3538cfec0cfc" ]
])
