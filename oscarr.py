oscarr_version = '0.1.0'

import os
import sys
sys.path.insert(0,os.path.join(os.path.dirname(__file__), 'libs/'))

from bottle import route, run, template, static_file, request, redirect, response
import bottle
bottle.debug(True)
bottle.TEMPLATES.clear()

bottle.TEMPLATE_PATH.insert(0,os.path.join(os.path.dirname(__file__), 'views/'))

import requests
from datetime import datetime, timedelta, tzinfo
from PIL import Image
from io import BytesIO
from fdsend import send_file
import math
import pretty
from pytz import reference
import isodate
LOCALZONE = reference.LocalTimezone()

from init_db import *
from update_db import *
from update_modules import *

import logging
from logging.handlers import TimedRotatingFileHandler

logger = logging.getLogger('waitress')
db = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
c = db.cursor()
c.execute("SELECT log_level FROM table_settings_general")
log_level = c.fetchone()
c.close()
log_level = log_level[0]
if log_level is None:
    log_level = "INFO"
log_level = getattr(logging, log_level)


class OneLineExceptionFormatter(logging.Formatter):
    def formatException(self, exc_info):
        """
        Format an exception so that it prints on a single line.
        """
        result = super(OneLineExceptionFormatter, self).formatException(exc_info)
        return repr(result) # or format into one line however you want to

    def format(self, record):
        s = super(OneLineExceptionFormatter, self).format(record)
        if record.exc_text:
            s = s.replace('\n', '') + '|'
        return s

def configure_logging():
    global fh
    fh = TimedRotatingFileHandler(os.path.join(os.path.dirname(__file__), 'data/log/oscarr.log'), when="midnight", interval=1, backupCount=7)
    f = OneLineExceptionFormatter('%(asctime)s|%(levelname)s|%(message)s|',
                                  '%d/%m/%Y %H:%M:%S')
    fh.setFormatter(f)
    logging.getLogger("apscheduler").setLevel(logging.WARNING)
    root = logging.getLogger()
    root.setLevel(log_level)
    root.addHandler(fh)

configure_logging()

from scheduler import *
from check_update import *

# Pretty filesize function
def sizeof_fmt(num, suffix='B'):
    for unit in ['','K','M','G','T','P','E','Z']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f%s%s" % (num, 'Yi', suffix)

# Reset restart required warning on start
conn = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
c = conn.cursor()
c.execute("UPDATE table_settings_general SET configured = 0, updated = 0")
conn.commit()
c.close()


@route('/')
def redirect_root():
    redirect (base_url)

@route(base_url)
def redirect_root():
    conn = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = conn.cursor()
    plex_enabled = c.execute("SELECT enabled FROM table_settings_plex").fetchone()
    emby_enabled = c.execute("SELECT enabled FROM table_settings_emby").fetchone()
    sonarr_enabled = c.execute("SELECT enabled FROM table_settings_sonarr").fetchone()
    radarr_enabled = c.execute("SELECT enabled FROM table_settings_radarr").fetchone()
    bazarr_enabled = c.execute("SELECT enabled FROM table_settings_bazarr").fetchone()
    c.close()

    if plex_enabled[0] == "on":
        redirect (base_url + 'plex')
    elif emby_enabled[0] == "on":
        redirect (base_url + 'emby')
    elif sonarr_enabled[0] == "on":
        redirect (base_url + 'sonarr')
    elif radarr_enabled[0] == "on":
        redirect (base_url + 'radarr')
    elif bazarr_enabled[0] == "on":
        redirect (base_url + 'bazarr')
    else:
        redirect (base_url + 'settings')

@route(base_url + 'static/:path#.+#', name='static')
def static(path):
    return static_file(path, root=os.path.join(os.path.dirname(__file__), 'static'))

@route(base_url + 'emptylog')
def emptylog():
    ref = request.environ['HTTP_REFERER']
    
    fh.doRollover()
    logging.info('Log file emptied')

    redirect(ref)

@route(base_url + 'oscarr.log')
def download_log():
    return static_file('oscarr.log', root=os.path.join(os.path.dirname(__file__), 'data/log/'), download='oscarr.log')

