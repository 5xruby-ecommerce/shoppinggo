ActiveRecord::Schema.define(version: 2021_01_05_072028) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coupons", force: :cascade do |t|
    t.string "title"
    t.integer "discount_rule"
    t.datetime "discount_start"
    t.datetime "discount_end"
    t.integer "min_consumption"
    t.integer "amount"
    t.integer "counter_catch", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "shop_id"
    t.integer "discount_amount"
    t.index ["shop_id"], name: "index_coupons_on_shop_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.string "category"
    t.integer "quantity"
    t.integer "price"
    t.bigint "sub_order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.index ["sub_order_id"], name: "index_order_items_on_sub_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "sum"
    t.integer "status"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "number"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "content"
    t.integer "price"
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "shop_id"
    t.string "image"
    t.string "images"
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_rooms_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_rooms_on_sender_id_and_receiver_id", unique: true
    t.index ["sender_id"], name: "index_rooms_on_sender_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "tel"
    t.integer "status"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_shops_on_user_id"
  end

  create_table "sub_orders", force: :cascade do |t|
    t.bigint "sum"
    t.integer "status"
    t.text "comment"
    t.bigint "order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_sub_orders_on_order_id"
  end

  create_table "user_coupons", force: :cascade do |t|
    t.integer "coupon_status"
    t.bigint "user_id", null: false
    t.bigint "coupon_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coupon_id"], name: "index_user_coupons_on_coupon_id"
    t.index ["user_id"], name: "index_user_coupons_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "birth"
    t.string "phone"
    t.string "user_account"
    t.string "role", default: "user"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "fb_uid"
    t.string "fb_token"
    t.string "google_uid"
    t.string "google_token"
    t.string "github_uid"
    t.string "github_token"
    t.string "name"
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "order_items", "sub_orders"
  add_foreign_key "orders", "users"
  add_foreign_key "shops", "users"
  add_foreign_key "sub_orders", "orders"
  add_foreign_key "user_coupons", "coupons"
  add_foreign_key "user_coupons", "users"
end
