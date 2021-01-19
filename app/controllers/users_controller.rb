class UsersController < ApplicationController
  layout "member"

  def index
    redirect_to root_path
  end

  def show
    @user = current_user
  end

  def add_coupon
    coupon_key = JSON.parse(params.keys.filter{|i| i[/.coupon_key/]}.first)["coupon_key"].to_i
    user_own_coupon_key = current_user.user_coupons.pluck(:coupon_id).uniq
    @coupon = Coupon.find_by!(id: coupon_key)

    if (not user_own_coupon_key.include?(coupon_key)) && @coupon.counter_catch < @coupon.amount
      @usercoupon = current_user.user_coupons.create(coupon_id: coupon_key)
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
    usercoupon = current_user.user_coupons.where(id: usercoupon_id)[0]
    shop_id = usercoupon.coupon.shop_id
    if usercoupon.may_use?
      usercoupon.use
      usercoupon.save
      current_cart.use_coupon(usercoupon_id, shop_id)
    elsif usercoupon.may_cancel?
      usercoupon.cancel
      usercoupon.save
      current_cart.unuse_coupon(usercoupon_id, shop_id)
    end
    current_cart.shop_totalprice(shop_id)
    current_cart.cal_cart_total
    session[:cartgo] = current_cart.serialize
    render json: {
      status: usercoupon.coupon_status,
      cart_total: current_cart.total,
      shop_total: current_cart.subtotals
    }
  end
end