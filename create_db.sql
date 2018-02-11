BEGIN TRANSACTION;
CREATE TABLE "table_settings_sonarr" (
	`ip`	TEXT NOT NULL,
	`port`	INTEGER NOT NULL,
	`base_url`	TEXT,
	`ssl`	INTEGER,
	`apikey`	TEXT,
	`enabled`	INTEGER
);
INSERT INTO `table_settings_sonarr` (ip,port,base_url,ssl,apikey,enabled) VALUES ('127.0.0.1',8989,'/','False','',NULL);
CREATE TABLE "table_settings_radarr" (
	`ip`	TEXT NOT NULL,
	`port`	INTEGER NOT NULL,
	`base_url`	TEXT,
	`ssl`	INTEGER,
	`apikey`	TEXT,
	`enabled`	INTEGER
);
INSERT INTO `table_settings_radarr` (ip,port,base_url,ssl,apikey,enabled) VALUES ('127.0.0.1',7878,'/','False','',NULL);
CREATE TABLE "table_settings_plex" (
	`ip`	TEXT NOT NULL,
	`port`	INTEGER NOT NULL,
	`base_url`	TEXT,
	`ssl`	INTEGER,
	`username`	TEXT,
	`password`	TEXT,
	`enabled`	INTEGER
);
INSERT INTO `table_settings_plex` (ip,port,base_url,ssl,username,password,enabled) VALUES ('127.0.0.1',32400,'/','False','','',NULL);
CREATE TABLE "table_settings_general" (
	`ip`	TEXT NOT NULL,
	`port`	INTEGER NOT NULL,
	`base_url`	TEXT,
	`log_level`	TEXT,
	`branch`	TEXT,
	`auto_update`	INTEGER,
	`configured`	"integer",
	`updated`	"integer"
);
INSERT INTO `table_settings_general` (ip,port,base_url,log_level,branch,auto_update,configured,updated) VALUES ('0.0.0.0',5656,'/','INFO','master','True',0,0);
CREATE TABLE "table_settings_emby" ( `ip` TEXT NOT NULL, `port` INTEGER NOT NULL, `base_url` TEXT, `ssl` INTEGER, `userid` TEXT,`apikey` TEXT, `enabled` INTEGER );
INSERT INTO `table_settings_emby` (ip,port,base_url,ssl,userid,apikey,enabled) VALUES ('127.0.0.1',8096,'/','False','','',NULL);
CREATE TABLE "table_settings_bazarr" (
	`ip`	TEXT NOT NULL,
	`port`	INTEGER NOT NULL,
	`base_url`	TEXT,
	`apikey`	TEXT,
	`enabled`	INTEGER
);
INSERT INTO `table_settings_bazarr` (ip,port,base_url,apikey,enabled) VALUES ('127.0.0.1',6767,'/','',NULL);
COMMIT;
