import sqlite3
import os

def get_bazarr_settings():
    # Open database connection
    db = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = db.cursor()

    # Get bazarr API URL from database config table
    c.execute('''SELECT * FROM table_settings_bazarr''')
    config_bazarr = c.fetchone()

    # Close database connection
    db.close()

    # Build bazarr URL
    ip_bazarr = config_bazarr[0]
    port_bazarr = str(config_bazarr[1])
    baseurl_bazarr = config_bazarr[2]

    #if ssl_bazarr == 1:
    #    protocol_bazarr = "https"
    #else:
    #    protocol_bazarr = "http"
    protocol_bazarr = "http"

    if baseurl_bazarr is None:
        baseurl_bazarr = "/"
    if not baseurl_bazarr.startswith("/"):
        baseurl_bazarr = "/" + baseurl_bazarr
    if baseurl_bazarr.endswith("/"):
        baseurl_bazarr = baseurl_bazarr[:-1]

    url_bazarr = protocol_bazarr + "://" + ip_bazarr + ":" + port_bazarr + baseurl_bazarr

    return [url_bazarr]