# TODO: find a way to automatically install krohnkite
{ ... }: {
  programs.plasma.configFile.kwinrc = {
    Plugins.krohnkiteEnabled = true;
    Script-krohnkite = {
      enableMonocleLayout = false;
      enableSpreadLayout = false;
      enableStairLayout = false;
      enableThreeColumnLayout = false;
      enableTileLayout = false;
      ignoreClass = "krunner,yakuake,spectacle,kded5,plasmashell";
      layoutPerActivity = false;
      layoutPerDesktop = false;
      limitTileWidthRatio = 0.6;
      noTileBorder = true;
      screenGapBottom = 20;
      screenGapLeft = 8;
      screenGapRight = 8;
      screenGapTop = 8;
      tileLayoutGap = 2;
    };
  };
}
