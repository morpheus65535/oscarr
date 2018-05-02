<html>
    <head>
        <!DOCTYPE html>
        <script src="{{base_url}}static/jquery/jquery-latest.min.js"></script>
        <script src="{{base_url}}static/semantic/semantic.min.js"></script>
        <script src="{{base_url}}static/jquery/tablesort.js"></script>
        <link rel="stylesheet" href="{{base_url}}static/semantic/semantic.min.css">

        <link rel="apple-touch-icon" sizes="180x180" href="{{base_url}}static/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="{{base_url}}static/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="{{base_url}}static/favicon-16x16.png">
        <link rel="manifest" href="{{base_url}}static/site.webmanifest">
        <link rel="mask-icon" href="{{base_url}}static/safari-pinned-tab.svg" color="#5bbad5">
        <link rel="shortcut icon" href="{{base_url}}static/favicon.ico">
        <meta name="msapplication-TileColor" content="#da532c">
        <meta name="msapplication-config" content="{{base_url}}static/browserconfig.xml">
        <meta name="theme-color" content="#ffffff">

        <title>Settings - Oscarr</title>

        <style>
            body {
                background-color: #272727;
            }
            #fondblanc {
                background-color: #ffffff;
                border-radius: 0px;
                box-shadow: 0px 0px 5px 5px #ffffff;
                margin-top: 32px;
                margin-bottom: 3em;
                padding: 1em;
            }
        </style>
    </head>
    <body>
        <div id='loader' class="ui page dimmer">
            <div class="ui indeterminate text loader">Loading...</div>
        </div>
        % include('menu.tpl')

        <div id="fondblanc" class="ui container">
            <form name="settings_form" id="settings_form" action="{{base_url}}save_settings" method="post" class="ui form">
            <div id="form_validation_error" class="ui error message">
                <p>Some fields are in error and you can't save settings until you have corrected them.</p>
            </div>
            <div class="ui top attached tabular menu">
                <a class="tabs item active" data-tab="general">General</a>
                <a class="tabs item" data-tab="plex">Plex</a>
                <a class="tabs item" data-tab="emby">Emby</a>
                <a class="tabs item" data-tab="sonarr">Sonarr</a>
                <a class="tabs item" data-tab="radarr">Radarr</a>
                <a class="tabs item" data-tab="bazarr">Bazarr</a>
            </div>

            <div class="ui bottom attached tab segment active" data-tab="general">
                <div class="ui container"><button class="submit ui blue right floated button" type="submit" value="Submit" form="settings_form">Save</button></div>
                <div class="ui dividing header">Oscarr settings</div>
                <div class="twelve wide column">
                    <div class="ui grid">
                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening IP address</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="ui fluid input">
                                        <input name="settings_general_ip" type="text" value="{{settings_general[0]}}">
                                    </div>
                                </div>
                            </div>

                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Requires restart to take effect" data-inverted="">
                                    <i class="yellow warning sign icon"></i>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Valid IP4 address or '0.0.0.0' for all interfaces" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening port</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="ui fluid input">
                                        <input name="settings_general_port" type="text" value="{{settings_general[1]}}">
                                    </div>
                                </div>
                            </div>

                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Requires restart to take effect" data-inverted="">
                                    <i class="yellow warning sign icon"></i>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Valid TCP port (default: 6767)" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Base URL</label>
                            </div>
                            <div class="five wide column">
                                <div class="ui fluid input">
                                    %if settings_general[2] == None:
                                    %	base_url = "/"
                                    %else:
                                    %	base_url = settings_general[2]
                                    %end
                                    <input name="settings_general_baseurl" type="text" value="{{base_url}}">
                                </div>
                            </div>

                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Requires restart to take effect" data-inverted="">
                                    <i class="yellow warning sign icon"></i>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="For reverse proxy support, default is '/'" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Log Level</label>
                            </div>
                            <div class="five wide column">
                                <select name="settings_general_loglevel" id="settings_loglevel" class="ui fluid selection dropdown">
                                    <option value="">Log Level</option>
                                    <option value="DEBUG">Debug</option>
                                    <option value="INFO">Info</option>
                                    <option value="WARNING">Warning</option>
                                    <option value="ERROR">Error</option>
                                    <option value="CRITICAL">Critical</option>
                                </select>
                            </div>

                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Requires restart to take effect" data-inverted="">
                                    <i class="yellow warning sign icon"></i>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Debug logging should only be enabled temporarily" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ui dividing header">Updates</div>
                <div class="twelve wide column">
                    <div class="ui grid">
                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Branch</label>
                            </div>
                            <div class="five wide column">
                                <select name="settings_general_branch" id="settings_branch" class="ui fluid selection dropdown">
                                    <option value="">Branch</option>
                                    <option value="master">master</option>
                                    <option value="development">development</option>
                                </select>
                            </div>
                            <div class="collapsed column">
                                <div class="collapsed center aligned column">
                                    <div class="ui basic icon" data-tooltip="Only select development branch if you want to live on the edge." data-inverted="">
                                        <i class="help circle large icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Automatic</label>
                            </div>
                            <div class="one wide column">
                                <div id="settings_automatic_div" class="ui toggle checkbox" data-automatic={{settings_general[5]}}>
                                    <input name="settings_general_automatic" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                            <div class="collapsed column">
                                <div class="collapsed center aligned column">
                                    <div class="ui basic icon" data-tooltip="Automatically download and install updates. You will still be able to install from System: Tasks" data-inverted="">
                                        <i class="help circle large icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ui bottom attached tab segment" data-tab="plex">
                <div class="ui container"><button class="submit ui blue right floated button" type="submit" value="Submit" form="settings_form">Save</button></div>
                <div class="ui dividing header">Plex settings</div>
                <div class="twelve wide column">
                    <div class="ui grid">
                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="settings_plex_enabled_div" class="ui toggle checkbox" data-enabled={{settings_plex[6]}}>
                                    <input name="settings_plex_enabled" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening IP address</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="plex ui fluid input">
                                        <input name="settings_plex_ip" type="text" value="{{settings_plex[0]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="IP4 address of Plex" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening port</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="plex ui fluid input">
                                        <input name="settings_plex_port" type="text" value="{{settings_plex[1]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="TCP port of Plex" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Base URL</label>
                            </div>
                            <div class="five wide column">
                                <div class="plex ui fluid input">
                                    <input name="settings_plex_baseurl" type="text" value="{{settings_plex[2]}}">
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Base URL for Plex (default: '/')" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>SSL enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="plex_ssl_div" class="plex ui toggle checkbox" data-ssl={{settings_plex[3]}}>
                                    <input name="settings_plex_ssl" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Username</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="plex ui fluid input">
                                        <input name="settings_plex_username" type="text" value="{{settings_plex[4]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Username for Plex" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Password</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="plex ui fluid input">
                                        <input name="settings_plex_password" type="password" value="{{settings_plex[5]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Username for Plex" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ui bottom attached tab segment" data-tab="emby">
                <div class="ui container"><button class="submit ui blue right floated button" type="submit" value="Submit" form="settings_form">Save</button></div>
                <div class="ui dividing header">Emby settings</div>
                <div class="twelve wide column">
                    <div class="ui grid">
                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="settings_emby_enabled_div" class="ui toggle checkbox" data-enabled={{settings_emby[6]}}>
                                    <input name="settings_emby_enabled" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening IP address</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="emby ui fluid input">
                                        <input name="settings_emby_ip" type="text" value="{{settings_emby[0]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="IP4 address of Emby" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening port</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="emby ui fluid input">
                                        <input name="settings_emby_port" type="text" value="{{settings_emby[1]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="TCP port of Emby" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Base URL</label>
                            </div>
                            <div class="five wide column">
                                <div class="emby ui fluid input">
                                    <input name="settings_emby_baseurl" type="text" value="{{settings_emby[2]}}">
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Base URL for Emby (default: '/')" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>SSL enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="emby_ssl_div" class="emby ui toggle checkbox" data-ssl={{settings_emby[3]}}>
                                    <input name="settings_emby_ssl" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>User ID</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="emby ui fluid input">
                                        <input name="settings_emby_userid" type="text" value="{{settings_emby[4]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="User ID for Emby (32 alphanumeric characters)" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>API key</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="emby ui fluid input">
                                        <input name="settings_emby_apikey" type="text" value="{{settings_emby[5]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="API key for Emby (32 alphanumeric characters)" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ui bottom attached tab segment" data-tab="sonarr">
                <div class="ui container"><button class="submit ui blue right floated button" type="submit" value="Submit" form="settings_form">Save</button></div>
                <div class="ui dividing header">Sonarr settings</div>
                <div class="twelve wide column">
                    <div class="ui grid">
                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="settings_sonarr_enabled_div" class="ui toggle checkbox" data-enabled={{settings_sonarr[5]}}>
                                    <input name="settings_sonarr_enabled" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening IP address</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="sonarr ui fluid input">
                                        <input name="settings_sonarr_ip" type="text" value="{{settings_sonarr[0]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="IP4 address of Sonarr" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening port</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="sonarr ui fluid input">
                                        <input name="settings_sonarr_port" type="text" value="{{settings_sonarr[1]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="TCP port of Sonarr" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Base URL</label>
                            </div>
                            <div class="five wide column">
                                <div class="sonarr ui fluid input">
                                    <input name="settings_sonarr_baseurl" type="text" value="{{settings_sonarr[2]}}">
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Base URL for Sonarr (default: '/')" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>SSL enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="sonarr_ssl_div" class="sonarr ui toggle checkbox" data-ssl={{settings_sonarr[3]}}>
                                    <input name="settings_sonarr_ssl" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>API key</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="sonarr ui fluid input">
                                        <input name="settings_sonarr_apikey" type="text" value="{{settings_sonarr[4]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="API key for Sonarr (32 alphanumeric characters)" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ui bottom attached tab segment" data-tab="radarr">
                <div class="ui container"><button class="submit ui blue right floated button" type="submit" value="Submit" form="settings_form">Save</button></div>
                <div class="ui dividing header">Radarr settings</div>
                <div class="twelve wide column">
                    <div class="ui grid">
                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="settings_radarr_enabled_div" class="ui toggle checkbox" data-enabled={{settings_radarr[5]}}>
                                    <input name="settings_radarr_enabled" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening IP address</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="radarr ui fluid input">
                                        <input name="settings_radarr_ip" type="text" value="{{settings_radarr[0]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="IP4 address of Radarr" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening port</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="radarr ui fluid input">
                                        <input name="settings_radarr_port" type="text" value="{{settings_radarr[1]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="TCP port of Radarr" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Base URL</label>
                            </div>
                            <div class="five wide column">
                                <div class="radarr ui fluid input">
                                    <input name="settings_radarr_baseurl" type="text" value="{{settings_radarr[2]}}">
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Base URL for Radarr (default: '/')" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>SSL enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="radarr_ssl_div" class="radarr ui toggle checkbox" data-ssl={{settings_radarr[3]}}>
                                    <input name="settings_radarr_ssl" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>API key</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="radarr ui fluid input">
                                        <input name="settings_radarr_apikey" type="text" value="{{settings_radarr[4]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="API key for Radarr (32 alphanumeric characters)" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ui bottom attached tab segment" data-tab="bazarr">
                <div class="ui container"><button class="submit ui blue right floated button" type="submit" value="Submit" form="settings_form">Save</button></div>
                <div class="ui dividing header">Bazarr settings</div>
                <div class="twelve wide column">
                    <div class="ui grid">
                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Enabled</label>
                            </div>
                            <div class="one wide column">
                                <div id="settings_bazarr_enabled_div" class="ui toggle checkbox" data-enabled={{settings_bazarr[4]}}>
                                    <input name="settings_bazarr_enabled" type="checkbox">
                                    <label></label>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening IP address</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="bazarr ui fluid input">
                                        <input name="settings_bazarr_ip" type="text" value="{{settings_bazarr[0]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="IP4 address of Bazarr" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Listening port</label>
                            </div>
                            <div class="five wide column">
                                <div class='field'>
                                    <div class="bazarr ui fluid input">
                                        <input name="settings_bazarr_port" type="text" value="{{settings_bazarr[1]}}">
                                    </div>
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="TCP port of Bazarr" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="middle aligned row">
                            <div class="right aligned four wide column">
                                <label>Base URL</label>
                            </div>
                            <div class="five wide column">
                                <div class="bazarr ui fluid input">
                                    <input name="settings_bazarr_baseurl" type="text" value="{{settings_bazarr[2]}}">
                                </div>
                            </div>
                            <div class="collapsed center aligned column">
                                <div class="ui basic icon" data-tooltip="Base URL for Bazarr (default: '/')" data-inverted="">
                                    <i class="help circle large icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            </form>
        </div>
        % include('footer.tpl')
    </body>
