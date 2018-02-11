import sqlite3
import os

def get_emby_settings():
    # Open database connection
    db = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = db.cursor()

    # Get emby API URL from database config table
    c.execute('''SELECT * FROM table_settings_emby''')
    config_emby = c.fetchone()

    # Close database connection
    db.close()

    # Build emby URL
    ip_emby = config_emby[0]
    port_emby = str(config_emby[1])
    baseurl_emby = config_emby[2]
    ssl_emby = config_emby[3]
    userid = config_emby[4]
    apikey_emby = config_emby[5]

    if ssl_emby == 1:
        protocol_emby = "https"
    else:
        protocol_emby = "http"

    if baseurl_emby is None:
        baseurl_emby = "/"
    if not baseurl_emby.startswith("/"):
        baseurl_emby = "/" + baseurl_emby
    if baseurl_emby.endswith("/"):
        baseurl_emby = baseurl_emby[:-1]

    url_emby = protocol_emby + "://" + ip_emby + ":" + port_emby + baseurl_emby
    url_emby_user = protocol_emby + "://" + ip_emby + ":" + port_emby + baseurl_emby + '/Users/' + userid

    return [url_emby, url_emby_user, apikey_emby]