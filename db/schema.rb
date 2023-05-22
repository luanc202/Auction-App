# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_21_155911) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "auction_batches", force: :cascade do |t|
    t.string "code"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "minimum_bid_amount"
    t.integer "minimum_bid_difference"
    t.integer "status", default: 0
    t.integer "approved_by_user_id"
    t.integer "created_by_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auction_item_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auction_items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "weight"
    t.integer "width"
    t.integer "height"
    t.integer "depth"
    t.integer "auction_item_category_id", null: false
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "auction_batch_id"
    t.index ["auction_batch_id"], name: "index_auction_items_on_auction_batch_id"
    t.index ["auction_item_category_id"], name: "index_auction_items_on_auction_item_category_id"
  end

  create_table "auction_question_replies", force: :cascade do |t|
    t.string "reply"
    t.integer "user_id", null: false
    t.integer "auction_question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_question_id"], name: "index_auction_question_replies_on_auction_question_id"
    t.index ["user_id"], name: "index_auction_question_replies_on_user_id"
  end

  create_table "auction_questions", force: :cascade do |t|
    t.string "question"
    t.integer "status", default: 0
    t.integer "user_id", null: false
    t.integer "auction_batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_batch_id"], name: "index_auction_questions_on_auction_batch_id"
    t.index ["user_id"], name: "index_auction_questions_on_user_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer "value"
    t.integer "auction_batch_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_batch_id"], name: "index_bids_on_auction_batch_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "user_fav_batches", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "auction_batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_batch_id"], name: "index_user_fav_batches_on_auction_batch_id"
    t.index ["user_id"], name: "index_user_fav_batches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "role", default: 0, null: false
    t.string "cpf", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "won_auction_batches", force: :cascade do |t|
    t.integer "auction_batch_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_batch_id"], name: "index_won_auction_batches_on_auction_batch_id"
    t.index ["user_id"], name: "index_won_auction_batches_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "auction_items", "auction_batches"
  add_foreign_key "auction_items", "auction_item_categories"
  add_foreign_key "auction_question_replies", "auction_questions"
  add_foreign_key "auction_question_replies", "users"
  add_foreign_key "auction_questions", "auction_batches"
  add_foreign_key "auction_questions", "users"
  add_foreign_key "bids", "auction_batches"
  add_foreign_key "bids", "users"
  add_foreign_key "user_fav_batches", "auction_batches"
  add_foreign_key "user_fav_batches", "users"
  add_foreign_key "won_auction_batches", "auction_batches"
  add_foreign_key "won_auction_batches", "users"
end
