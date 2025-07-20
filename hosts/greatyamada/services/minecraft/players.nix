builtins.listToAttrs (map (player: {
  name = builtins.elemAt player 0;
  value = {
    name = builtins.elemAt player 0;
    uuid = builtins.elemAt player 1;
  };
}) [

  [ "engullejamones" "b65a1bc3-c6a0-4e8c-99b8-3538cfec0cfc" ]
  [ "dankoszz" "87b47db0-4dd3-469c-8dfd-c21095dadd93" ]
  [ "Santos_H" "6bbfc884-43e0-48b6-81d3-bb52654db44d" ]
  [ "PableteOmg12" "34c4db29-0112-4ae1-b3ee-48fb59b3311c" ]
])
