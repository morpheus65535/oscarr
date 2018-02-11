import requests
from datetime import datetime
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
else:
    for section in sections['MediaContainer']['Directory']:
        if section['type'] == 'show':
            url_plex_api_series = url_plex + "/library/sections/" + section['key'] + "/recentlyAdded?stack=0&sort=addedAt:desc&X-Plex-Container-Start=0&X-Plex-Container-Size=20"
            series_json = requests.get(url_plex_api_series, headers=headers).json()
            for series in series_json['MediaContainer']['Metadata']:
                series_list.append(['True' if 'viewCount' in series else 'False', series['grandparentTitle'], series['title'], series['parentIndex'], series['index'], datetime.fromtimestamp(series['addedAt']).strftime('%Y-%m-%d')])
        elif section['type'] == 'movie':
            url_plex_api_movies = url_plex + "/library/sections/" + section['key'] + "/recentlyAdded?stack=0&sort=addedAt:desc&X-Plex-Container-Start=0&X-Plex-Container-Size=20"
            movies_json = requests.get(url_plex_api_movies, headers=headers).json()
            for movies in movies_json['MediaContainer']['Metadata']:
                movies_list.append(['True' if 'viewCount' in movies else 'False', movies['title'], datetime.fromtimestamp(movies['addedAt']).strftime('%Y-%m-%d')])
            movies_list.sort(key=lambda x: x[2])
            movies_list = list(reversed(movies_list))[0:20]

print series_list
print len(movies_list)