module ProductsHelper
  def user_own_coupon?(coupon)
    if current_user.user_coupon.where(coupon_id: coupon).empty?
      return false
    else 
      return true
    end
  end
end
