import sqlite3
import os

def get_general_settings():
    # Open database connection
    db = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = db.cursor()

    # Get general settings from database table
    c.execute("SELECT * FROM table_settings_general")
    general_settings = c.fetchone()

    # Close database connection
    db.close()

    ip = general_settings[0]
    port = general_settings[1]
    base_url = general_settings[2]
    log_level = general_settings[3]
    branch = general_settings[4]
    automatic = general_settings[5]

    return [ip, port, base_url, log_level, branch, automatic]


result = get_general_settings()
ip = result[0]
port = result[1]
base_url = result[2]
log_level = result[3]
branch = result[4]
automatic = result[5]