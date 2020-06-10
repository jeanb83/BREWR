# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_10_093925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_memberships_on_event_id"
    t.index ["user_id"], name: "index_event_memberships_on_user_id"
  end

  create_table "event_places", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "yelp_id"
    t.integer "rank"
    t.boolean "booking_status"
    t.string "yelp_name"
    t.string "yelp_price"
    t.float "yelp_longitude"
    t.float "yelp_latitude"
    t.string "yelp_phone"
    t.integer "yelp_rating"
    t.integer "yelp_review_count"
    t.string "yelp_url"
    t.string "yelp_image_url"
    t.string "yelp_address1"
    t.string "yelp_address2"
    t.string "yelp_address3"
    t.string "yelp_city"
    t.string "yelp_zip_code"
    t.string "yelp_state"
    t.string "yelp_country"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_places_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.bigint "group_id", null: false
    t.string "city"
    t.integer "stage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar_file"
    t.index ["group_id"], name: "index_events_on_group_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar_file"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_messages_on_group_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.integer "importance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "nickname"
    t.string "avatar_file"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "event_membership_id", null: false
    t.string "type"
    t.integer "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_membership_id"], name: "index_votes_on_event_membership_id"
  end

  add_foreign_key "event_memberships", "events"
  add_foreign_key "event_memberships", "users"
  add_foreign_key "event_places", "events"
  add_foreign_key "events", "groups"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "messages", "groups"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "votes", "event_memberships"
end
