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
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
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
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
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
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
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
	FOREIGN KEY("direction_id") REFERENCES "touring_direction"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "touring_entertaiment" (
	"id"	integer NOT NULL,
	"name"	varchar(50) NOT NULL,
	"description"	varchar(500) NOT NULL,
	"cost"	smallint unsigned CHECK("cost" >= 0),
	"area_id"	bigint,
	FOREIGN KEY("area_id") REFERENCES "touring_area"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "touring_hotel" (
	"id"	integer NOT NULL,
	"name"	varchar(50) NOT NULL,
	"description"	varchar(500) NOT NULL,
	"cost_per_night"	smallint unsigned NOT NULL CHECK("cost_per_night" >= 0),
	"area_id"	bigint NOT NULL,
	FOREIGN KEY("area_id") REFERENCES "touring_area"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "touring_hotel_commodity" (
	"id"	integer NOT NULL,
	"hotel_id"	bigint NOT NULL,
	"commodity_id"	bigint NOT NULL,
	FOREIGN KEY("commodity_id") REFERENCES "touring_commodity"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("hotel_id") REFERENCES "touring_hotel"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "touring_profile" (
	"id"	integer NOT NULL,
	"date_of_birth"	date,
	"photo"	varchar(100) NOT NULL,
	"user_id"	integer NOT NULL UNIQUE,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "touring_tour" (
	"id"	char(32) NOT NULL,
	"checkin_date"	date NOT NULL,
	"checkout_date"	date NOT NULL,
	"hotel_id"	bigint,
	"tourist_id"	integer,
	"area_id"	bigint,
	"cost"	smallint unsigned CHECK("cost" >= 0),
	FOREIGN KEY("hotel_id") REFERENCES "touring_hotel"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("area_id") REFERENCES "touring_area"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("tourist_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "touring_tour_entertaiments" (
	"id"	integer NOT NULL,
	"tour_id"	char(32) NOT NULL,
	"entertaiment_id"	bigint NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("tour_id") REFERENCES "touring_tour"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("entertaiment_id") REFERENCES "touring_entertaiment"("id") DEFERRABLE INITIALLY DEFERRED
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
 (19,'touring','0001_initial','2024-04-21 18:09:37.420548'),
 (20,'touring','0002_alter_entertaiment_cost','2024-04-27 15:42:27.676115'),
 (21,'touring','0003_tour_tourist','2024-04-29 12:22:04.073199'),
 (22,'touring','0004_remove_tour_entertaiments_tour_entertaiments','2024-04-29 12:43:38.972663'),
 (23,'touring','0005_remove_tour_cost','2024-04-30 16:13:31.570267'),
 (24,'touring','0006_remove_tour_entertaiments_tour_cost','2024-04-30 17:20:53.136596'),
 (25,'touring','0007_tour_entertaiments','2024-04-30 18:00:11.448621'),
 (26,'touring','0008_alter_tour_options','2024-05-01 15:20:41.396263'),
 (27,'touring','0009_profile','2024-05-13 17:52:52.268097'),
 (28,'touring','0010_remove_tour_cost_remove_tour_entertaiments_and_more','2024-05-14 16:44:41.630357'),
 (29,'touring','0011_tour_area','2024-05-14 17:05:57.261373'),
 (30,'touring','0012_tour_cost_remove_tour_entertaiments_and_more','2024-05-14 17:32:35.074325');
INSERT INTO "auth_group_permissions" ("id","group_id","permission_id") VALUES (1,2,25),
 (2,2,26),
 (3,2,27),
 (4,2,28),
 (5,2,29),
 (6,2,30),
 (7,2,31),
 (8,2,32),
 (9,2,33),
 (10,2,34),
 (11,2,35),
 (12,2,36),
 (13,2,37),
 (14,2,38),
 (15,2,39),
 (16,2,40),
 (17,2,41),
 (18,2,42),
 (19,2,43),
 (20,2,44),
 (21,2,45),
 (22,2,46),
 (23,2,47),
 (24,2,48),
 (25,2,49);
INSERT INTO "auth_user_groups" ("id","user_id","group_id") VALUES (1,2,1),
 (2,3,2);
INSERT INTO "django_admin_log" ("id","object_id","object_repr","action_flag","change_message","content_type_id","user_id","action_time") VALUES (1,'1','Средиземье',1,'[{"added": {}}]',8,1,'2024-04-21 18:12:14.006013'),
 (2,'1','Ривендейл',1,'[{"added": {}}]',9,1,'2024-04-21 18:12:30.753196'),
 (3,'1','Фен',1,'[{"added": {}}]',7,1,'2024-04-21 18:13:08.239315'),
 (4,'2','Полотенца',1,'[{"added": {}}]',7,1,'2024-04-21 18:13:18.123225'),
 (5,'1','У Элронда',1,'[{"added": {}}]',11,1,'2024-04-21 18:13:36.416390'),
 (6,'2','Мордор',1,'[{"added": {}}]',9,1,'2024-04-21 18:14:00.732332'),
 (7,'2','У Саурона',1,'[{"added": {}}]',11,1,'2024-04-21 18:14:27.523881'),
 (8,'1','Катание на единороге',1,'[{"added": {}}]',10,1,'2024-04-21 18:15:03.330304'),
 (9,'2','Прятки с орками',1,'[{"added": {}}]',10,1,'2024-04-21 18:15:27.392772'),
 (10,'3','Горячая вода',1,'[{"added": {}}]',7,1,'2024-04-27 15:15:20.734044'),
 (11,'4','Горячая вода каждый день',1,'[{"added": {}}]',7,1,'2024-04-27 15:15:34.776800'),
 (12,'5','Тапочки',1,'[{"added": {}}]',7,1,'2024-04-27 15:17:25.985804'),
 (13,'6','Карта местности',1,'[{"added": {}}]',7,1,'2024-04-27 15:18:01.221756'),
 (14,'7','Сейф в номере',1,'[{"added": {}}]',7,1,'2024-04-27 15:20:29.626676'),
 (15,'8','Кондиционер',1,'[{"added": {}}]',7,1,'2024-04-27 15:20:54.898205'),
 (16,'9','Мини-бар',1,'[{"added": {}}]',7,1,'2024-04-27 15:21:18.138574'),
 (17,'10','Парковка',1,'[{"added": {}}]',7,1,'2024-04-27 15:21:50.268772'),
 (18,'11','Питьевая вода в номере',1,'[{"added": {}}]',7,1,'2024-04-27 15:22:02.086281'),
 (19,'12','Зубная щетка',1,'[{"added": {}}]',7,1,'2024-04-27 15:23:18.613414'),
 (20,'13','Мыло',1,'[{"added": {}}]',7,1,'2024-04-27 15:23:24.370985'),
 (21,'14','Шампунь',1,'[{"added": {}}]',7,1,'2024-04-27 15:23:30.842834'),
 (22,'15','Гель для душа',1,'[{"added": {}}]',7,1,'2024-04-27 15:23:38.630618'),
 (23,'16','Банный халат',1,'[{"added": {}}]',7,1,'2024-04-27 15:24:10.084059'),
 (24,'17','Зубная паста',1,'[{"added": {}}]',7,1,'2024-04-27 15:24:31.475296'),
 (25,'18','Завтрак',1,'[{"added": {}}]',7,1,'2024-04-27 15:24:56.308000'),
 (26,'3','Шир',1,'[{"added": {}}]',9,1,'2024-04-27 15:27:09.293841'),
 (27,'3','Усадьба Бэг Энд',1,'[{"added": {}}]',11,1,'2024-04-27 15:30:29.298653'),
 (28,'3','Дегустация местного табака',1,'[{"added": {}}]',10,1,'2024-04-27 15:33:29.026784'),
 (29,'3','Дегустация местного табака',2,'[{"changed": {"fields": ["Description"]}}]',10,1,'2024-04-27 15:34:04.935805'),
 (30,'4','Бросание каштанов',1,'[{"added": {}}]',10,1,'2024-04-27 15:35:48.234293'),
 (31,'5','Метание колечек в жерло вулкана',1,'[{"added": {}}]',10,1,'2024-04-27 15:39:39.169282'),
 (32,'2','Прятки с орками',2,'[{"changed": {"fields": ["Description", "Cost"]}}]',10,1,'2024-04-27 15:41:21.579616'),
 (33,'1','Катание на единороге',2,'[{"changed": {"fields": ["Description"]}}]',10,1,'2024-04-27 15:43:56.725079'),
 (34,'6','Медитации',1,'[{"added": {}}]',10,1,'2024-04-27 15:45:37.448051'),
 (35,'7','Психотерапия с Элрондом',1,'[{"added": {}}]',10,1,'2024-04-27 15:48:27.025949'),
 (36,'1','Agency customer',1,'[{"added": {}}]',3,1,'2024-04-27 15:50:36.422581'),
 (37,'2','Anna',1,'[{"added": {}}]',4,1,'2024-04-27 15:54:22.317909'),
 (38,'2','Anna',2,'[{"changed": {"fields": ["First name"]}}]',4,1,'2024-04-27 15:55:38.110268'),
 (39,'2','Anna',2,'[{"changed": {"fields": ["Last name", "Email address", "Groups"]}}]',4,1,'2024-04-27 15:56:13.869673'),
 (40,'2','Tour Agent',1,'[{"added": {}}]',3,1,'2024-04-27 16:03:16.960739'),
 (41,'3','Agent',1,'[{"added": {}}]',4,1,'2024-04-27 16:04:50.449119'),
 (42,'3','Agent',2,'[{"changed": {"fields": ["First name", "Last name", "Staff status", "Groups"]}}]',4,1,'2024-04-27 16:05:20.114234'),
 (43,'60a36299-fbb8-46c5-93c4-2e5cf67ee90a','60a36299-fbb8-46c5-93c4-2e5cf67ee90a',1,'[{"added": {}}]',12,1,'2024-04-30 16:14:40.076641'),
 (44,'60a36299-fbb8-46c5-93c4-2e5cf67ee90a','60a36299-fbb8-46c5-93c4-2e5cf67ee90a',3,'',12,1,'2024-04-30 18:09:58.181520'),
 (45,'2bf63040-d55a-4d4e-a9c6-501aa3283536','2bf63040-d55a-4d4e-a9c6-501aa3283536',1,'[{"added": {}}]',12,1,'2024-04-30 19:03:46.747871'),
 (46,'2bf63040-d55a-4d4e-a9c6-501aa3283536','2bf63040-d55a-4d4e-a9c6-501aa3283536',2,'[{"changed": {"fields": ["Checkout date"]}}]',12,1,'2024-04-30 19:04:07.934957'),
 (47,'2bf63040-d55a-4d4e-a9c6-501aa3283536','2bf63040-d55a-4d4e-a9c6-501aa3283536',2,'[{"changed": {"fields": ["Checkin date", "Checkout date"]}}]',12,1,'2024-04-30 19:23:41.480440'),
 (48,'2bf63040-d55a-4d4e-a9c6-501aa3283536','2bf63040-d55a-4d4e-a9c6-501aa3283536',2,'[{"changed": {"fields": ["Checkout date"]}}]',12,1,'2024-04-30 19:25:58.596866'),
 (49,'2bf63040-d55a-4d4e-a9c6-501aa3283536','2bf63040-d55a-4d4e-a9c6-501aa3283536',2,'[{"changed": {"fields": ["Checkout date"]}}]',12,1,'2024-04-30 19:32:32.807115'),
 (50,'2','Tour Agent',2,'[{"changed": {"fields": ["Permissions"]}}]',3,1,'2024-05-01 15:21:34.619925'),
 (51,'7','Психотерапия с Элрондом',3,'',10,1,'2024-05-02 12:10:43.253729'),
 (52,'6','Медитации',3,'',10,1,'2024-05-02 12:10:43.269913'),
 (53,'5','Метание колечек в жерло вулкана',3,'',10,1,'2024-05-02 12:10:43.269913'),
 (54,'4','Бросание каштанов',3,'',10,1,'2024-05-02 12:10:43.277933'),
 (55,'3','Дегустация местного табака',3,'',10,1,'2024-05-02 12:10:43.286214'),
 (56,'2','Прятки с орками',3,'',10,1,'2024-05-02 12:10:43.294222'),
 (57,'1','Катание на единороге',3,'',10,1,'2024-05-02 12:10:43.302216'),
 (58,'8','Катание на единороге',1,'[{"added": {}}]',10,1,'2024-05-06 18:24:00.486727'),
 (59,'9','Прятки с орками',1,'[{"added": {}}]',10,1,'2024-05-06 18:24:19.083803'),
 (60,'10','Дегустация местного табака',1,'[{"added": {}}]',10,1,'2024-05-06 18:25:07.097091'),
 (61,'2bf63040-d55a-4d4e-a9c6-501aa3283536','2bf63040-d55a-4d4e-a9c6-501aa3283536',2,'[{"changed": {"fields": ["Entertaiments"]}}]',12,1,'2024-05-06 18:25:55.779473'),
 (62,'2bf63040-d55a-4d4e-a9c6-501aa3283536','2bf63040-d55a-4d4e-a9c6-501aa3283536',3,'',12,1,'2024-05-06 18:30:56.175835'),
 (63,'ba67484b-e601-4de0-a5c1-394a5e1fe758','ba67484b-e601-4de0-a5c1-394a5e1fe758',3,'',12,1,'2024-05-07 15:29:24.616887'),
 (64,'a25f5a47-f210-4778-9992-6350c0bc7060','a25f5a47-f210-4778-9992-6350c0bc7060',3,'',12,1,'2024-05-07 15:29:24.620896'),
 (65,'6ba71893-f8da-45d6-8291-95f98bad9dcf','6ba71893-f8da-45d6-8291-95f98bad9dcf',3,'',12,1,'2024-05-07 15:29:24.625886'),
 (66,'3b771b96-99fe-4f25-9f92-45603196f9fc','3b771b96-99fe-4f25-9f92-45603196f9fc',3,'',12,1,'2024-05-07 15:29:24.630888'),
 (67,'b8c56b36-e445-402e-b612-12d6a9729c38','b8c56b36-e445-402e-b612-12d6a9729c38',3,'',12,1,'2024-05-07 16:02:39.700520'),
 (68,'b7c93c48-aae4-4624-a54c-d2d1238bfc49','b7c93c48-aae4-4624-a54c-d2d1238bfc49',3,'',12,1,'2024-05-07 16:02:39.705335'),
 (69,'abc71176-d648-471c-a96f-362217eb0935','abc71176-d648-471c-a96f-362217eb0935',3,'',12,1,'2024-05-07 16:02:39.710353'),
 (70,'86f8590a-22ca-4552-aa3f-53dd0af662e8','86f8590a-22ca-4552-aa3f-53dd0af662e8',3,'',12,1,'2024-05-07 16:02:39.714452'),
 (71,'28eb4d94-b1d0-4971-b7b1-71e8ee9be3a8','28eb4d94-b1d0-4971-b7b1-71e8ee9be3a8',3,'',12,1,'2024-05-07 16:02:39.718957'),
 (72,'ef68ca90-3fc7-4389-8503-95b86758fefb','ef68ca90-3fc7-4389-8503-95b86758fefb',3,'',12,1,'2024-05-07 16:25:38.713036'),
 (73,'a5545018-1fab-48a6-88d6-0569659370f2','a5545018-1fab-48a6-88d6-0569659370f2',3,'',12,1,'2024-05-07 16:25:38.718149'),
 (74,'9e3f18f0-ca84-476f-877e-1ad8aebb35af','9e3f18f0-ca84-476f-877e-1ad8aebb35af',3,'',12,1,'2024-05-07 16:25:38.722144'),
 (75,'eaba9895-587a-4179-b861-34b504a19df9','eaba9895-587a-4179-b861-34b504a19df9',3,'',12,1,'2024-05-07 16:51:05.956891'),
 (76,'b32bac38-cabe-4133-9fa5-9c83c2865c0e','b32bac38-cabe-4133-9fa5-9c83c2865c0e',3,'',12,1,'2024-05-07 16:51:05.961519'),
 (77,'8f23c4a0-fd9d-4a1c-b118-ffcaa36a4a88','8f23c4a0-fd9d-4a1c-b118-ffcaa36a4a88',3,'',12,1,'2024-05-07 16:51:05.966519'),
 (78,'38b9959d-b726-4a87-8116-3505f6eb9e0b','38b9959d-b726-4a87-8116-3505f6eb9e0b',3,'',12,1,'2024-05-07 16:51:05.970035'),
 (79,'2811f803-e130-4209-80a3-c7a0de3a8e39','2811f803-e130-4209-80a3-c7a0de3a8e39',3,'',12,1,'2024-05-07 16:51:05.975033'),
 (80,'ee8d1b7e-491d-4d38-85b9-e94b5c4bac58','ee8d1b7e-491d-4d38-85b9-e94b5c4bac58',3,'',12,1,'2024-05-07 17:02:33.085671'),
 (81,'ee82cf62-2cf5-452f-98c6-3f3a0d95164f','ee82cf62-2cf5-452f-98c6-3f3a0d95164f',3,'',12,1,'2024-05-07 17:02:33.090612'),
 (82,'8f90805a-8f75-467c-b785-10452d4c786f','8f90805a-8f75-467c-b785-10452d4c786f',3,'',12,1,'2024-05-07 17:02:33.095207'),
 (83,'c9d1f769-d93e-4c96-a6af-088b86d29962','c9d1f769-d93e-4c96-a6af-088b86d29962',3,'',12,1,'2024-05-07 17:04:14.233892'),
 (84,'525d1015-c7b5-479a-bf6e-4f3cfc295145','525d1015-c7b5-479a-bf6e-4f3cfc295145',3,'',12,1,'2024-05-07 17:50:24.969580'),
 (85,'21350b16-43f1-4b00-8933-3c98f8f6f4a7','21350b16-43f1-4b00-8933-3c98f8f6f4a7',3,'',12,1,'2024-05-07 17:50:24.974798'),
 (86,'e033aca6-e89f-4693-abc7-ea295ce6f303','e033aca6-e89f-4693-abc7-ea295ce6f303',3,'',12,1,'2024-05-08 12:15:31.494964'),
 (87,'8af77d1f-943d-4980-875f-7e8e1c56007f','8af77d1f-943d-4980-875f-7e8e1c56007f',3,'',12,1,'2024-05-08 12:15:31.500279'),
 (88,'82f8ffd7-f398-49ce-be27-e2828adf2500','82f8ffd7-f398-49ce-be27-e2828adf2500',3,'',12,1,'2024-05-08 12:15:31.504279'),
 (89,'1371d830-8bf7-421c-a0a0-156a0307980d','1371d830-8bf7-421c-a0a0-156a0307980d',3,'',12,1,'2024-05-08 12:15:31.509262'),
 (90,'b736425e-7edd-4a81-a11c-c1989324ad0f','b736425e-7edd-4a81-a11c-c1989324ad0f',3,'',12,1,'2024-05-10 14:37:05.932630'),
 (91,'b572e913-e826-4a26-aec8-98b797dcec41','b572e913-e826-4a26-aec8-98b797dcec41',3,'',12,1,'2024-05-10 14:37:05.938020'),
 (92,'a226c809-8c8f-4d3c-aee6-bb56d76397c1','a226c809-8c8f-4d3c-aee6-bb56d76397c1',3,'',12,1,'2024-05-10 14:37:05.942061'),
 (93,'949115ac-040e-4b22-a171-4d6fb9ae47f8','949115ac-040e-4b22-a171-4d6fb9ae47f8',3,'',12,1,'2024-05-10 14:37:05.942061'),
 (94,'8afc4de0-8a2a-4902-a067-54a2e776a224','8afc4de0-8a2a-4902-a067-54a2e776a224',3,'',12,1,'2024-05-10 14:37:05.942061'),
 (95,'5f0eb4a3-6468-4787-8ff5-094fd9229e36','5f0eb4a3-6468-4787-8ff5-094fd9229e36',3,'',12,1,'2024-05-10 14:37:05.942061'),
 (96,'5aca5647-b23d-4fa1-b9c4-0582eeb66d30','5aca5647-b23d-4fa1-b9c4-0582eeb66d30',3,'',12,1,'2024-05-10 14:37:05.958693'),
 (97,'504b8132-72ef-4d8c-9e13-7c115fc63bb8','504b8132-72ef-4d8c-9e13-7c115fc63bb8',3,'',12,1,'2024-05-10 14:37:05.958693'),
 (98,'17b11871-795c-459b-860e-9806e10c85fd','17b11871-795c-459b-860e-9806e10c85fd',3,'',12,1,'2024-05-10 14:37:05.958693'),
 (99,'070fdf5d-4188-47ff-9c2a-fdb6a03fc565','070fdf5d-4188-47ff-9c2a-fdb6a03fc565',3,'',12,1,'2024-05-10 14:37:05.958693'),
 (100,'1','Профиль пользователя Anna',1,'[{"added": {}}]',13,1,'2024-05-13 20:48:20.723786'),
 (101,'fc51e73e-cb42-4e34-a001-4b32454a23f9','fc51e73e-cb42-4e34-a001-4b32454a23f9',3,'',12,1,'2024-05-14 14:20:04.933619'),
 (102,'fb780b1e-0828-4c97-a051-ca5022ec7010','fb780b1e-0828-4c97-a051-ca5022ec7010',3,'',12,1,'2024-05-14 14:20:04.938838'),
 (103,'abf7eb54-96a3-480e-8463-0a570869394a','abf7eb54-96a3-480e-8463-0a570869394a',3,'',12,1,'2024-05-14 14:20:04.942832'),
 (104,'9c410169-14c3-46b0-95d3-a02f2ba8c366','9c410169-14c3-46b0-95d3-a02f2ba8c366',3,'',12,1,'2024-05-14 14:20:04.947660'),
 (105,'721e9957-0c81-4493-8a93-51b2efc65bda','721e9957-0c81-4493-8a93-51b2efc65bda',3,'',12,1,'2024-05-14 14:20:04.948817'),
 (106,'39ccfda2-668b-44b1-81b4-3fca2d2b9cbb','39ccfda2-668b-44b1-81b4-3fca2d2b9cbb',3,'',12,1,'2024-05-14 14:20:04.948817'),
 (107,'0dfb4dd0-4fb2-4bc6-8138-c0c7e333e54d','0dfb4dd0-4fb2-4bc6-8138-c0c7e333e54d',3,'',12,1,'2024-05-14 14:20:04.948817'),
 (108,'0df27f5c-d36a-4c7a-a4ea-765747b8699c','0df27f5c-d36a-4c7a-a4ea-765747b8699c',3,'',12,1,'2024-05-14 14:20:04.965291'),
 (109,'0ddae897-85c7-4d9a-8d71-7f292ceae61e','0ddae897-85c7-4d9a-8d71-7f292ceae61e',3,'',12,1,'2024-05-14 14:20:04.965291'),
 (110,'0dab3549-e3ee-42f1-8d35-0d7af01ba67c','0dab3549-e3ee-42f1-8d35-0d7af01ba67c',3,'',12,1,'2024-05-14 14:20:04.965291'),
 (111,'076ba06e-3c08-45f4-80b2-87bd49e8d06c','076ba06e-3c08-45f4-80b2-87bd49e8d06c',3,'',12,1,'2024-05-14 14:20:04.965291'),
 (112,'f9bfee71-9e23-4891-a0e7-4658862be332','f9bfee71-9e23-4891-a0e7-4658862be332',3,'',12,1,'2024-05-14 15:29:04.649110'),
 (113,'d43e850e-2f0b-4786-8d3f-f61097da5862','d43e850e-2f0b-4786-8d3f-f61097da5862',3,'',12,1,'2024-05-14 15:29:04.654651'),
 (114,'8987dfa3-b943-458f-84b6-077cc2aa1795','8987dfa3-b943-458f-84b6-077cc2aa1795',3,'',12,1,'2024-05-14 15:29:04.659939'),
 (115,'5dc72ad3-a703-4c7c-9d9b-d68a08595963','5dc72ad3-a703-4c7c-9d9b-d68a08595963',3,'',12,1,'2024-05-14 15:29:04.659939'),
 (116,'2592d382-94c4-4e09-b416-23ae0157b64f','2592d382-94c4-4e09-b416-23ae0157b64f',3,'',12,1,'2024-05-14 15:29:04.659939'),
 (117,'24224cb7-2979-4f69-9eea-40b5d5daaed8','24224cb7-2979-4f69-9eea-40b5d5daaed8',3,'',12,1,'2024-05-14 15:29:04.659939'),
 (118,'1cb2f5bd-72f7-4242-8f57-04c4e0fa98aa','1cb2f5bd-72f7-4242-8f57-04c4e0fa98aa',3,'',12,1,'2024-05-14 15:29:04.676242'),
 (119,'18ce5c42-426d-4e65-b073-c49a90052285','18ce5c42-426d-4e65-b073-c49a90052285',3,'',12,1,'2024-05-14 15:29:04.676242'),
 (120,'0c6cae94-581c-4d29-b8c0-84ab1a11cd5d','0c6cae94-581c-4d29-b8c0-84ab1a11cd5d',3,'',12,1,'2024-05-14 15:29:04.676242'),
 (121,'d24c1c08-2a78-4fee-8c4c-b4cc056ff3af','d24c1c08-2a78-4fee-8c4c-b4cc056ff3af',1,'[{"added": {}}]',12,1,'2024-05-14 16:45:46.666972'),
 (122,'b667743a-645a-4819-a287-127781e676f8','b667743a-645a-4819-a287-127781e676f8',1,'[{"added": {}}]',12,1,'2024-05-14 16:47:16.193015'),
 (123,'08063a69-e5a8-4f29-856d-87b004b8e8da','08063a69-e5a8-4f29-856d-87b004b8e8da',1,'[{"added": {}}]',12,1,'2024-05-14 16:47:45.676636'),
 (124,'d24c1c08-2a78-4fee-8c4c-b4cc056ff3af','d24c1c08-2a78-4fee-8c4c-b4cc056ff3af',3,'',12,1,'2024-05-14 16:48:01.545052'),
 (125,'b667743a-645a-4819-a287-127781e676f8','b667743a-645a-4819-a287-127781e676f8',3,'',12,1,'2024-05-14 16:48:01.550325'),
 (126,'08063a69-e5a8-4f29-856d-87b004b8e8da','08063a69-e5a8-4f29-856d-87b004b8e8da',3,'',12,1,'2024-05-14 16:48:01.554316'),
 (127,'f40fdc6b-6991-4602-a769-e9057c9d2f15','f40fdc6b-6991-4602-a769-e9057c9d2f15',1,'[{"added": {}}]',12,1,'2024-05-14 17:29:20.668578'),
 (128,'b3c64d76-2608-41da-8a01-b6f28a828888','b3c64d76-2608-41da-8a01-b6f28a828888',1,'[{"added": {}}]',12,1,'2024-05-14 17:38:41.927209'),
 (129,'dff3488b-a9a9-4740-b136-5be9719e5b17','dff3488b-a9a9-4740-b136-5be9719e5b17',1,'[{"added": {}}]',12,1,'2024-05-14 17:41:11.184260');
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
 (12,'touring','tour'),
 (13,'touring','profile');
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
 (48,12,'view_tour','Can view tour'),
 (49,12,'can_view','Set all tours'),
 (50,13,'add_profile','Can add profile'),
 (51,13,'change_profile','Can change profile'),
 (52,13,'delete_profile','Can delete profile'),
 (53,13,'view_profile','Can view profile');
INSERT INTO "auth_group" ("id","name") VALUES (1,'Agency customer'),
 (2,'Tour Agent');
INSERT INTO "auth_user" ("id","password","last_login","is_superuser","username","last_name","email","is_staff","is_active","date_joined","first_name") VALUES (1,'pbkdf2_sha256$720000$ppMwbdJbndjzrLCvHD1a3w$hYo8oHdf4gCwUEcWDuTwbywho5JhEkhut/zbPNKiztc=','2024-05-14 16:45:17.070861',1,'admin','','admin@admin.ru',1,1,'2024-04-21 18:10:21.590192',''),
 (2,'pbkdf2_sha256$720000$NpGxXAgsxywIywNqwgs0Zw$p5TuxlKjyfKkoOtAqpU1QIgfmywy37mzHI26AHeQYSY=','2024-05-14 17:46:44.565856',0,'Anna','Elis','apelbsinka48@gmail.com',0,1,'2024-04-27 15:54:21','Anna'),
 (3,'pbkdf2_sha256$720000$xYn8wQngYJPZm87ltxARTn$CIAudBkR94S6ZpKN2fRM/Kw1MLVITPEHgx0+LDXh4yw=','2024-05-10 14:25:47.748109',0,'Agent','Agent','',1,1,'2024-04-27 16:04:49','Agent'),
 (4,'pbkdf2_sha256$720000$B2LCW1d9STXRh1baQPUwgr$TCHnL21gnDvfG4XBboP0keH6FXpcGEPbNOJU5FbT56k=','2024-05-14 17:50:00.600449',0,'Sergio','','kunicasbumerangom@gmail.com',0,1,'2024-05-10 17:43:51.387077','');
INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('cy8f2ooqrfu8dlbb4rvppncwikw0256r','.eJxVjDsOgzAQBe-ydWQZ1sYsZfqcwVr_gvMxEoY0Ue4ekGhoZ-a9L5T1bT-55qXCgBewvC6jXWucbQ4wgIITc-yfsewiPLjcJ-GnsszZiT0Rh63iNoX4uh7t6WDkOm5rRwklRm5I9w0F9J1qdEdR92QCJq0McicNB61aUuR6GZ1L3qOkjcgWfn9qzDwj:1s5UOI:xuEgN642n01J-MjBrmK2lvqLy-YUkW0UD4Q1CJaseiA','2024-05-24 17:50:42.893623');
INSERT INTO "touring_commodity" ("id","name") VALUES (1,'Фен'),
 (2,'Полотенца'),
 (3,'Горячая вода'),
 (4,'Горячая вода каждый день'),
 (5,'Тапочки'),
 (6,'Карта местности'),
 (7,'Сейф в номере'),
 (8,'Кондиционер'),
 (9,'Мини-бар'),
 (10,'Парковка'),
 (11,'Питьевая вода в номере'),
 (12,'Зубная щетка'),
 (13,'Мыло'),
 (14,'Шампунь'),
 (15,'Гель для душа'),
 (16,'Банный халат'),
 (17,'Зубная паста'),
 (18,'Завтрак');
INSERT INTO "touring_direction" ("id","name","description") VALUES (1,'Средиземье','Толкин');
INSERT INTO "touring_area" ("id","name","description","direction_id") VALUES (1,'Ривендейл','Королевство горных эльфов, санаторий',1),
 (2,'Мордор','жарко',1),
 (3,'Шир','Обиталище хоббитов',1);
INSERT INTO "touring_entertaiment" ("id","name","description","cost","area_id") VALUES (8,'Катание на единороге','Дух захватывает',2,1),
 (9,'Прятки с орками','на выживание',2,2),
 (10,'Дегустация местного табака','Попробуйте самые изысканные сорта курительного зелья, выращенного местными жителями',3,3);
INSERT INTO "touring_hotel" ("id","name","description","cost_per_night","area_id") VALUES (1,'У Элронда','Уютно',5,1),
 (2,'У Саурона','На виду',2,2),
 (3,'Усадьба Бэг Энд','Благоустроенная хоббичья нора',10,3);
INSERT INTO "touring_hotel_commodity" ("id","hotel_id","commodity_id") VALUES (1,1,1),
 (2,1,2),
 (3,2,1),
 (4,3,1),
 (5,3,2),
 (6,3,4),
 (7,3,5),
 (8,3,6),
 (9,3,7),
 (10,3,9),
 (11,3,10),
 (12,3,11),
 (13,3,12),
 (14,3,13),
 (15,3,14),
 (16,3,15),
 (17,3,16),
 (18,3,17),
 (19,3,18);
INSERT INTO "touring_profile" ("id","date_of_birth","photo","user_id") VALUES (1,'1951-03-31','',2);
INSERT INTO "touring_tour" ("id","checkin_date","checkout_date","hotel_id","tourist_id","area_id","cost") VALUES ('f40fdc6b69914602a769e9057c9d2f15','2024-05-15','2024-05-16',1,2,2,NULL),
 ('b3c64d76260841da8a01b6f28a828888','2024-05-14','2024-05-17',2,2,1,NULL),
 ('dff3488ba9a94740b1365be9719e5b17','2024-05-14','2024-05-17',2,2,1,NULL),
 ('9f08a8730c7742d2b73d9dbad763832a','2024-05-18','2024-05-24',1,2,NULL,NULL),
 ('d3613674cc4942c6a91c4e9c95922274','2024-05-17','2024-06-02',1,4,NULL,NULL);
INSERT INTO "touring_tour_entertaiments" ("id","tour_id","entertaiment_id") VALUES (1,'b3c64d76260841da8a01b6f28a828888',8),
 (2,'b3c64d76260841da8a01b6f28a828888',10),
 (3,'dff3488ba9a94740b1365be9719e5b17',8),
 (4,'dff3488ba9a94740b1365be9719e5b17',10),
 (5,'9f08a8730c7742d2b73d9dbad763832a',9),
 (6,'9f08a8730c7742d2b73d9dbad763832a',10),
 (7,'d3613674cc4942c6a91c4e9c95922274',8),
 (8,'d3613674cc4942c6a91c4e9c95922274',10);
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
CREATE INDEX IF NOT EXISTS "touring_tour_hotel_id_9ebec880" ON "touring_tour" (
	"hotel_id"
);
CREATE INDEX IF NOT EXISTS "touring_tour_tourist_id_fe0dae46" ON "touring_tour" (
	"tourist_id"
);
CREATE INDEX IF NOT EXISTS "touring_tour_area_id_1c5d3841" ON "touring_tour" (
	"area_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "touring_tour_entertaiments_tour_id_entertaiment_id_d5aa9fc5_uniq" ON "touring_tour_entertaiments" (
	"tour_id",
	"entertaiment_id"
);
CREATE INDEX IF NOT EXISTS "touring_tour_entertaiments_tour_id_1763ed53" ON "touring_tour_entertaiments" (
	"tour_id"
);
CREATE INDEX IF NOT EXISTS "touring_tour_entertaiments_entertaiment_id_f2a38b21" ON "touring_tour_entertaiments" (
	"entertaiment_id"
);
COMMIT;
