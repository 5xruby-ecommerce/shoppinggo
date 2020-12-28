class AddDiscountamountToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :discount_amount, :integer
  end
end
