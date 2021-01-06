class ChangeUserCouponStatusDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :user_coupons, :coupon_status, 0
  end
end
