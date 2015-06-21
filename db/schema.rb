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

ActiveRecord::Schema.define(version: 20150621083534) do

  create_table "hosts", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "parse_url"
    t.string   "reserve_url"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "parse_type",  default: 1
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name", limit: 50, null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "host_id"
    t.integer  "guest",            limit: 2
    t.integer  "size",             limit: 2
    t.integer  "price"
    t.string   "facilities"
    t.integer  "discounted_price"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "month"
    t.integer  "day"
    t.boolean  "reserved"
    t.integer  "host_id"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "year"
  end

  add_index "schedules", ["host_id"], name: "index_schedules_on_host_id"
  add_index "schedules", ["room_id"], name: "index_schedules_on_room_id"

end