@route(base_url + 'image_proxy/<url:path>', method='GET')
def image_proxy(url):
    from get_sonarr_settings import get_sonarr_settings
    url_sonarr_short = get_sonarr_settings()[1]

    img_pil = Image.open(BytesIO(requests.get(url_sonarr_short + '/' + url).content))
    img_buffer = BytesIO()
    img_pil.tobytes()
    img_pil.save(img_buffer, img_pil.format)
    img_buffer.seek(0)
    return send_file(img_buffer, ctype=img_pil.format)

@route(base_url + 'plex')
def plex():
    from get_plex_settings import get_plex_settings
    url_plex = get_plex_settings()[0]
    apikey_plex = get_plex_settings()[1]

    url_plex_api_sections = url_plex + "/library/sections"
    headers = {'X-Plex-Token': apikey_plex, 'Accept': 'application/json'}
    series_list = []
    movies_list = []
    try:
        sections = requests.get(url_plex_api_sections, headers=headers).json()
    except:
        series_list.append(['', 'Unable to connect to Plex. Check your settings.', '', '', '', ''])
        movies_list.append(['', 'Unable to connect to Plex. Check your settings.', ''])
    else:
        for section in sections['MediaContainer']['Directory']:
            if section['type'] == 'show':
                url_plex_api_series = url_plex + "/library/sections/" + section['key'] + "/recentlyAdded?stack=0&sort=addedAt:desc&X-Plex-Container-Start=0&X-Plex-Container-Size=20"
                series_json = requests.get(url_plex_api_series, headers=headers).json()
                for series in series_json['MediaContainer']['Metadata']:
                    series_list.append([True if 'viewCount' in series else False, series['grandparentTitle'], series['title'], series['parentIndex'], series['index'], datetime.fromtimestamp(series['addedAt']).strftime('%Y-%m-%d')])
            elif section['type'] == 'movie':
                url_plex_api_movies = url_plex + "/library/sections/" + section['key'] + "/recentlyAdded?stack=0&sort=addedAt:desc&X-Plex-Container-Start=0&X-Plex-Container-Size=20"
                movies_json = requests.get(url_plex_api_movies, headers=headers).json()
                for movies in movies_json['MediaContainer']['Metadata']:
                    movies_list.append(['True' if 'viewCount' in movies else 'False', movies['title'], datetime.fromtimestamp(movies['addedAt']).strftime('%Y-%m-%d')])
                movies_list.sort(key=lambda x: x[2])
                movies_list = list(reversed(movies_list))[0:20]

    output = template('plex', __file__=__file__, oscarr_version=oscarr_version, base_url=base_url, series_list=series_list, movies_list=movies_list)
    return output

@route(base_url + 'emby')
def emby():
    from get_emby_settings import get_emby_settings
    url_emby_user = get_emby_settings()[1]
    apikey_emby = get_emby_settings()[2]

    url_emby_api_series = url_emby_user + "/Items?IncludeItemTypes=Episode&Recursive=True&ExcludeLocationTypes=Virtual&Limit=20&GroupItems=false&Fields=DateCreated&SortBy=DateCreated&SortOrder=Descending&format=json"
    headers = {'X-MediaBrowser-Token': apikey_emby, 'Content-type': 'application/json'}
    series_list = []
    try:
        series_json = requests.get(url_emby_api_series, headers=headers).json()
    except:
        series_list.append(['', 'Unable to connect to Emby. Check your settings.', '', '', '', ''])
    else:
        for series in series_json['Items']:
            series_list.append([series['UserData']['Played'], series['SeriesName'], series['Name'], series['ParentIndexNumber'], series['IndexNumber'], isodate.parse_datetime(series['DateCreated']).astimezone(LOCALZONE).date()])

    url_emby_api_movies = url_emby_user + "/Items?IncludeItemTypes=Movie&Recursive=True&ExcludeLocationTypes=Virtual&Limit=20&GroupItems=false&Fields=DateCreated&SortBy=DateCreated&SortOrder=Descending&format=json"
    headers = {'X-MediaBrowser-Token': apikey_emby, 'Content-type': 'application/json'}
    movies_list = []
    try:
        movies_json = requests.get(url_emby_api_movies, headers=headers).json()
    except:
        movies_list.append(['', 'Unable to connect to Emby. Check your settings.', ''])
    else:
        for movies in movies_json['Items']:
            movies_list.append([movies['UserData']['Played'], movies['Name'], isodate.parse_datetime(movies['DateCreated']).astimezone(LOCALZONE).date()])

    output = template('emby', __file__=__file__, oscarr_version=oscarr_version, base_url=base_url, series_list=series_list, movies_list=movies_list)
    return output

