class Usercoupon < ActiveRecord::Migration[6.0]
  def change
    create_table :user_coupons do |t|
      t.integer :coupon_status
      t.references :user, null: false, foreign_key: true
      t.references :coupon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
