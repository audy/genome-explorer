# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180408202245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "features", force: :cascade do |t|
    t.integer  "start"
    t.integer  "stop"
    t.string   "strand"
    t.string   "feature_type"
    t.text     "info"
    t.integer  "scaffold_id"
    t.integer  "frame"
    t.string   "source"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "genome_id"
    t.hstore   "stats"
  end

  add_index "features", ["genome_id"], name: "index_features_on_genome_id", using: :btree
  add_index "features", ["scaffold_id"], name: "index_features_on_scaffold_id", using: :btree

  create_table "genomes", force: :cascade do |t|
    t.integer  "assembly_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "stats"
    t.hstore   "ncbi_metadata"
    t.string   "avatar"
    t.boolean  "in_graph",      default: false
    t.boolean  "annotated",     default: false
  end

  create_table "scaffolds", force: :cascade do |t|
    t.text     "sequence"
    t.integer  "genome_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scaffold_name"
  end

  add_index "scaffolds", ["genome_id"], name: "index_scaffolds_on_genome_id", using: :btree

end
