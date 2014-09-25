CREATE TABLE "delayed_jobs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "priority" integer DEFAULT 0 NOT NULL, "attempts" integer DEFAULT 0 NOT NULL, "handler" text NOT NULL, "last_error" text, "run_at" datetime, "locked_at" datetime, "failed_at" datetime, "locked_by" varchar(255), "queue" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "features" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "start" integer, "stop" integer, "strand" varchar(255), "type" varchar(255), "info" varchar(255), "scaffold_id" integer, "frame" integer, "source" varchar(255), "score" float, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "genomes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "assembly_id" integer, "organism" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "scaffolds" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "sequence" text, "genome_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE INDEX "delayed_jobs_priority" ON "delayed_jobs" ("priority", "run_at");
CREATE INDEX "index_features_on_scaffold_id" ON "features" ("scaffold_id");
CREATE INDEX "index_scaffolds_on_genome_id" ON "scaffolds" ("genome_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20140924153355');

INSERT INTO schema_migrations (version) VALUES ('20140924160950');

INSERT INTO schema_migrations (version) VALUES ('20140924161350');

INSERT INTO schema_migrations (version) VALUES ('20140924161636');

