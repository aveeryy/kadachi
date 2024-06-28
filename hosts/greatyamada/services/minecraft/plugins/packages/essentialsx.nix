{ config, lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "EssentialsX";
  version = "2.20.1";

  src = fetchurl {
    url =
      "https://github.com/EssentialsX/Essentials/releases/download/${version}/EssentialsX-${version}.jar";
    hash = "sha256-gC6jC9pGDKRZfoGJJYFpM8EjsI2BJqgU+sKNA6Yb9UI=";
  };

  unpackPhase = ":";

  installPhase = ''
    ln -sf EssentialsX-${version}.jar $out
  '';

  meta = {
    description = "The modern Essentials suite for Spigot and Paper.";
    homepage = "https://essentialsx.net/";
    license = lib.licenses.gpl3Plus;
  };
}
