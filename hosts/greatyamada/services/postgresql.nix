{ ... }:
let portDefinitions = import ./_port-definitions.nix;
in {
  services.postgresql = {
    enable = true;
    settings.port = portDefinitions.postgresql;
  };
}
