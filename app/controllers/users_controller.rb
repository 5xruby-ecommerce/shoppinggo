class UsersController < ApplicationController
  def add_coupon
    coupon_key = JSON.parse(params.keys.first)["coupon_key"].to_i

    @usercoupon = UserCoupon.new()
    @usercoupon.user_id = current_user.id
    @usercoupon.coupon_id = coupon_key
    @usercoupon.save
    render json: { coupon_taken: 'taken' }    
  end
end