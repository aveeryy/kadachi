{ ... }: {
  perSystem =
    { lib, pkgs, ... }:
    let
      inherit (lib)
        singleton
        ;

      inherit (pkgs)
        fetchFromGitHub
        installFonts
        stdenvNoCC
        ;
    in
    {
      packages.radio-canada-big = stdenvNoCC.mkDerivation {
        pname = "radio-canada-big";
        version = "unstable";

        src = fetchFromGitHub {
          owner = "googlefonts";
          repo = "radio-canada-display";
          rev = "063477f7c63e9c58520ad2bfdc5a982eebf4b473";
          hash = "sha256-KnSxOZPRx81X0XHrVgSE5QPjXwVs2qRzgKiiZwFREy4=";
        };

        nativeBuildInputs = singleton installFonts;
        postPatch = ''
          rm -rf documentation/ sources/
        '';

        dontInstallWebfonts = true;
      };
    };
}
