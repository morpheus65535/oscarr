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

        <title>Radarr - Oscarr</title>

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
                padding: 2em 3em 2em 3em;
            }
            .table {
                padding-top: 1em;
            }
        </style>
    </head>
    <body>
        <div id='loader' class="ui page dimmer">
            <div class="ui indeterminate text loader">Loading...</div>
        </div>
        % include('menu.tpl')

        %if rootfolder_list is not None:
        <div id="fondblanc" class="ui container">
            %if len(rootfolder_list) > 1:
            <div class="ui grid">
            %end
                %for row in rootfolder_list:
                %if len(rootfolder_list) > 1:
                <div class="eight wide column">
                %end
                    <div class="ui small header"><i class="folder open outline icon"></i>{{row[0]}}</div>
                    <div class="ui progress" data-percent="{{row[3]}}">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                        <div class="label">{{row[1]}} free out of {{row[2]}}</div>
                    </div>
                %if len(rootfolder_list) > 1:
                </div>
                %end
                %end
            %if len(rootfolder_list) > 1:
            </div>
            %end
        </div>
        %end

        <div id="fondblanc" class="ui container">
            <div class="ui top attached tabular menu">
                <a class="tabs item active" data-tab="upcoming">Upcoming</a>
                <a class="tabs item" data-tab="missing">Missing</a>
            </div>

            <div class="ui bottom attached tab segment active" data-tab="upcoming">
                <table class="ui very basic selectable table">
                    <thead>
                        <tr>
                            <th class="six wide">Movies</th>
                            <th class="two wide">Release Date</th>
                        </tr>
                    </thead>
                    <tbody>
                    %for row in calendar_list:
                        <tr class="selectable">
                            <td>{{row[0]}}</td>
                            <td>{{row[1]}}</td>
                        </tr>
                    %end
                    </tbody>
                </table>
            </div>

            <div class="ui bottom attached tab segment" data-tab="missing">
                <table class="ui very basic selectable table">
                    <thead>
                        <tr>
                            <th class="six wide">Movies</th>
                            <th class="two wide">Release Date</th>
                        </tr>
                    </thead>
                    <tbody>
                    %for row in missing_list:
                        <tr class="selectable">
                            <td>{{row[0]}}</td>
                            <td>{{row[1]}}</td>
                        </tr>
                    %end
                    </tbody>
                </table>
            </div>
        </div>

        % include('footer.tpl')
    </body>
</html>


<script>
    $('.tabular.menu .item').tab();

    $('.progress').progress({
        showActivity : false
    });

    $('a:not(.tabs), button:not(.cancel)').click(function(){
        $('#loader').addClass('active');
    })
</script>