class EditCouponCountercatchDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:coupons, :counter_catch, 0)
  end
end
