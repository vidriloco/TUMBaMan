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

ActiveRecord::Schema.define(version: 20140619170650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instants", force: true do |t|
    t.float    "speed"
    t.boolean  "is_old"
    t.boolean  "has_highest_quality"
    t.integer  "vehicle_id",                                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "coordinates",         limit: {:srid=>4326, :type=>"point"}
  end

  add_index "instants", ["vehicle_id"], :name => "index_instants_on_vehicle_id", :unique => true

  create_table "lines", force: true do |t|
    t.string   "name",              null: false
    t.string   "right_terminal",    null: false
    t.string   "left_terminal",     null: false
    t.integer  "transport_id",      null: false
    t.string   "color"
    t.string   "simple_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lines", ["transport_id"], :name => "index_lines_on_transport_id"

  create_table "paths", force: true do |t|
    t.string   "description"
    t.integer  "line_id",                                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "coordinates_vector", limit: {:srid=>4326, :type=>"line_string"}
  end

  create_table "stations", force: true do |t|
    t.string   "name",                                                null: false
    t.boolean  "is_terminal"
    t.boolean  "is_accessible"
    t.integer  "bike_parking"
    t.integer  "line_id",                                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "coordinates",   limit: {:srid=>4326, :type=>"point"}
  end

  add_index "stations", ["line_id"], :name => "index_stations_on_line_id"

  create_table "transports", force: true do |t|
    t.string   "name",       null: false
    t.string   "mode",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vehicles", force: true do |t|
    t.integer  "identifier",  limit: 8
    t.string   "description"
    t.integer  "line_id",               null: false
    t.datetime "created_at"
  end

  add_index "vehicles", ["id"], :name => "index_vehicles_on_id", :unique => true
  add_index "vehicles", ["identifier"], :name => "index_vehicles_on_identifier", :unique => true

end
