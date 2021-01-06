class UsersController < ApplicationController
  def index 
    redirect_to root_path
  end
  def add_coupon

    # coupon_key = JSON.parse(params.keys.first)["coupon_key"].to_i
    coupon_key = JSON.parse(params.keys.filter{|i| i[/.coupon_key/]}.first)["coupon_key"].to_i
    user_own_coupon_key = current_user.user_coupon.pluck(:coupon_id).uniq
    @coupon = Coupon.find_by!(id: coupon_key)

    if (not user_own_coupon_key.include?(coupon_key)) && @coupon.counter_catch < @coupon.amount
      @usercoupon = current_user.user_coupon.create(coupon_id: coupon_key)
      @usercoupon.save 

      @coupon.increment(:counter_catch) 
      @coupon.save
      render json: { coupon_taken: 'taken' , rest: @coupon.amount-@coupon.counter_catch}  
    elsif (not user_own_coupon_key.include?(coupon_key)) && @coupon.counter_catch >= @coupon.amount
      render json: { error: '已被領完', rest: @coupon.amount-@coupon.counter_catch }
    elsif user_own_coupon_key.include?(coupon_key) && @coupon.counter_catch < @coupon.amount
      render json: { error: '已領取', rest: @coupon.amount-@coupon.counter_catch }
    else 
      render json: { error: '已領取', rest: @coupon.amount-@coupon.counter_catch}
    end  
  end
end