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

ActiveRecord::Schema.define(version: 2024_07_03_143614) do

  create_table "products", force: :cascade do |t|
    t.integer "id_product"
    t.string "name"
    t.text "description"
    t.string "site"
    t.decimal "price", precision: 10, scale: 2
    t.string "category"
    t.string "url"
    t.string "currency"
    t.index ["id_product"], name: "index_products_on_id_product", unique: true
  end

  create_table "reports", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "id_product"
    t.index ["id_product"], name: "index_reports_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.boolean "isAnalyst", default: false
    t.boolean "isAdministrator", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "test", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider"
    t.string "uid"
    t.string "username"
    t.string "oauth_token"
    t.string "oauth_refresh_token"
    t.datetime "oauth_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "wishlists", force: :cascade do |t|
    t.integer "product_id"
    t.string "username"
    t.string "labels"
    t.index ["product_id", "username"], name: "index_wishlists_on_product_id_and_username", unique: true
  end

  add_foreign_key "wishlists", "products", primary_key: "id_product"
  add_foreign_key "wishlists", "users", column: "username", primary_key: "username"
end
