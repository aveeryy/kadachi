{ ... }:
{
  flake-file.inputs.rycee-nur = {
    url = "gitlab:rycee/nur-expressions";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.web-browsers._.firefox.homeManager =
    {
      config,
      pkgs,
      inputs',
      ...
    }:
    {
      programs.firefox = {
        enable = true;
        profiles.Avery = {
          isDefault = true;
          extensions = {
            force = true;
            packages = with inputs'.rycee-nur.legacyPackages.firefox-addons; [
              bitwarden
              catppuccin-mocha-mauve
              catppuccin-web-file-icons
              consent-o-matic
              # Gaslight Nix into thinking it's a free package
              (kagi-translate.overrideAttrs { meta.license.free = true; })
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
            # Extensions
            "extensions.autoDisableScopes" = 0;
            "extensions.update.autoUpdateDefault" = false;
            "extensions.update.enabled" = false;
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
            "network.http.referer.trimmingPolicy" = 0;
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
            # JPEG XL
            "browser.download.viewableInternally.typeWasRegistered.jxl" = true;
            "image.jxl.enabled" = true;
            # Browser UI customization
            "browser.compactmode.show" = true;
            "browser.display.use_document_fonts" = 0;
            "browser.uiCustomization.state" = builtins.toJSON {
              currentVersion = 25;
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
            # Vertical tabs
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "browser.uiCustomization.horizontalTabstrip" = builtins.toJSON [
              "tabbrowser-tabs"
            ];
          };
        };
      };
    };

}