@route(base_url + 'sonarr')
def sonarr():
    from get_sonarr_settings import get_sonarr_settings
    url_sonarr = get_sonarr_settings()[0]
    apikey_sonarr = get_sonarr_settings()[2]

    now = datetime.today().strftime('%Y-%m-%d')
    today = datetime.strptime(now, "%Y-%m-%d")
    a_week = timedelta(days=7)
    in_one_week = today + a_week

    url_sonarr_api_rootfolder = url_sonarr + "/api/rootfolder?apikey=" + apikey_sonarr
    rootfolder_list = []
    try:
        rootfolder_json = requests.get(url_sonarr_api_rootfolder).json()
    except:
        rootfolder_list.append(['Unable to connect to Radarr. Check your settings.', '', '', '', ''])
    else:
        for rootfolder in rootfolder_json:
            if 'totalSpace' in rootfolder:
                percent = 100 * (float(rootfolder['totalSpace']) - float(rootfolder['freeSpace'])) / float(rootfolder['totalSpace'])
                rootfolder_list.append([rootfolder['path'], sizeof_fmt(rootfolder['freeSpace']), sizeof_fmt(rootfolder['totalSpace']), int(percent)])
            else:
                rootfolder_list = None

    url_sonarr_api_calendar = url_sonarr + "/api/calendar?start=" + datetime.strftime(today, "%Y-%m-%d") + "&end=" + datetime.strftime(in_one_week, "%Y-%m-%d") + "&apikey=" + apikey_sonarr
    calendar_list = []
    try:
        calendar_json = requests.get(url_sonarr_api_calendar).json()
    except:
        calendar_list.append(['Unable to connect to Sonarr. Check your settings.', '', '', '', ''])
    else:
        for calendar in calendar_json:
            if not calendar['hasFile']:
                calendar_list.append([calendar['series']['title'], calendar['title'], calendar['seasonNumber'], calendar['episodeNumber'], calendar['airDate']])

    url_sonarr_api_break = url_sonarr + "/api/series?apikey=" + apikey_sonarr
    break_list = []
    try:
        break_json = requests.get(url_sonarr_api_break).json()
    except:
        break_list.append(['Unable to connect to Sonarr. Check your settings.', '', '', '', ''])
    else:
        for item in break_json:
            if 'statistics' in item['seasons'][-1]:
                if 'previousAiring' in item['seasons'][-1]['statistics'] and 'nextAiring' in item['seasons'][-1]['statistics']:
                    delta = datetime.strptime(item['seasons'][-1]['statistics']['nextAiring'], '%Y-%m-%dT%H:%M:%SZ') - datetime.strptime(item['seasons'][-1]['statistics']['previousAiring'], '%Y-%m-%dT%H:%M:%SZ')
                    if delta.total_seconds() > (7 * 24 * 60 * 60) and (datetime.strptime(item['seasons'][-1]['statistics']['nextAiring'][0:10], '%Y-%m-%d') - datetime.strptime(now, '%Y-%m-%d')).total_seconds() > (7 * 24 * 60 * 60) and item['seasons'][-1]['statistics']['episodeCount'] + 1 > 1:
                        break_list.append([item['title'], item['seasons'][-1]['seasonNumber'], item['seasons'][-1]['statistics']['episodeCount'] + 1, item['seasons'][-1]['statistics']['nextAiring'][0:10]])
    break_list.sort(key=lambda x: x[3])


    url_sonarr_api_upcoming = url_sonarr + "/api/series?apikey=" + apikey_sonarr
    upcoming_list = []
    try:
        upcoming_json = requests.get(url_sonarr_api_upcoming).json()
    except:
        upcoming_list.append(['Unable to connect to Sonarr. Check your settings.', '', '', '', ''])
    else:
        for item in upcoming_json:
            if 'statistics' in item['seasons'][-1]:
                if 'nextAiring' in item['seasons'][-1]['statistics']:
                    if (datetime.strptime(item['seasons'][-1]['statistics']['nextAiring'][0:10], '%Y-%m-%d') - datetime.strptime(now, '%Y-%m-%d')).total_seconds() > (7 * 24 * 60 * 60) and item['seasons'][-1]['statistics']['episodeCount'] + 1 == 1:
                        upcoming_list.append([item['title'], item['seasons'][-1]['seasonNumber'], item['seasons'][-1]['statistics']['nextAiring'][0:10]])
        upcoming_list.sort(key=lambda x: x[2])

    url_sonarr_api_missing = url_sonarr + "/api/wanted/missing?sortKey=airDateUtc&page=1&pageSize=10&sortDir=desc&apikey=" + apikey_sonarr
    missing_list = []
    try:
        missing_json = requests.get(url_sonarr_api_missing).json()
    except:
        missing_list.append(['Unable to connect to Sonarr. Check your settings.', '', '', '', ''])
    else:
        for missing in missing_json['records']:
            missing_list.append([missing['series']['title'], missing['title'], missing['seasonNumber'], missing['episodeNumber'], missing['airDate']])

    output = template('sonarr', __file__=__file__, oscarr_version=oscarr_version, base_url=base_url, rootfolder_list=rootfolder_list, calendar_list=calendar_list, break_list=break_list, upcoming_list=upcoming_list, missing_list=missing_list)
    return output

