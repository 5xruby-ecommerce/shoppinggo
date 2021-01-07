class UsersController < ApplicationController
  def index 
    redirect_to root_path
  end
  
  def add_coupon
    coupon_key = JSON.parse(params.keys.filter{|i| i[/.coupon_key/]}.first)["coupon_key"].to_i
    user_own_coupon_key = current_user.user_coupon.pluck(:coupon_id).uniq
    @coupon = Coupon.find_by!(id: coupon_key)

    if (not user_own_coupon_key.include?(coupon_key)) && @coupon.counter_catch < @coupon.amount
      @usercoupon = current_user.user_coupon.create(coupon_id: coupon_key)
      @usercoupon.save 

      @coupon.increment(:counter_catch) 
      @coupon.save
      msg = '領取'
    elsif (not user_own_coupon_key.include?(coupon_key)) && @coupon.counter_catch >= @coupon.amount
      msg = '已被領完'
    else 
      msg = '已領取'
    end  

    render json: { message: msg, rest: @coupon.amount-@coupon.counter_catch}
  end

  def change_coupon_status
    usercoupon_id = JSON.parse(params.keys.filter{|i| i[/.usercouponID/]}.first)["usercouponID"].to_i
    usercoupon = current_user.user_coupon.where(id: usercoupon_id)[0]
    if usercoupon.may_use?
      usercoupon.use
      usercoupon.save
      render json: {
        status: usercoupon.coupon_status
      }
    elsif usercoupon.may_cancel?
      usercoupon.cancel
      usercoupon.save
      render json: {
        status: usercoupon.coupon_status
      }
    end
  end
end