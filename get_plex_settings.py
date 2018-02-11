import sqlite3
import os
import requests
import logging

def get_plex_settings():
    # Open database connection
    db = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = db.cursor()

    # Get plex API URL from database config table
    c.execute('''SELECT * FROM table_settings_plex''')
    config_plex = c.fetchone()

    # Close database connection
    db.close()

    # Build plex URL
    ip_plex = config_plex[0]
    port_plex = str(config_plex[1])
    baseurl_plex = config_plex[2]
    ssl_plex = config_plex[3]
    username_plex = config_plex[4]
    password_plex = config_plex[5]

    if ssl_plex == 1:
        protocol_plex = "https"
    else:
        protocol_plex = "http"

    if baseurl_plex is None:
        baseurl_plex = "/"
    if not baseurl_plex.startswith("/"):
        baseurl_plex = "/" + baseurl_plex
    if baseurl_plex.endswith("/"):
        baseurl_plex = baseurl_plex[:-1]

    url_plex = protocol_plex + "://" + ip_plex + ":" + port_plex + baseurl_plex

    headers = {'X-Plex-Client-Identifier': 'Oscarr', 'X-Plex-Product': 'Oscarr', 'X-Plex-Version': '0.0.1'}

    if 'apikey_plex' in globals() and apikey_plex is not None:
        pass
    else:
        try:
            result = requests.post("https://plex.tv/users/sign_in.json?user[login]=" + username_plex + "&user[password]=" + password_plex, headers=headers).json()
        except:
            logging.error('Cannot open connection to Plex.tv.')
        else:
            global apikey_plex
            try:
                apikey_plex = result['user']['authToken']
            except:
                apikey_plex = None
                logging.error('Cannot get authentication token from Plex.tv.')

    return [url_plex, apikey_plex]