@route(base_url + 'radarr')
def radarr():
    from get_radarr_settings import get_radarr_settings
    url_radarr = get_radarr_settings()[0]
    apikey_radarr = get_radarr_settings()[2]

    now = datetime.today().strftime('%Y-%m-%d')
    today = datetime.strptime(now, "%Y-%m-%d")

    url_radarr_api_rootfolder = url_radarr + "/api/rootfolder?apikey=" + apikey_radarr
    rootfolder_list = []
    try:
        rootfolder_json = requests.get(url_radarr_api_rootfolder).json()
    except:
        rootfolder_list.append(['Unable to connect to Radarr. Check your settings.', '', '', '', ''])
    else:
        for rootfolder in rootfolder_json:
            if 'totalSpace' in rootfolder:
                percent = 100 * (float(rootfolder['totalSpace']) - float(rootfolder['freeSpace'])) / float(rootfolder['totalSpace'])
                rootfolder_list.append([rootfolder['path'], sizeof_fmt(rootfolder['freeSpace']), sizeof_fmt(rootfolder['totalSpace']), int(percent)])
            else:
                rootfolder_list = None

    url_radarr_api_calendar = url_radarr + "/api/wanted/missing?page=1&pageSize=1000&sortKey=physicalRelease&sortDir=desc&filterKey=monitored&filterValue=true&filterType=equal&apikey=" + apikey_radarr
    calendar_list = []
    try:
        calendar_json = requests.get(url_radarr_api_calendar).json()
    except:
        calendar_list.append(['Unable to connect to Radarr. Check your settings.', ''])
    else:
        for calendar in calendar_json['records']:
            if calendar['hasFile'] == False and 'physicalRelease' in calendar and len(calendar_list) <= 9 and calendar['physicalRelease'] >= datetime.strftime(today, "%Y-%m-%d"):
                calendar_list.append([calendar['title'], calendar['physicalRelease'][0:10] if 'physicalRelease' in calendar else ''])

    url_radarr_api_missing = url_radarr + "/api/wanted/missing?page=1&pageSize=1000&sortKey=physicalRelease&sortDir=desc&filterKey=monitored&filterValue=true&filterType=equal&apikey=" + apikey_radarr
    missing_list = []
    try:
        missing_json = requests.get(url_radarr_api_missing).json()
    except:
        missing_list.append(['Unable to connect to Radarr. Check your settings.', ''])
    else:
        for missing in missing_json['records']:
            if missing['hasFile'] == False and 'physicalRelease' in missing and len(missing_list) <= 9 and missing['physicalRelease'] < datetime.strftime(today, "%Y-%m-%d"):
                missing_list.append([missing['title'], missing['physicalRelease'][0:10] if 'physicalRelease' in missing else ''])

    output = template('radarr', __file__=__file__, oscarr_version=oscarr_version, base_url=base_url, rootfolder_list=rootfolder_list, calendar_list=calendar_list, missing_list=missing_list)
    return output

