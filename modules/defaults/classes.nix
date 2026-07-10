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

  noctaliaShellClass =
    { class, aspect-chain }:
    den._.forward {
      each = lib.singleton class;
      fromClass = _: "noctaliaShell";
      intoClass = _: "homeManager";
      intoPath = _: [
        "programs"
        "noctalia-shell"
      ];
      fromAspect = _: lib.last aspect-chain;
      guard = { options, ... }: options ? programs.noctalia-shell;
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
    noctaliaShellClass
    wslClass
  ];
}
