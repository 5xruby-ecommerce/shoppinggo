class CreateCouponModel < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.string :title
      t.integer :discount_rule
      t.datetime :discount_start
      t.datetime :discount_end
      t.integer :min_consumption
      t.integer :amount
      t.integer :counter_catch
      t.timestamps
    end

    add_reference :coupons, :shop, index:true
  end
end