@route(base_url + 'bazarr')
def bazarr():
    from get_bazarr_settings import get_bazarr_settings
    url_bazarr = get_bazarr_settings()[0]

    url_bazarr_api_missing = url_bazarr + "/api/wanted"
    missing_list = []
    try:
        missing_json = requests.get(url_bazarr_api_missing).json()
    except:
        missing_list.append(['Unable to connect to Bazarr. Check your settings.', '', '', '[]'])
    else:
        for missing in missing_json['subtitles']:
            if len(missing_list) <= 9:
                missing_list.append([missing[0], missing[1], missing[2], missing[3][0:10]])

    url_bazarr_api_history = url_bazarr + "/api/history"
    history_list = []
    try:
        history_json = requests.get(url_bazarr_api_history).json()
    except:
        history_list.append(['Unable to connect to Bazarr. Check your settings.', '', '', '', ''])
    else:
        for history in history_json['subtitles']:
            if len(history_list) <= 9:
                history_list.append([history[0], history[1], history[2], history[3][0:10], history[4]])

    output = template('bazarr', __file__=__file__, oscarr_version=oscarr_version, base_url=base_url, missing_list=missing_list, history_list=history_list)
    return output

@route(base_url + 'settings')
def settings():
    db = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = db.cursor()
    c.execute("SELECT * FROM table_settings_general")
    settings_general = c.fetchone()
    c.execute("SELECT * FROM table_settings_plex")
    settings_plex = c.fetchone()
    c.execute("SELECT * FROM table_settings_emby")
    settings_emby = c.fetchone()
    c.execute("SELECT * FROM table_settings_sonarr")
    settings_sonarr = c.fetchone()
    c.execute("SELECT * FROM table_settings_radarr")
    settings_radarr = c.fetchone()
    c.execute("SELECT * FROM table_settings_bazarr")
    settings_bazarr = c.fetchone()
    c.close()
    return template('settings', __file__=__file__, oscarr_version=oscarr_version, settings_general=settings_general, settings_plex=settings_plex, settings_emby=settings_emby, settings_sonarr=settings_sonarr, settings_radarr=settings_radarr, settings_bazarr=settings_bazarr, base_url=base_url)

