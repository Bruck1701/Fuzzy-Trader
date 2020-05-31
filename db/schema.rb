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

ActiveRecord::Schema.define(version: 2020_05_31_134731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aqueries", force: :cascade do |t|
    t.float "query_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "assets", force: :cascade do |t|
    t.integer "porfolio_id"
    t.string "category"
    t.string "name"
    t.float "qty"
    t.float "purchaseValue"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "currentvalues", force: :cascade do |t|
    t.string "name"
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "investmentassets", force: :cascade do |t|
    t.integer "portfolio_id"
    t.string "category"
    t.string "name"
    t.float "qty"
    t.float "purchaseValue"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "totalcurrval"
  end

  create_table "portfolios", force: :cascade do |t|
    t.integer "user_id"
    t.float "totalInv", default: 0.0
    t.float "currentVal", default: 0.0
    t.integer "cryptoAssets", default: 0
    t.integer "shareAssets", default: 0
    t.integer "totalAssets", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "checkingacc", default: 0.0
  end

  create_table "queryresults", force: :cascade do |t|
    t.integer "aquery_id"
    t.string "qrname"
    t.string "qrcategory"
    t.float "qrcurrentvalue"
    t.float "qrhigh"
    t.float "qrlow"
    t.integer "qrrecom"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "qraverage"
    t.integer "qravgperiod"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