</html>


<script>
    $('.menu .item').tab();

    $('a:not(.tabs), button:not(.cancel)').click(function(){
        $('#loader').addClass('active');
    })

    $('a[target="_blank"]').click(function(){
        $('#loader').removeClass('active');
    })

    if ($('#plex_ssl_div').data("ssl") == "True") {
                $("#plex_ssl_div").checkbox('check');
            } else {
                $("#plex_ssl_div").checkbox('uncheck');
            }

    if ($('#settings_plex_enabled_div').data("enabled") == "on") {
                $("#settings_plex_enabled_div").checkbox('check');
            } else {
                $("#settings_plex_enabled_div").checkbox('uncheck');
            }

    if ($('#emby_ssl_div').data("ssl") == "True") {
                $("#emby_ssl_div").checkbox('check');
            } else {
                $("#emby_ssl_div").checkbox('uncheck');
            }

    if ($('#settings_emby_enabled_div').data("enabled") == "on") {
                $("#settings_emby_enabled_div").checkbox('check');
            } else {
                $("#settings_emby_enabled_div").checkbox('uncheck');
            }

    if ($('#sonarr_ssl_div').data("ssl") == "True") {
                $("#sonarr_ssl_div").checkbox('check');
            } else {
                $("#sonarr_ssl_div").checkbox('uncheck');
            }

    if ($('#settings_sonarr_enabled_div').data("enabled") == "on") {
                $("#settings_sonarr_enabled_div").checkbox('check');
            } else {
                $("#settings_sonarr_enabled_div").checkbox('uncheck');
            }

    if ($('#radarr_ssl_div').data("ssl") == "True") {
                $("#radarr_ssl_div").checkbox('check');
            } else {
                $("#radarr_ssl_div").checkbox('uncheck');
            }

    if ($('#settings_radarr_enabled_div').data("enabled") == "on") {
                $("#settings_radarr_enabled_div").checkbox('check');
            } else {
                $("#settings_radarr_enabled_div").checkbox('uncheck');
            }

    if ($('#settings_automatic_div').data("automatic") == "True") {
                $("#settings_automatic_div").checkbox('check');
            } else {
                $("#settings_automatic_div").checkbox('uncheck');
            }

    if ($('#settings_bazarr_enabled_div').data("enabled") == "on") {
                $("#settings_bazarr_enabled_div").checkbox('check');
            } else {
                $("#settings_bazarr_enabled_div").checkbox('uncheck');
            }

    $('#settings_loglevel').dropdown('clear');
    $('#settings_loglevel').dropdown('set selected','{{!settings_general[3]}}');
    $('#settings_loglevel').dropdown();

    $('#settings_branch').dropdown('clear');
    $('#settings_branch').dropdown('set selected','{{!settings_general[4]}}');
    $('#settings_branch').dropdown();

    $('#settings_plex_enabled_div').checkbox({
        fireOnInit: true,
        onChecked: function() {
            $('.plex').removeClass('disabled');
        },
        onUnchecked: function() {
            $('.plex').addClass('disabled');
        }
    });

    $('#settings_emby_enabled_div').checkbox({
        fireOnInit: true,
        onChecked: function() {
            $('.emby').removeClass('disabled');
        },
        onUnchecked: function() {
            $('.emby').addClass('disabled');
        }
    });

    $('#settings_sonarr_enabled_div').checkbox({
        fireOnInit: true,
        onChecked: function() {
            $('.sonarr').removeClass('disabled');
        },
        onUnchecked: function() {
            $('.sonarr').addClass('disabled');
        }
    });

    $('#settings_radarr_enabled_div').checkbox({
        fireOnInit: true,
        onChecked: function() {
            $('.radarr').removeClass('disabled');
        },
        onUnchecked: function() {
            $('.radarr').addClass('disabled');
        }
    });

    $('#settings_bazarr_enabled_div').checkbox({
        fireOnInit: true,
        onChecked: function() {
            $('.bazarr').removeClass('disabled');
        },
        onUnchecked: function() {
            $('.bazarr').addClass('disabled');
        }
    });