@route(base_url + 'save_settings', method='POST')
def save_settings():
    ref = request.environ['HTTP_REFERER']

    conn = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = conn.cursor()    

    settings_general_ip = request.forms.get('settings_general_ip')
    settings_general_port = request.forms.get('settings_general_port')
    settings_general_baseurl = request.forms.get('settings_general_baseurl')
    settings_general_loglevel = request.forms.get('settings_general_loglevel')
    settings_general_branch = request.forms.get('settings_general_branch')
    settings_general_automatic = request.forms.get('settings_general_automatic')
    if settings_general_automatic is None:
        settings_general_automatic = 'False'
    else:
        settings_general_automatic = 'True'

    before = c.execute("SELECT ip, port, base_url FROM table_settings_general").fetchone()
    after = (unicode(settings_general_ip), int(settings_general_port), unicode(settings_general_baseurl))
    c.execute("UPDATE table_settings_general SET ip = ?, port = ?, base_url = ?, log_level = ?, branch=?, auto_update=?", (unicode(settings_general_ip), int(settings_general_port), unicode(settings_general_baseurl), unicode(settings_general_loglevel), unicode(settings_general_branch), unicode(settings_general_automatic)))
    conn.commit()
    if after != before:
        configured()
    get_general_settings()

    settings_plex_enabled = request.forms.get('settings_plex_enabled')
    settings_plex_ip = request.forms.get('settings_plex_ip')
    settings_plex_port = request.forms.get('settings_plex_port')
    settings_plex_baseurl = request.forms.get('settings_plex_baseurl')
    settings_plex_ssl = request.forms.get('settings_plex_ssl')
    if settings_plex_ssl is None:
        settings_plex_ssl = 'False'
    else:
        settings_plex_ssl = 'True'
    settings_plex_username = request.forms.get('settings_plex_username')
    settings_plex_password = request.forms.get('settings_plex_password')
    c.execute("UPDATE table_settings_plex SET ip = ?, port = ?, base_url = ?, ssl = ?, username = ?, password = ?, enabled = ?", (settings_plex_ip, settings_plex_port, settings_plex_baseurl, settings_plex_ssl, settings_plex_username, settings_plex_password, settings_plex_enabled))

    settings_emby_enabled = request.forms.get('settings_emby_enabled')
    settings_emby_ip = request.forms.get('settings_emby_ip')
    settings_emby_port = request.forms.get('settings_emby_port')
    settings_emby_baseurl = request.forms.get('settings_emby_baseurl')
    settings_emby_ssl = request.forms.get('settings_emby_ssl')
    if settings_emby_ssl is None:
        settings_emby_ssl = 'False'
    else:
        settings_emby_ssl = 'True'
    settings_emby_apikey = request.forms.get('settings_emby_apikey')
    settings_emby_userid = request.forms.get('settings_emby_userid')
    c.execute("UPDATE table_settings_emby SET ip = ?, port = ?, base_url = ?, ssl = ?, userid = ?, apikey = ?, enabled = ?", (settings_emby_ip, settings_emby_port, settings_emby_baseurl, settings_emby_ssl, settings_emby_userid, settings_emby_apikey, settings_emby_enabled))

    settings_sonarr_enabled = request.forms.get('settings_sonarr_enabled')
    settings_sonarr_ip = request.forms.get('settings_sonarr_ip')
    settings_sonarr_port = request.forms.get('settings_sonarr_port')
    settings_sonarr_baseurl = request.forms.get('settings_sonarr_baseurl')
    settings_sonarr_ssl = request.forms.get('settings_sonarr_ssl')
    if settings_sonarr_ssl is None:
        settings_sonarr_ssl = 'False'
    else:
        settings_sonarr_ssl = 'True'
    settings_sonarr_apikey = request.forms.get('settings_sonarr_apikey')
    c.execute("UPDATE table_settings_sonarr SET ip = ?, port = ?, base_url = ?, ssl = ?, apikey = ?, enabled = ?", (settings_sonarr_ip, settings_sonarr_port, settings_sonarr_baseurl, settings_sonarr_ssl, settings_sonarr_apikey, settings_sonarr_enabled))

    settings_radarr_enabled = request.forms.get('settings_radarr_enabled')
    settings_radarr_ip = request.forms.get('settings_radarr_ip')
    settings_radarr_port = request.forms.get('settings_radarr_port')
    settings_radarr_baseurl = request.forms.get('settings_radarr_baseurl')
    settings_radarr_ssl = request.forms.get('settings_radarr_ssl')
    if settings_radarr_ssl is None:
        settings_radarr_ssl = 'False'
    else:
        settings_radarr_ssl = 'True'
    settings_radarr_apikey = request.forms.get('settings_radarr_apikey')
    c.execute("UPDATE table_settings_radarr SET ip = ?, port = ?, base_url = ?, ssl = ?, apikey = ?, enabled = ?", (settings_radarr_ip, settings_radarr_port, settings_radarr_baseurl, settings_radarr_ssl, settings_radarr_apikey, settings_radarr_enabled))

    settings_bazarr_enabled = request.forms.get('settings_bazarr_enabled')
    settings_bazarr_ip = request.forms.get('settings_bazarr_ip')
    settings_bazarr_port = request.forms.get('settings_bazarr_port')
    settings_bazarr_baseurl = request.forms.get('settings_bazarr_baseurl')
    c.execute("UPDATE table_settings_bazarr SET ip = ?, port = ?, base_url = ?, enabled = ?", (settings_bazarr_ip, settings_bazarr_port, settings_bazarr_baseurl, settings_bazarr_enabled))

    conn.commit()
    c.close()

    logging.info('Settings saved succesfully.')
    
    redirect(ref)

