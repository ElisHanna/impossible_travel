BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_time"	datetime NOT NULL,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"last_name"	varchar(150) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"first_name"	varchar(150) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
CREATE TABLE IF NOT EXISTS "touring_commodity" (
	"id"	integer NOT NULL,
	"name"	varchar(30) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "touring_direction" (
	"id"	integer NOT NULL,
	"name"	varchar(50) NOT NULL,
	"description"	varchar(500),
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "touring_area" (
	"id"	integer NOT NULL,
	"name"	varchar(50) NOT NULL,
	"description"	varchar(500) NOT NULL,
	"direction_id"	bigint,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("direction_id") REFERENCES "touring_direction"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "touring_entertaiment" (
	"id"	integer NOT NULL,
	"name"	varchar(50) NOT NULL,
	"description"	varchar(500) NOT NULL,
	"cost"	smallint unsigned CHECK("cost" >= 0),
	"area_id"	bigint,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("area_id") REFERENCES "touring_area"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "touring_hotel" (
	"id"	integer NOT NULL,
	"name"	varchar(50) NOT NULL,
	"description"	varchar(500) NOT NULL,
	"cost_per_night"	smallint unsigned NOT NULL CHECK("cost_per_night" >= 0),
	"area_id"	bigint NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("area_id") REFERENCES "touring_area"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "touring_hotel_commodity" (
	"id"	integer NOT NULL,
	"hotel_id"	bigint NOT NULL,
	"commodity_id"	bigint NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("commodity_id") REFERENCES "touring_commodity"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("hotel_id") REFERENCES "touring_hotel"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "touring_tour" (
	"id"	char(32) NOT NULL,
	"checkin_date"	date NOT NULL,
	"checkout_date"	date NOT NULL,
	"cost"	smallint unsigned NOT NULL CHECK("cost" >= 0),
	"entertaiments_id"	bigint,
	"hotel_id"	bigint,
	PRIMARY KEY("id"),
	FOREIGN KEY("entertaiments_id") REFERENCES "touring_entertaiment"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("hotel_id") REFERENCES "touring_hotel"("id") DEFERRABLE INITIALLY DEFERRED
);
INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (1,'contenttypes','0001_initial','2024-04-21 18:09:37.194009'),
 (2,'auth','0001_initial','2024-04-21 18:09:37.215059'),
 (3,'admin','0001_initial','2024-04-21 18:09:37.230021'),
 (4,'admin','0002_logentry_remove_auto_add','2024-04-21 18:09:37.242024'),
 (5,'admin','0003_logentry_add_action_flag_choices','2024-04-21 18:09:37.251698'),
 (6,'contenttypes','0002_remove_content_type_name','2024-04-21 18:09:37.264533'),
 (7,'auth','0002_alter_permission_name_max_length','2024-04-21 18:09:37.278280'),
 (8,'auth','0003_alter_user_email_max_length','2024-04-21 18:09:37.294475'),
 (9,'auth','0004_alter_user_username_opts','2024-04-21 18:09:37.303198'),
 (10,'auth','0005_alter_user_last_login_null','2024-04-21 18:09:37.311576'),
 (11,'auth','0006_require_contenttypes_0002','2024-04-21 18:09:37.311576'),
 (12,'auth','0007_alter_validators_add_error_messages','2024-04-21 18:09:37.328228'),
 (13,'auth','0008_alter_user_username_max_length','2024-04-21 18:09:37.340729'),
 (14,'auth','0009_alter_user_last_name_max_length','2024-04-21 18:09:37.354690'),
 (15,'auth','0010_alter_group_name_max_length','2024-04-21 18:09:37.366449'),
 (16,'auth','0011_update_proxy_permissions','2024-04-21 18:09:37.375292'),
 (17,'auth','0012_alter_user_first_name_max_length','2024-04-21 18:09:37.386717'),
 (18,'sessions','0001_initial','2024-04-21 18:09:37.394916'),
 (19,'touring','0001_initial','2024-04-21 18:09:37.420548');
INSERT INTO "django_admin_log" ("id","object_id","object_repr","action_flag","change_message","content_type_id","user_id","action_time") VALUES (1,'1','Средиземье',1,'[{"added": {}}]',8,1,'2024-04-21 18:12:14.006013'),
 (2,'1','Ривендейл',1,'[{"added": {}}]',9,1,'2024-04-21 18:12:30.753196'),
 (3,'1','Фен',1,'[{"added": {}}]',7,1,'2024-04-21 18:13:08.239315'),
 (4,'2','Полотенца',1,'[{"added": {}}]',7,1,'2024-04-21 18:13:18.123225'),
 (5,'1','У Элронда',1,'[{"added": {}}]',11,1,'2024-04-21 18:13:36.416390'),
 (6,'2','Мордор',1,'[{"added": {}}]',9,1,'2024-04-21 18:14:00.732332'),
 (7,'2','У Саурона',1,'[{"added": {}}]',11,1,'2024-04-21 18:14:27.523881'),
 (8,'1','Катание на единороге',1,'[{"added": {}}]',10,1,'2024-04-21 18:15:03.330304'),
 (9,'2','Прятки с орками',1,'[{"added": {}}]',10,1,'2024-04-21 18:15:27.392772');
INSERT INTO "django_content_type" ("id","app_label","model") VALUES (1,'admin','logentry'),
 (2,'auth','permission'),
 (3,'auth','group'),
 (4,'auth','user'),
 (5,'contenttypes','contenttype'),
 (6,'sessions','session'),
 (7,'touring','commodity'),
 (8,'touring','direction'),
 (9,'touring','area'),
 (10,'touring','entertaiment'),
 (11,'touring','hotel'),
 (12,'touring','tour');
INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (1,1,'add_logentry','Can add log entry'),
 (2,1,'change_logentry','Can change log entry'),
 (3,1,'delete_logentry','Can delete log entry'),
 (4,1,'view_logentry','Can view log entry'),
 (5,2,'add_permission','Can add permission'),
 (6,2,'change_permission','Can change permission'),
 (7,2,'delete_permission','Can delete permission'),
 (8,2,'view_permission','Can view permission'),
 (9,3,'add_group','Can add group'),
 (10,3,'change_group','Can change group'),
 (11,3,'delete_group','Can delete group'),
 (12,3,'view_group','Can view group'),
 (13,4,'add_user','Can add user'),
 (14,4,'change_user','Can change user'),
 (15,4,'delete_user','Can delete user'),
 (16,4,'view_user','Can view user'),
 (17,5,'add_contenttype','Can add content type'),
 (18,5,'change_contenttype','Can change content type'),
 (19,5,'delete_contenttype','Can delete content type'),
 (20,5,'view_contenttype','Can view content type'),
 (21,6,'add_session','Can add session'),
 (22,6,'change_session','Can change session'),
 (23,6,'delete_session','Can delete session'),
 (24,6,'view_session','Can view session'),
 (25,7,'add_commodity','Can add commodity'),
 (26,7,'change_commodity','Can change commodity'),
 (27,7,'delete_commodity','Can delete commodity'),
 (28,7,'view_commodity','Can view commodity'),
 (29,8,'add_direction','Can add direction'),
 (30,8,'change_direction','Can change direction'),
 (31,8,'delete_direction','Can delete direction'),
 (32,8,'view_direction','Can view direction'),
 (33,9,'add_area','Can add area'),
 (34,9,'change_area','Can change area'),
 (35,9,'delete_area','Can delete area'),
 (36,9,'view_area','Can view area'),
 (37,10,'add_entertaiment','Can add entertaiment'),
 (38,10,'change_entertaiment','Can change entertaiment'),
 (39,10,'delete_entertaiment','Can delete entertaiment'),
 (40,10,'view_entertaiment','Can view entertaiment'),
 (41,11,'add_hotel','Can add hotel'),
 (42,11,'change_hotel','Can change hotel'),
 (43,11,'delete_hotel','Can delete hotel'),
 (44,11,'view_hotel','Can view hotel'),
 (45,12,'add_tour','Can add tour'),
 (46,12,'change_tour','Can change tour'),
 (47,12,'delete_tour','Can delete tour'),
 (48,12,'view_tour','Can view tour');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (1,'pbkdf2_sha256$720000$ppMwbdJbndjzrLCvHD1a3w$hYo8oHdf4gCwUEcWDuTwbywho5JhEkhut/zbPNKiztc=','2024-04-21 18:11:29.153735',1,'admin','','admin@admin.ru',1,1,'2024-04-21 18:10:21.590192','');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('6c18wjg04vlo2epwud201zby87qyqly1','.eJxVjEEOwiAQRe_C2hCYKgwu3XsGMgxTqRpISrsy3l2bdKHb_977LxVpXUpcu8xxyuqsrDr8bon4IXUD-U711jS3usxT0puid9r1tWV5Xnb376BQL986WKQgTsCYIycQSwxBOGUj2TvGMXtkAyfPjN45kGEcEBAAEgQvXr0_8sM34A:1rybez:ZvyFZ6F4k_RAAqRvxq2sJPNXNlmG4aQ3yLd5KiQkqB4','2024-05-05 18:11:29.157734');
INSERT INTO "touring_commodity" ("id","name") VALUES (1,'Фен'),
 (2,'Полотенца');
INSERT INTO "touring_direction" ("id","name","description") VALUES (1,'Средиземье','Толкин');
INSERT INTO "touring_area" ("id","name","description","direction_id") VALUES (1,'Ривендейл','Королевство горных эльфов, санаторий',1),
 (2,'Мордор','жарко',1);
INSERT INTO "touring_entertaiment" ("id","name","description","cost","area_id") VALUES (1,'Катание на единороге','Дух захватывает',10,1),
 (2,'Прятки с орками','на выживание',50,2);
INSERT INTO "touring_hotel" ("id","name","description","cost_per_night","area_id") VALUES (1,'У Элронда','Уютно',5,1),
 (2,'У Саурона','На виду',2,2);
INSERT INTO "touring_hotel_commodity" ("id","hotel_id","commodity_id") VALUES (1,1,1),
 (2,1,2),
 (3,2,1);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "touring_area_direction_id_0e10f475" ON "touring_area" (
	"direction_id"
);
CREATE INDEX IF NOT EXISTS "touring_entertaiment_area_id_2eedff14" ON "touring_entertaiment" (
	"area_id"
);
CREATE INDEX IF NOT EXISTS "touring_hotel_area_id_91dd46f8" ON "touring_hotel" (
	"area_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "touring_hotel_commodity_hotel_id_commodity_id_041eed60_uniq" ON "touring_hotel_commodity" (
	"hotel_id",
	"commodity_id"
);
CREATE INDEX IF NOT EXISTS "touring_hotel_commodity_hotel_id_04832fca" ON "touring_hotel_commodity" (
	"hotel_id"
);
CREATE INDEX IF NOT EXISTS "touring_hotel_commodity_commodity_id_31621ba9" ON "touring_hotel_commodity" (
	"commodity_id"
);
CREATE INDEX IF NOT EXISTS "touring_tour_entertaiments_id_dc88575a" ON "touring_tour" (
	"entertaiments_id"
);
CREATE INDEX IF NOT EXISTS "touring_tour_hotel_id_9ebec880" ON "touring_tour" (
	"hotel_id"
);
COMMIT;
