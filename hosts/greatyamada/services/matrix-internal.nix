{ }: {
  containers.matrix-bridges = {
    autoStart = true;
    config = { config, pkgs }: {
      services.matrix-synapse = {
        enable = true;
        settings = {
          server_name = "matrix-int.rcia.dev";
          listeners = [ { } ];
        };
      };
    };
  };
}