@route(base_url + 'check_update')
def check_update():
    ref = request.environ['HTTP_REFERER']

    check_and_apply_update()
    
    redirect(ref)

@route(base_url + 'system')
def system():
    def get_time_from_interval(interval):
        interval_clean = interval.split('[')
        interval_clean = interval_clean[1][:-1]
        interval_split = interval_clean.split(':')

        hour = interval_split[0]
        minute = interval_split[1].lstrip("0")
        second = interval_split[2].lstrip("0")

        text = "every "
        if hour != "0":
            text = text + hour
            if hour == "1":
                text = text + " hour"
            else:
                text = text + " hours"

            if minute != "" and second != "":
                text = text + ", "
            elif minute == "" and second != "":
                text = text + " and "
            elif minute != "" and second == "":
                text = text + " and "
        if minute != "":
            text = text + minute
            if minute == "1":
                text = text + " minute"
            else:
                text = text + " minutes"

            if second != "":
                text = text + " and "
        if second != "":
            text = text + second
            if second == "1":
                text = text + " second"
            else:
                text = text + " seconds"

        return text

    def get_time_from_cron(cron):
        text = "at "
        hour = str(cron[5])
        minute = str(cron[6])
        second = str(cron[7])

        if hour != "0" and hour != "*":
            text = text + hour
            if hour == "0" or hour == "1":
                text = text + " hour"
            else:
                text = text + " hours"

            if minute != "*" and second != "0":
                text = text + ", "
            elif minute == "*" and second != "0":
                text = text + " and "
            elif minute != "0" and minute != "*" and second == "0":
                text = text + " and "
        if minute != "0" and minute != "*":
            text = text + minute
            if minute == "0" or minute == "1":
                text = text + " minute"
            else:
                text = text + " minutes"

            if second != "0" and second != "*":
                text = text + " and "
        if second != "0" and second != "*":
            text = text + second
            if second == "0" or second == "1":
                text = text + " second"
            else:
                text = text + " seconds"

        return text

    task_list = []
    for job in scheduler.get_jobs():
        if job.trigger.__str__().startswith('interval'):
            task_list.append([job.name, get_time_from_interval(str(job.trigger)), pretty.date(job.next_run_time.replace(tzinfo=None)), job.id])
        elif job.trigger.__str__().startswith('cron'):
            task_list.append([job.name, get_time_from_cron(job.trigger.fields), pretty.date(job.next_run_time.replace(tzinfo=None)), job.id])

    i = 0
    with open(os.path.join(os.path.dirname(__file__), 'data/log/oscarr.log')) as f:
        for i, l in enumerate(f, 1):
            pass
        row_count = i
        max_page = int(math.ceil(row_count / 50.0))
    
    return template('system', __file__=__file__, oscarr_version=oscarr_version, base_url=base_url, task_list=task_list, row_count=row_count, max_page=max_page)

@route(base_url + 'logs/<page:int>')
def get_logs(page):
    page_size = 50
    begin = (page * page_size) - page_size
    end = (page * page_size) - 1
    logs_complete = []
    for line in reversed(open(os.path.join(os.path.dirname(__file__), 'data/log/oscarr.log')).readlines()):
        logs_complete.append(line.rstrip())
    logs = logs_complete[begin:end]

    return template('logs', logs=logs, base_url=base_url)

@route(base_url + 'execute/<taskid>')
def execute_task(taskid):
    ref = request.environ['HTTP_REFERER']

    execute_now(taskid)

    redirect(ref)

def configured():
    conn = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/oscarr.db'), timeout=30)
    c = conn.cursor()
    c.execute("UPDATE table_settings_general SET configured = 1")
    conn.commit()
    c.close()

logging.info('Oscarr is started and waiting for request on http://' + str(ip) + ':' + str(port) + str(base_url))
run(host=ip, port=port, server='waitress')
logging.info('oscarr has been stopped.')
