<html>
    <head>
        <!DOCTYPE html>
        <style>
            body {
                background-color: #272727;
            }
            .massive.menu {
                background: #272727 !important;
            }
    	    #divmenu {
                background: #272727 !important;
                padding-top: 2em;
                padding-bottom: 1em;
                padding-left: 1em;
                padding-right: 128px;
            }
            .item {
                opacity: 0.8;
            }
            .prompt {
                background-color: #333333 !important;
                color: white !important;
                border-radius: 3px !important;
            }
            .searchicon {
                color: white !important;
            }
        </style>
    </head>
    <body>
        % import os
        % import sqlite3

        % conn = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
        % c = conn.cursor()

        <div id="divmenu" class="ui container">
            <div class="ui grid">
                <div class="middle aligned row">
                    <div class="three wide column">
                        <a href="{{base_url}}"><img class="logo" src="{{base_url}}static/logo128.png"></a>
                    </div>

                    <div class="twelve wide column">
                        <div class="ui grid">
                            <div class="row">
                                <div class="sixteen wide column">
                                    <div class="ui inverted borderless labeled icon massive menu six item">
                                        <div class="ui container">
                                            % plex_enabled = c.execute("SELECT enabled FROM table_settings_plex").fetchone()
                                            % if plex_enabled[0] == "on":
                                            <a id="Plex" class="item" href="{{base_url}}plex">
                                                <img class="ui image" src="{{base_url}}static/logos/plex.png" style="margin-bottom:6px;">
                                                Plex
                                            </a>
                                            %end
                                            % emby_enabled = c.execute("SELECT enabled FROM table_settings_emby").fetchone()
                                            % if emby_enabled[0] == "on":
                                            <a id="Emby" class="item" href="{{base_url}}emby">
                                                <img class="ui image" src="{{base_url}}static/logos/emby.png" style="margin-bottom:6px;">
                                                Emby
                                            </a>
                                            %end
                                            % sonarr_enabled = c.execute("SELECT enabled FROM table_settings_sonarr").fetchone()
                                            % if sonarr_enabled[0] == "on":
                                            <a id="Sonarr" class="item" href="{{base_url}}sonarr">
                                                <img class="ui image" src="{{base_url}}static/logos/sonarr.png" style="margin-bottom:6px;">
                                                Sonarr
                                            </a>
                                            %end
                                            % radarr_enabled = c.execute("SELECT enabled FROM table_settings_radarr").fetchone()
                                            % if radarr_enabled[0] == "on":
                                            <a id="Radarr" class="item" href="{{base_url}}radarr">
                                                <img class="ui image" src="{{base_url}}static/logos/radarr.png" style="margin-bottom:6px;">
                                                Radarr
                                            </a>
                                            %end
                                            % bazarr_enabled = c.execute("SELECT enabled FROM table_settings_bazarr").fetchone()
                                            % if bazarr_enabled[0] == "on":
                                            <a id="Bazarr" class="item" href="{{base_url}}bazarr">
                                                <img class="ui image" src="{{base_url}}static/logos/bazarr.png" style="margin-bottom:6px;">
                                                Bazarr
                                            </a>
                                            %end
                                            <a id="Settings" class="item" href="{{base_url}}settings">
                                                <i class="settings icon"></i>
                                                Settings
                                            </a>
                                            <a id="System" class="item" href="{{base_url}}system">
                                                <i class="laptop icon"></i>
                                                System
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        % restart_required = c.execute("SELECT updated, configured FROM table_settings_general").fetchone()
        % c.close()

        % if restart_required[0] == 1 and restart_required[1] == 1:
            <div class='ui center aligned grid'><div class='fifteen wide column'><div class="ui red message">Oscarr need to be restarted to apply last update and changes to general settings.</div></div></div>
        % elif restart_required[0] == 1:
            <div class='ui center aligned grid'><div class='fifteen wide column'><div class="ui red message">Oscarr need to be restarted to apply last update.</div></div></div>
        % elif restart_required[1] == 1:
            <div class='ui center aligned grid'><div class='fifteen wide column'><div class="ui red message">Oscarr need to be restarted to apply changes to general settings.</div></div></div>
        % end
    </body>
</html>

<script>
    page = document.title.split(" ")[0];
    $( "#" + page ).css( "background", "rgba(255,255,255,.08)" );
</script>