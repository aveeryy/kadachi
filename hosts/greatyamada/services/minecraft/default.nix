{ config, lib, pkgs, inputs, ... }:
let
  serverIcon = ./server-icon.png;
  players = import ./players.nix;
  ports = import ../_port-definitions.nix;
  packageNameToHumanString = packageName:
    (let
      getSections = packageName:
        # Probably only matches Fabric servers, change as needed
        builtins.match
        "^minecraft-server-([0-9a-zA-Z.]*)-([a-zA-Z-]*)-([0-9a-zA-Z.]*)$"
        packageName;
      sections = (getSections packageName);
      getSection = idx:
        if sections == null then "Unknown" else builtins.elemAt sections idx;
    in "Minecraft ${getSection 0} with ${
      lib.strings.toSentenceCase (getSection 1)
    } ${getSection 2}");
  playersToOps = players:
    map (player: {
      name = player.name;
      uuid = player.uuid;
      level = 4;
      bypassesPlayerLimit = true;
    }) players;
in {
  environment.systemPackages = with pkgs; [ mcrcon ];
  networking.firewall.allowedTCPPorts = with ports.tcp; [ minecraft ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/mnt/ssd-01/minecraft";
    environmentFile = config.sops.templates."minecraft.env".path;
    managementSystem = {
      tmux.enable = false;
      systemd-socket.enable = true;
    };
    servers.fabric_prod = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_6;
      enableReload = true;
      autoStart = false;
      jvmOpts =
        "-Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
      serverProperties = {
        difficulty = "hard";
        enable-rcon = true;
        enable-query = false;
        enforce-secure-profile = false;
        enforce-whitelist = true;
        hide-online-players = true;
        max-players = 10;
        motd = "${
            packageNameToHumanString
            config.services.minecraft-servers.servers.fabric_prod.package.name
          } on ${config.networking.hostName}";
        online-mode = true;
        pause-when-empty-seconds = 60;
        pvp = true;
        "rcon.password" = "@MINECRAFT_RCON_PASSWORD@";
        server-port = ports.tcp.minecraft;
        simulation-distance = 10;
        spawn-protection = 0;
        view-distance = 10;
        white-list = true;
      };
      symlinks = {
        "server-icon.png" = serverIcon;
        "mods/Fabric-API.jar" = pkgs.fetchurl {
          url =
            "https://cdn.modrinth.com/data/P7dR8mSH/versions/b2dnY6PN/fabric-api-0.128.0%2B1.21.6.jar";
          sha512 =
            "c668402e1a877c2d572d16e31e6d2783be27a80993fa83bf040ea2007994518786bd3140dcea15334f8ee1630836292b8ae4d41444e47cba0ac43d05f1eb1e78";
        };
        "mods/Ferrite-Core.jar" = pkgs.fetchurl {
          url =
            "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
          sha512 =
            "131b82d1d366f0966435bfcb38c362d604d68ecf30c106d31a6261bfc868ca3a82425bb3faebaa2e5ea17d8eed5c92843810eb2df4790f2f8b1e6c1bdc9b7745";
        };
        "mods/Lithium.jar" = pkgs.fetchurl {
          url =
            "https://cdn.modrinth.com/data/gvQqBUqZ/versions/XWGBHYcB/lithium-fabric-0.17.0%2Bmc1.21.6.jar";
          sha512 =
            "a8d6a8b69ae2b10dd0cf8f8149260d5bdbd2583147462bad03380014edd857852972b967d97df69728333d8836b1e9db8997712ea26365ddb8a05b8c845c6534";
        };
        "mods/Krypton.jar" = pkgs.fetchurl {
          url =
            "https://cdn.modrinth.com/data/fQEb0iXm/versions/neW85eWt/krypton-0.2.9.jar";
          sha512 =
            "2e2304b1b17ecf95783aee92e26e54c9bfad325c7dfcd14deebf9891266eb2933db00ff77885caa083faa96f09c551eb56f93cf73b357789cb31edad4939ffeb";
        };
        "mods/spark.jar" = pkgs.fetchurl {
          url =
            "https://cdn.modrinth.com/data/l6YH9Als/versions/qW2mPW6y/spark-1.10.139-fabric.jar";
          sha512 =
            "cd991acee93c074912f2934b5a9c3967be2f1e9157ca5a7254fd3fce8d280c5aa9a3ab06d3ee19f06c5111181853cf12048d000bf8b9f722c902c080fe258a97";
        };
      };
      files = {
        "ops.json".value = playersToOps (with players; [ engullejamones ]);
        "whitelist.json".value = with players; [ engullejamones dankoszz ];
      };
    };
  };
  sops = {
    secrets."minecraft_rcon".owner = "minecraft";
    templates."minecraft.env" = {
      content = ''
        MINECRAFT_RCON_PASSWORD=${config.sops.placeholder."minecraft_rcon"}
      '';
      owner = "minecraft";
    };
  };
  users.groups.minecraft.members = [ "avery" ];
}
