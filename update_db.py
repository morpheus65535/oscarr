import os
import sqlite3

# Check if database exist
if os.path.exists(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db')):
    # Open database connection
    db = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = db.cursor()
    
    # Execute tables modifications
    #try:
    #    c.execute('alter table table_settings_providers add column "username" "text"')
    #except:
    #    pass

    # Commit change to db
    db.commit()

    # Close database connection
    db.close()
