module ProductsHelper
  def user_own_coupon?(coupon)
    UserCoupon.where(coupon_id: coupon, user_id: current_user) ? true : false
  end
end
