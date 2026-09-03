{ den, lib, ... }:
let
  jovianClass =
    { class, aspect-chain }:
    den._.forward {
      each = lib.singleton class;
      fromClass = _: "jovian";
      intoClass = _: "nixos";
      intoPath = _: [ "jovian" ];
      fromAspect = _: lib.last aspect-chain;
      guard = { options, ... }: options ? jovian;
    };

  noctaliaClass =
    { class, aspect-chain }:
    den._.forward {
      each = lib.singleton class;
      fromClass = _: "noctalia";
      intoClass = _: "homeManager";
      intoPath = _: [
        "programs"
        "noctalia"
      ];
      fromAspect = _: lib.last aspect-chain;
      guard = { options, ... }: options ? programs.noctalia;
    };

  wslClass =
    { class, aspect-chain }:
    den._.forward {
      each = lib.singleton class;
      fromClass = _: "wsl";
      intoClass = _: "nixos";
      intoPath = _: [ "wsl" ];
      fromAspect = _: lib.last aspect-chain;
      guard = { options, ... }: options ? wsl;
    };
in
{
  den.default.includes = [
    jovianClass
    noctaliaClass
    wslClass
  ];
}
