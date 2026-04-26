{ inputs, ... }:
{
  flake-file.inputs.nur = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.web-browsers._.firefox.homeManager =
    { config, pkgs, ... }:
    let
      lepton = pkgs.fetchFromGitHub {
        owner = "black7375";
        repo = "Firefox-UI-Fix";
        rev = "v8.7.5";
        hash = "sha256-IfR5pI+tpP5RfoTqO6Vgnbc5nADqSA4gg+9csz/+pO0=";
      };
    in
    {
      home.file."${config.home.homeDirectory}/${config.programs.firefox.profilesPath}/Avery/chrome".source =
        lepton;

      nixpkgs.overlays = [ inputs.nur.overlays.default ];

      programs.firefox = {
        enable = true;
        profiles.Avery = {
          isDefault = true;
          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              bitwarden
              catppuccin-mocha-mauve
              catppuccin-web-file-icons
              consent-o-matic
              kagi-translate
              floccus
              karakeep
              stylus
              ublock-origin
            ];
            settings = {
              "uBlock0@raymondhill.net" = {
                settings = {
                  advancedUserEnabled = true;
                  importedLists = [
                    "https://git.rcia.dev/Avery/ubo-block-list/raw/branch/main/list.txt"
                  ];
                  popupPanelSections = 63;
                  selectedFilterLists = [
                    "user-filters"
                    "ublock-filters"
                    "ublock-badware"
                    "ublock-privacy"
                    "ublock-quick-fixes"
                    "ublock-unbreak"
                    "easylist"
                    "adguard-generic"
                    "easyprivacy"
                    "adguard-spyware-url"
                    "urlhaus-1"
                    "curben-phishing"
                    "plowe-0"
                    "fanboy-social"
                    "adguard-social"
                    "fanboy-thirdparty_social"
                    "fanboy-ai-suggestions"
                    "easylist-chat"
                    "easylist-newsletters"
                    "easylist-notifications"
                    "easylist-annoyances"
                    "adguard-mobile-app-banners"
                    "adguard-other-annoyances"
                    "adguard-popup-overlays"
                    "adguard-widgets"
                    "ublock-annoyances"
                    "spa-1"
                    "spa-0"
                    "https://git.rcia.dev/Avery/ubo-block-list/raw/branch/main/list.txt"
                  ];
                };
              };
            };
          };
          search = {
            force = true;
            default = "Kagi";
            order = [ "Kagi" ];
            engines = {
              Kagi = {
                urls = [
                  {
                    template = "https://kagi.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                iconMapObj = {
                  "16" = "https://kagi.com/favicon-16x16.png?v=2";
                  "32" = "https://kagi.com/favicon-32x32.png?v=2";
                };
              };
              google.metaData.hidden = true;
              bing.metaData.hidden = true;
              ddg.metaData.hidden = true;
              wikipedia.metaData.hidden = true;
              qwant.metaData.hidden = true;
              ecosia.metaData.hidden = true;
              perplexity.metaData.hidden = true;
            };
          };
          settings = {
            # Firefox telemetry
            "app.normandy.api_url" = "";
            "app.normandy.enabled" = false;
            "breakpad.reportURL" = "";
            "browser.selfsupport.url" = "";
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.usage.uploadEnabled" = true;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.cachedClientID" = "";
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.prompted" = 2;
            "toolkit.telemetry.rejected" = true;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.server" = "";
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.unifiedIsOptIn" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            # Don't auto-submit crash reports
            "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.tabs.crashReporting.sendReport" = false;
            # New tab
            "browser.newtab.preload" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
            "browser.newtabpage.enabled" = false;
            "browser.newtabpage.enhanced" = false;
            "browser.newtabpage.introShown" = true;
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
            # Annoyances
            "browser.aboutConfig.showWarning" = false;
            "browser.ai.control.default" = "blocked";
            "browser.cache.offline.enable" = false;
            "browser.disableResetPrompt" = true;
            "browser.download.always_ask_before_handling_new_types" = true;
            "browser.ml.chat.menu" = false;
            "browser.ml.linkPreview.enabled" = false;
            "browser.safebrowsing.appRepURL" = "";
            "browser.safebrowsing.enabled" = false;
            "browser.safebrowsing.malware.enabled" = false;
            "browser.sessionstore.resume_from_crash" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.startup.couldRestoreSession.count" = -1;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.tabs.groups.enabled" = false;
            "browser.tabs.groups.smart.enabled" = false;
            "browser.translations.enable" = false;
            "clipboard.autocopy" = false;
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "extensions.getAddons.cache.enabled" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.pocket.enabled" = false;
            "extensions.shield-recipe-client.api_url" = "";
            "extensions.shield-recipe-client.enabled" = false;
            "extensions.ui.dictionary.hidden" = true;
            "extensions.ui.mlmodel.hidden" = true;
            "extensions.webservice.discoverURL" = "";
            "layout.spellcheckDefault" = 0;
            "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
            "middlemouse.paste" = false;
            "signon.rememberSignons" = false;
            # HTTPS-only
            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_ever_enabled" = true;
            # Disable experiments
            "app.shield.optoutstudies.enabled" = false;
            "experiments.activeExperiment" = false;
            "experiments.enabled" = false;
            "experiments.manifest.uri" = "";
            "experiments.supported" = false;
            "network.allow-experiments" = false;
            # Privacy
            "beacon.enabled" = false;
            "browser.formfill.enable" = false;
            "browser.sessionstore.privacy_level" = 0;
            "device.sensors.ambientLight.enabled" = false;
            "device.sensors.enabled" = false;
            "device.sensors.motion.enabled" = false;
            "device.sensors.orientation.enabled" = false;
            "device.sensors.proximity.enabled" = false;
            "dom.battery.enabled" = false;
            "dom.private-attribution.submission.enabled" = false;
            "media.video_stats.enabled" = false;
            "network.cookie.cookieBehavior" = 1;
            "network.dns.disablePrefetch" = true;
            "network.dns.disablePrefetchFromHTTPS" = true;
            "network.http.referer.trimmingPolicy" = 2;
            "network.http.speculative-parallel-limit" = 0;
            "network.predictor.enable-prefetch" = false;
            "network.predictor.enabled" = false;
            "network.prefetch-next" = false;
            "privacy.firstparty.isolate" = true;
            "privacy.globalprivacycontrol.enabled" = true;
            "privacy.globalprivacycontrol.functionality.enabled" = true;
            "privacy.query_stripping" = true;
            "privacy.trackingprotection.cryptomining.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "privacy.trackingprotection.pbmode.enabled" = true;
            "privacy.usercontext.about_newtab_segregation.enabled" = true;
            "security.ssl.disable_session_identifiers" = true;
            "signon.autofillForms" = false;
            "webgl.renderer-string-override" = " ";
            "webgl.vendor-string-override" = " ";
            # DNS-over-HTTPS
            "network.trr.mode" = 5;
            # URL bar
            "browser.urlbar.groupLabels.enabled" = false;
            "browser.urlbar.quicksuggest.enabled" = false;
            "browser.urlbar.showSearchTerms.enabled" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;
            "browser.urlbar.suggest.engines" = false;
            "browser.urlbar.suggest.quickactions" = false;
            "browser.urlbar.suggest.topsites" = false;
            "browser.urlbar.shortcuts.actions" = false;
            "browser.urlbar.shortcuts.bookmarks" = false;
            "browser.urlbar.shortcuts.history" = false;
            "browser.urlbar.shortcuts.tabs" = false;
            "browser.urlbar.trimURLs" = false;
            # History
            "privacy.clearOnShutdown.cookies" = false;
            "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
            "privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs2" = true;
            "privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs3" = true;
            "privacy.sanitize.sanitizeOnShutdown" = true;
            "privacy.sanitize.pending" = builtins.toJSON [
              {
                id = "newtab-container";
                itemsToClear = [ ];
                options = { };
              }
              {
                id = "shutdown";
                itemsToClear = [
                  "cache"
                  "browsingHistoryAndDownloads"
                ];
                options = { };
              }
            ];
            "privacy.history.custom" = true;
            # DRM
            "media.eme.enabled" = false;
            "media.gmp-widevinecdm.enabled" = false;
            # Media autoplay
            "media.autoplay.default" = 0;
            "media.autoplay.enabled" = true;
            # Browser UI customization
            "browser.compactmode.show" = true;
            "browser.display.use_document_fonts" = 0;
            "browser.uiCustomization.state" = builtins.toJSON {
              currentVersion = 23;
              newElementCount = 67;
              placements = {
                PersonalToolbar = [ "personal-bookmarks" ];
                TabsToolbar = [
                  "tabbrowser-tabs"
                  "new-tab-button"
                ];
                nav-bar = [
                  "back-button"
                  "forward-button"
                  "stop-reload-button"
                  "vertical-spacer"
                  "urlbar-container"
                  "downloads-button"
                  "unified-extensions-button"
                  "ublock0_raymondhill_net-browser-action"
                  "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                  "addon_karakeep_app-browser-action"
                  "floccus_handmadeideas_org-browser-action"
                ];
                toolbar-menubar = [ "menubar-items" ];
              };
            };
            "browser.tabs.inTitlebar" = 0;
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.uidensity" = 1;
            "extensions.activeThemeID" = "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}"; # Catppuccin Mocha Mauve
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "svg.context-properties.content.enabled" = true;
            # Browser UI customization - Userstyle-specific
            "userChrome.tab.connect_to_window" = true;
            "userChrome.tab.color_like_toolbar" = true;

            "userChrome.tab.lepton_like_padding" = false;
            "userChrome.tab.photon_like_padding" = true;

            "userChrome.tab.dynamic_separator" = false;
            "userChrome.tab.static_separator" = true;
            "userChrome.tab.static_separator.selected_accent" = false;
            "userChrome.tab.bar_separator" = false;

            "userChrome.tab.newtab_button_like_tab" = false;
            "userChrome.tab.newtab_button_smaller" = true;
            "userChrome.tab.newtab_button_proton" = false;

            "userChrome.icon.panel_full" = false;
            "userChrome.icon.panel_photon" = true;

            "userChrome.tab.box_shadow" = false;
            "userChrome.tab.bottom_rounded_corner" = false;

            "userChrome.tab.photon_like_contextline" = true;
            "userChrome.rounding.square_tab" = true;

            "userChrome.compatibility.theme" = true;
            "userChrome.compatibility.os" = true;

            "userChrome.theme.built_in_contrast" = true;
            "userChrome.theme.system_default" = true;
            "userChrome.theme.proton_color" = true;
            "userChrome.theme.proton_chrome" = true;
            "userChrome.theme.fully_color" = true;
            "userChrome.theme.fully_dark" = true;

            "userChrome.decoration.cursor" = true;
            "userChrome.decoration.field_border" = true;
            "userChrome.decoration.download_panel" = true;
            "userChrome.decoration.animate" = true;

            "userChrome.padding.tabbar_width" = true;
            "userChrome.padding.tabbar_height" = true;
            "userChrome.padding.toolbar_button" = true;
            "userChrome.padding.navbar_width" = true;
            "userChrome.padding.urlbar" = true;
            "userChrome.padding.bookmarkbar" = true;
            "userChrome.padding.infobar" = true;
            "userChrome.padding.menu" = true;
            "userChrome.padding.bookmark_menu" = true;
            "userChrome.padding.global_menubar" = true;
            "userChrome.padding.panel" = true;
            "userChrome.padding.popup_panel" = true;

            "userChrome.tab.multi_selected" = true;
            "userChrome.tab.unloaded" = true;
            "userChrome.tab.letters_cleary" = true;
            "userChrome.tab.close_button_at_hover" = true;
            "userChrome.tab.sound_hide_label" = true;
            "userChrome.tab.sound_with_favicons" = true;
            "userChrome.tab.pip" = true;
            "userChrome.tab.container" = true;
            "userChrome.tab.crashed" = true;

            "userChrome.fullscreen.overlap" = true;
            "userChrome.fullscreen.show_bookmarkbar" = true;

            "userChrome.icon.library" = true;
            "userChrome.icon.panel" = true;
            "userChrome.icon.menu" = true;
            "userChrome.icon.context_menu" = true;
            "userChrome.icon.global_menu" = true;
            "userChrome.icon.global_menubar" = true;
            "userChrome.icon.1-25px_stroke" = true;

            "userContent.player.ui" = true;
            "userContent.player.icon" = true;
            "userContent.player.noaudio" = true;
            "userContent.player.size" = true;
            "userContent.player.click_to_play" = true;
            "userContent.player.animate" = true;
            "userContent.newTab.full_icon" = true;
            "userContent.newTab.animate" = true;
            "userContent.newTab.pocket_to_last" = true;
            "userContent.newTab.searchbar" = true;
            "userContent.page.field_border" = true;
            "userContent.page.illustration" = true;
            "userContent.page.proton_color" = true;
            "userContent.page.dark_mode" = true;
            "userContent.page.proton" = true;

          };
        };
      };
    };

}
