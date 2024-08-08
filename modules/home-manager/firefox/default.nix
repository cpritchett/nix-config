### Does not work on darwin
### Will expand with more options as I use different css







### currently broken



{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.cpritchett.firefox;
in
{
  options.cpritchett.firefox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom firefox module
      '';
    };
  };

  config = mkIf (cfg.enable && pkgs.system != "aarch64-darwin") {
    programs.firefox = {
      package = pkgs.firefox.override {
        extraPolicies = {
          # CaptivePortal = false;
          DisableFirefoxStudies = true;
          # DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
          FirefoxHome = {
              Search = true;
              Pocket = false;
              Snippets = false;
              TopSites = false;
              Highlights = false;
          };
          UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
          };
          Preferences = {
            "browser.toolbars.bookmarks.visibility" = "never";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "media.ffmpeg.vaapi.enabled" = true;
          };
        };
      };
      enable = true;
      profiles.default = {
        id = 0;
        name = "Default";
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            onepassword-password-manager
            darkreader
        ];
        search = {
            force = true;
            default = "DuckDuckGo";
        };
        settings = {
            "general.smoothScroll" = true;
        };
### Pick user chrome css here
        userChrome = ''
                /*========================================================================================================*

                  +-----+-----+-----+-----+-----+-----+-----+
                  | █▀▀ | ▄▀█ | █▀▀ | █▀▀ | ▄▀█ | █▀▄ | █▀▀ |
                  | █▄▄ | █▀█ | ▄▄█ | █▄▄ | █▀█ | █▄▀ | ██▄ |
                  +-----+-----+-----+-----+-----+-----+-----+ Mouse Edition.


                    Description:    Cascade, Mouse Edition, is a Firefox Style based on the Cascade theme by Andreas Grafen
                                    What you get is a really simple one-line layout using the new Proton UI.

                                  The original Cascade Theme by Andreas Grafen was based on SimpleFox :
                                  > SimpleFox: https://github.com/migueravila/SimpleFox


                    Authors:        Andreas Grafen (original cascade theme)
                                    (https://andreas.grafen.info)

                                Clément Rambaud (minor tweaks on the original file)


                    Repository:     https://github.com/andreasgrafen/cascade
                                  https://github.com/crambaud/cascade

                *========================================================================================================*/


                /*---+---+---+---+---+---+
                | C | O | N | F | I | G |
                +---+---+---+---+---+---*/

                /* Feel free to tweak the following
                * config settingsto your own liking. */


                :root {
                    
                    /*---+---+---+---+---+---+---+
                    | C | O | L | O | U | R | S |
                    +---+---+---+---+---+---+---*/

                    /* Comment the color theme you don't want to use */

                    /* Dark Theme Colors */
                    --window-colour:               #1f2122;
                    --secondary-colour:            #141616;
                    --inverted-colour:             #FAFAFC;

                    /* Light Theme Colors
                    --window-colour:               #FAFAFC;
                    --secondary-colour:            #EAEAEC;
                    --inverted-colour:             #1E2021;
                    */

                    
                    /* Containter Tab Colours */
                    --uc-identity-color-blue:      #7ED6DF;
                    --uc-identity-color-turquoise: #55E6C1;
                    --uc-identity-color-green:     #B8E994;
                    --uc-identity-color-yellow:    #F7D794;
                    --uc-identity-color-orange:    #F19066;
                    --uc-identity-color-red:       #FC5C65;
                    --uc-identity-color-pink:      #F78FB3;
                    --uc-identity-color-purple:    #786FA6;
                    
                    
                    /* URL colour in URL bar suggestions */
                    --urlbar-popup-url-color: var(--uc-identity-color-purple) !important;
                    
                    
                    
                    /*---+---+---+---+---+---+---+
                    | V | I | S | U | A | L | S |
                    +---+---+---+---+---+---+---*/
                    
                    /* global border radius */
                    --uc-border-radius: 0;
                    
                    /* dynamic url bar width settings */
                    --uc-urlbar-width: clamp(250px, 50vw, 600px);

                    /* dynamic tab width settings */
                    --uc-active-tab-width:   clamp( 50px, 18vw, 220px);
                    --uc-inactive-tab-width: clamp( 50px, 15vw, 200px);

                    /* if active always shows the tab close button */
                    --show-tab-close-button: none; /* DEFAULT: -moz-inline-box; */ 

                    /* if active only shows the tab close button on hover*/
                    --show-tab-close-button-hover: -moz-inline-box; /* DEFAULT: -moz-inline-box; */

                    /* adds left and right margin to the container-tabs indicator */
                    --container-tabs-indicator-margin: 0px;

                }

                    /*---+---+---+---+---+---+---+
                    | B | U | T | T | O | N | S |
                    +---+---+---+---+---+---+---*/

                    /* showing only the back button */
                    #back-button{ display: -moz-inline-box !important; }
                    #forward-button{ display: none !important; }
                    #stop-button{ display: none !important; }
                    #reload-button{ display: none !important; }

                    /* bookmark icon */
                    #star-button{ display: none !important; }

                    /* zoom indicator */
                    #urlbar-zoom-button { display: none !important; }

                    /* Show Hamburger Menu */
                    #PanelUI-button { display: -moz-inline-box !important;}

                    #reader-mode-button{ display: none !important; }

                    /* tracking protection shield icon */
                    #tracking-protection-icon-container { display: none !important; }

                    /* #identity-box { display: none !important } /* hides encryption AND permission items */
                    #identity-permission-box { display: none !important; } /* only hides permission items */

                    /* e.g. playing indicator (secondary - not icon) */
                    .tab-secondary-label { display: none !important; }

                    #pageActionButton { display: none !important; }
                    #page-action-buttons { display: none !important; }





                /*=============================================================================================*/


                /*---+---+---+---+---+---+
                | L | A | Y | O | U | T |
                +---+---+---+---+---+---*/

                /* No need to change anything below this comment.
                * Just tweak it if you want to tweak the overall layout. c: */

                :root {
                    
                    --uc-theme-colour:                          var(--window-colour);
                    --uc-hover-colour:                          var(--secondary-colour);
                    --uc-inverted-colour:                       var(--inverted-colour);
                    
                    --button-bgcolor:                           var(--uc-theme-colour)    !important;
                    --button-hover-bgcolor:                     var(--uc-hover-colour)    !important;
                    --button-active-bgcolor:                    var(--uc-hover-colour)    !important;
                    
                    --toolbar-bgcolor:                          var(--uc-theme-colour)    !important;
                    --toolbarbutton-hover-background:           var(--uc-hover-colour)    !important;
                    --toolbarbutton-active-background:          var(--uc-hover-colour)    !important;
                    --toolbarbutton-border-radius:              var(--uc-border-radius)   !important;
                    --lwt-toolbar-field-focus:                  var(--uc-theme-colour)    !important;
                    --toolbarbutton-icon-fill:                  var(--uc-inverted-colour) !important;
                    --toolbar-field-focus-background-color:     var(--secondary-colour)   !important;
                    --toolbar-field-color:                      var(--uc-inverted-colour) !important;
                    --toolbar-field-focus-color:                var(--uc-inverted-colour) !important;
                    
                    --tabs-border-color:                        var(--uc-theme-colour)    !important;
                    --tab-border-radius:                        var(--uc-border-radius)   !important;
                    --lwt-text-color:                           var(--uc-inverted-colour) !important;
                    --lwt-tab-text:                             var(--uc-inverted-colour) !important;

                    --lwt-sidebar-background-color:             var(--uc-hover-colour)    !important;
                    --lwt-sidebar-text-color:                   var(--uc-inverted-colour) !important;
                  
                    --arrowpanel-border-color:                  var(--uc-theme-colour)    !important;
                    --arrowpanel-border-radius:                 var(--uc-border-radius)   !important;
                    --arrowpanel-background:                    var(--uc-theme-colour)    !important;
                    --arrowpanel-color:                         var(--inverted-colour)    !important;

                    --autocomplete-popup-highlight-background:  var(--uc-inverted-colour) !important;
                    --autocomplete-popup-highlight-color:       var(--uc-inverted-colour) !important;
                    --autocomplete-popup-hover-background:      var(--uc-inverted-colour) !important;
                    

                    --tab-block-margin: 2px !important;
                    
                }





                window,
                #main-window,
                #toolbar-menubar,
                #TabsToolbar,
                #PersonalToolbar,
                #navigator-toolbox,
                #sidebar-box,
                #nav-bar {

                    -moz-appearance: none !important;
                    
                    border: none !important;
                    box-shadow: none !important;
                    background: var(--uc-theme-colour) !important;

                }





                /* grey out ccons inside the toolbar to make it
                * more aligned with the Black & White colour look */
                #PersonalToolbar toolbarbutton:not(:hover),
                #bookmarks-toolbar-button:not(:hover) { filter: grayscale(1) !important; }


                /* Show Window Control Button */
                .titlebar-buttonbox-container { display: -moz-inline-box !important; }


                /* remove "padding" left and right from tabs */
                .titlebar-spacer { display: none !important; }


                /* remove gap after pinned tabs */
                #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
                    > #tabbrowser-arrowscrollbox
                    > .tabbrowser-tab[first-visible-unpinned-tab] { margin-inline-start: 0 !important; }


                /* remove tab shadow */
                .tabbrowser-tab
                    >.tab-stack
                    > .tab-background { box-shadow: none !important;  }


                /* tab background */
                .tabbrowser-tab
                    > .tab-stack
                    > .tab-background { background: var(--uc-theme-colour) !important; }


                /* active tab background */
                .tabbrowser-tab[selected]
                    > .tab-stack
                    > .tab-background { background: var(--uc-hover-colour) !important; }


                /* tab close button options */
                .tabbrowser-tab:not([pinned]) .tab-close-button { display: var(--show-tab-close-button) !important; }
                .tabbrowser-tab:not([pinned]):hover .tab-close-button { display: var(--show-tab-close-button-hover) !important }


                /* adaptive tab width */
                .tabbrowser-tab[selected][fadein]:not([pinned]) { max-width: var(--uc-active-tab-width) !important; }
                .tabbrowser-tab[fadein]:not([selected]):not([pinned]) { max-width: var(--uc-inactive-tab-width) !important; }


                /* container tabs indicator */
                .tabbrowser-tab[usercontextid]
                    > .tab-stack
                    > .tab-background
                    > .tab-context-line {
                    
                        margin: -1px var(--container-tabs-indicator-margin) 0 var(--container-tabs-indicator-margin) !important;

                        border-radius: var(--tab-border-radius) !important;

                }


                /* show favicon when media is playing but tab is hovered */
                .tab-icon-image:not([pinned]) { opacity: 1 !important; }


                /* Makes the speaker icon to always appear if the tab is playing (not only on hover) */
                .tab-icon-overlay:not([crashed]),
                .tab-icon-overlay[pinned][crashed][selected] {

                  top: 5px !important;
                  z-index: 1 !important;

                  padding: 1.5px !important;
                  inset-inline-end: -8px !important;
                  width: 16px !important; height: 16px !important;

                  border-radius: 10px !important;

                }


                /* style and position speaker icon */
                .tab-icon-overlay:not([sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) {

                  stroke: transparent !important;
                  background: transparent !important;
                  opacity: 1 !important; fill-opacity: 0.8 !important;

                  color: currentColor !important;
                    
                  stroke: var(--uc-theme-colour) !important;
                  background-color: var(--uc-theme-colour) !important;

                }


                /* change the colours of the speaker icon on active tab to match tab colours */
                .tabbrowser-tab[selected] .tab-icon-overlay:not([sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) {
                        
                  stroke: var(--uc-hover-colour) !important;
                  background-color: var(--uc-hover-colour) !important;

                }


                .tab-icon-overlay:not([pinned], [sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) { margin-inline-end: 9.5px !important; }


                .tabbrowser-tab:not([image]) .tab-icon-overlay:not([pinned], [sharing], [crashed]) {

                  top: 0 !important;

                  padding: 0 !important;
                  margin-inline-end: 5.5px !important; 
                  inset-inline-end: 0 !important;

                }


                .tab-icon-overlay:not([crashed])[soundplaying]:hover,
                .tab-icon-overlay:not([crashed])[muted]:hover,
                .tab-icon-overlay:not([crashed])[activemedia-blocked]:hover {
                    
                    color: currentColor !important;
                    stroke: var(--uc-inverted-colour) !important;
                    background-color: var(--uc-inverted-colour) !important;
                    fill-opacity: 0.95 !important;
                    
                }


                .tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[soundplaying]:hover,
                .tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[muted]:hover,
                .tabbrowser-tab[selected] .tab-icon-overlay:not([crashed])[activemedia-blocked]:hover {
                    
                    color: currentColor !important;
                    stroke: var(--uc-inverted-colour) !important;
                    background-color: var(--uc-inverted-colour) !important;
                    fill-opacity: 0.95 !important;
                    
                }


                /* speaker icon colour fix */
                #TabsToolbar .tab-icon-overlay:not([crashed])[soundplaying],
                #TabsToolbar .tab-icon-overlay:not([crashed])[muted],
                #TabsToolbar .tab-icon-overlay:not([crashed])[activemedia-blocked] { color: var(--uc-inverted-colour) !important; }


                /* speaker icon colour fix on hover */
                #TabsToolbar .tab-icon-overlay:not([crashed])[soundplaying]:hover,
                #TabsToolbar .tab-icon-overlay:not([crashed])[muted]:hover,
                #TabsToolbar .tab-icon-overlay:not([crashed])[activemedia-blocked]:hover { color: var(--uc-theme-colour) !important; }





                #nav-bar {

                    border:     none !important;
                    box-shadow: none !important;
                    background: transparent !important;

                }


                /* remove border below whole nav */
                #navigator-toolbox { border-bottom: none !important; }


                #urlbar,
                #urlbar * { box-shadow: none !important; }


                #urlbar-background { border: var(--uc-hover-colour) !important; }


                #urlbar[focused="true"]
                    > #urlbar-background,
                #urlbar:not([open])
                    > #urlbar-background { background: transparent !important; }


                #urlbar[open]
                    > #urlbar-background { background: var(--uc-theme-colour) !important; }


                .urlbarView-row:hover
                    > .urlbarView-row-inner,
                .urlbarView-row[selected]
                    > .urlbarView-row-inner { background: var(--uc-hover-colour) !important; }
                    




                /* transition to oneline */
                @media (min-width: 1000px) { 
                    

                    /* move tabs bar over */
                    #TabsToolbar { margin-left: var(--uc-urlbar-width) !important; }


                    /* move entire nav bar  */
                    #nav-bar { margin: calc((var(--urlbar-min-height) * -1) - 8px) calc(100vw - var(--uc-urlbar-width)) 0 0 !important; }


                } /* end media query */





                /* Container Tabs */
                .identity-color-blue      { --identity-tab-color: var(--uc-identity-color-blue)      !important; --identity-icon-color: var(--uc-identity-color-blue)      !important; }
                .identity-color-turquoise { --identity-tab-color: var(--uc-identity-color-turquoise) !important; --identity-icon-color: var(--uc-identity-color-turquoise) !important; }
                .identity-color-green     { --identity-tab-color: var(--uc-identity-color-green)     !important; --identity-icon-color: var(--uc-identity-color-green)     !important; }
                .identity-color-yellow    { --identity-tab-color: var(--uc-identity-color-yellow)    !important; --identity-icon-color: var(--uc-identity-color-yellow)    !important; }
                .identity-color-orange    { --identity-tab-color: var(--uc-identity-color-orange)    !important; --identity-icon-color: var(--uc-identity-color-orange)    !important; }
                .identity-color-red       { --identity-tab-color: var(--uc-identity-color-red)       !important; --identity-icon-color: var(--uc-identity-color-red)       !important; }
                .identity-color-pink      { --identity-tab-color: var(--uc-identity-color-pink)      !important; --identity-icon-color: var(--uc-identity-color-pink)      !important; }
                .identity-color-purple    { --identity-tab-color: var(--uc-identity-color-purple)    !important; --identity-icon-color: var(--uc-identity-color-purple)    !important; }
                '';
      };
    };
  };
}