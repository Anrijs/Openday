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

ActiveRecord::Schema.define(version: 20140305145408) do

  create_table "admins", force: true do |t|
    t.string   "username",               default: "", null: false
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["username"], name: "index_admins_on_username", unique: true, using: :btree

  create_table "faculties", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.text     "description"
    t.string   "url"
  end

  create_table "images", force: true do |t|
    t.string   "image_uid"
    t.string   "image_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "openday_faculties", force: true do |t|
    t.integer "openday_id"
    t.integer "faculty_id"
  end

  create_table "openday_programmes", force: true do |t|
    t.integer "openday_faculty_id"
    t.integer "programme_id"
  end

  create_table "openday_timeslots", force: true do |t|
    t.integer "openday_programme_id"
    t.time    "time_from"
    t.time    "time_till"
    t.integer "capacity"
  end

  create_table "opendays", force: true do |t|
    t.string   "name"
    t.integer  "year"
    t.datetime "registration_open"
    t.datetime "registration_end"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "programmes", force: true do |t|
    t.string   "name"
    t.integer  "faculty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.text     "description"
    t.string   "url"
  end

  create_table "registrants", force: true do |t|
    t.string   "name"
    t.string   "prefix"
    t.string   "surname"
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal_code"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "openday_id"
  end

  create_table "registrations", force: true do |t|
    t.integer  "registrant_id"
    t.integer  "timeslot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "openday_id"
  end

  create_table "settings", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
