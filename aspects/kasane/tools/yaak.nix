{ lib, ... }: {
  kasane.tools._.yaak = {
    homeManager = { self', ... }: {
      home.packages = lib.singleton self'.packages.yaak;
    };
  };
}
