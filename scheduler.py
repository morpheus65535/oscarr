from check_update import *

from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime

scheduler = BackgroundScheduler()
if automatic == 'True':
    scheduler.add_job(check_and_apply_update, 'interval', hours=6, max_instances=1, coalesce=True, misfire_grace_time=15, id='update_bazarr', name='Update bazarr from source on Github')
else:
    scheduler.add_job(check_and_apply_update, 'cron', year='2100', hour=4, id='update_bazarr', name='Update bazarr from source on Github')
scheduler.start()

def execute_now(taskid):
    scheduler.modify_job(taskid, jobstore=None, next_run_time=datetime.now())
