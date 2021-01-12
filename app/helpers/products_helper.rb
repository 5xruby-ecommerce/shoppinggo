module ProductsHelper
  def user_own_coupon?(coupon)
    if current_user.user_coupon.where(coupon_id: coupon).empty?
      return false
    else 
      return true
    end
  end

  def user_use_coupon?(coupon)
    if current_user.user_coupon.where(coupon_id: coupon).pluck(:coupon_status)[0] == 'used'
      return true
    else 
      return false
    end
  end
end