</script>

<script>
    // form validation
    $('#settings_form')
        .form({
            fields: {
                settings_general_ip : {
                    rules : [
                        {
                            type : 'regExp[/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/]'
                        },
                        {
                            type: 'empty'
                        }
                    ]
                },
                settings_general_port : {
                    rules : [
                        {
                            type : 'integer[1..65535]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_plex_ip : {
                    depends : 'settings_plex_enabled',
                    rules : [
                        {
                            type : 'regExp[/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_plex_port : {
                    depends : 'settings_plex_enabled',
                    rules : [
                        {
                            type : 'integer[1..65535]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_plex_username : {
                    depends : 'settings_plex_enabled',
                    rules : [
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_plex_password : {
                    depends : 'settings_plex_enabled',
                    rules : [
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_emby_ip : {
                    depends : 'settings_emby_enabled',
                    rules : [
                        {
                            type : 'regExp[/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_emby_port : {
                    depends : 'settings_emby_enabled',
                    rules : [
                        {
                            type : 'integer[1..65535]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_emby_apikey : {
                    depends : 'settings_emby_enabled',
                    rules : [
                        {
                            type : 'exactLength[32]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_emby_userid: {
                    depends : 'settings_emby_enabled',
                    rules : [
                        {
                            type : 'exactLength[32]'
                        },
                        {
                            type :  'empty'
                        }
                    ]
                },
                settings_sonarr_ip : {
                    depends : 'settings_emby_enabled',
                    rules : [
                        {
                            type : 'regExp[/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_sonarr_port : {
                    depends : 'settings_emby_enabled',
                    rules : [
                        {
                            type : 'integer[1..65535]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_sonarr_apikey : {
                    depends : 'settings_emby_enabled',
                    rules : [
                        {
                            type : 'exactLength[32]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_radarr_ip : {
                    depends : 'settings_radarr_enabled',
                    rules : [
                        {
                            type : 'regExp[/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_radarr_port : {
                    depends : 'settings_radarr_enabled',
                    rules : [
                        {
                            type : 'integer[1..65535]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_radarr_apikey : {
                    depends : 'settings_radarr_enabled',
                    rules : [
                        {
                            type : 'exactLength[32]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_bazarr_ip : {
                    depends : 'settings_bazarr_enabled',
                    rules : [
                        {
                            type : 'regExp[/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                },
                settings_bazarr_port : {
                    depends : 'settings_bazarr_enabled',
                    rules: [
                        {
                            type : 'integer[1..65535]'
                        },
                        {
                            type : 'empty'
                        }
                    ]
                }
            },
            inline : true,
            on     : 'blur',
            onFailure: function(){
                $('#form_validation_error').show();
                $('.submit').addClass('disabled');
                return false;
            },
            onSuccess: function(){
                $('#form_validation_error').hide();
                $('#loader').addClass('active');
                $('.submit').removeClass('disabled');
            }
        })
    ;

    $('.submit').click(function() {
        alert('Settings saved.');
    })

    $( document ).ready(function() {
        $('.form').form('validate form');
        $('#loader').removeClass('active');
    })

    $('#settings_form').focusout(function() {
        $('.form').form('validate form');
        $('#loader').removeClass('active');
    })
</script>