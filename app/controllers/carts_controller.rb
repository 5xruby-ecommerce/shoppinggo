class CartsController < ApplicationController

  # before_action :authenticate_user! ,only:[:add_item]
  def add_item
    if current_user
      product = Product.find(params[:id])
      quantity = JSON.parse(params.keys.filter{|i| i[/.amount/]}.first)["amount"].to_i
      current_cart.add_item(product.id, quantity, product.shop_id)
      session[:cartgo] = current_cart.serialize
      redirect_to root_path, notice: '已加入購物車'
    else
      redirect_to user_session_path
    end
  end

  def update_item
    if current_user
      product = Product.find(params[:id])
      quantity = JSON.parse(params.keys.filter{|i| i[/.amount/]}.first)["amount"].to_i
      current_cart.add_item(product.id, quantity, product.shop.id)
      session[:cartgo] = current_cart.serialize
      render json:{ status: 'ok', 
                    count: current_cart.items.count, 
                    total_price: current_cart.total_price,
                    change: quantity
                  }
    else
      redirect_to user_session_path
    end
  end

  def show
    if not current_user
      redirect_to user_session_path
    end
  end

  def checkout
    @order = Order.new
  end

  def cancel
    session[:cartgo] = nil
    redirect_to root_path, notice: '購物車已清除'
  end

  def destroy
    result_ary = session[:cartgo]["items"].filter { |item| item["item_id"] != params[:id].to_i }
    session[:cartgo] = { 'items' => result_ary }
    redirect_to carts_path, notice: "已刪除訂單" 
  end
  
  def get_coupon_info
    coupon = Coupon.find(params[:id])

    user_coupons = current_user.user_coupon.where(coupon_id: params[:id])
    own = !(user_coupons.empty?)

    if own
      status = user_coupons.pluck(:coupon_status)      
      id = user_coupons.pluck(:id)

      render json: { 
        discount_rule: coupon[:discount_rule], 
        discount_start: coupon_TimeWithZone_convert(coupon[:discount_start]),
        discount_end: coupon_TimeWithZone_convert(coupon[:discount_end]),
        min_consumption: coupon[:min_consumption],
        discount_amount: coupon[:discount_amount],
        amount: coupon[:amount],
        counter_catch: coupon[:counter_catch],
        usercoupon_id: id,
        occupy: own,
        status: status
      }
    else
      render json: {
        discount_rule: coupon[:discount_rule], 
        discount_start: coupon_TimeWithZone_convert(coupon[:discount_start]),
        discount_end: coupon_TimeWithZone_convert(coupon[:discount_end]),
        min_consumption: coupon[:min_consumption],
        discount_amount: coupon[:discount_amount],
        amount: coupon[:amount],
        counter_catch: coupon[:counter_catch],
        occupy: own
      } 
    end
  end

  def cal_totalprice
    usercoupon_id = JSON.parse(params.keys.filter{|i| i[/.usercouponID/]}.first)["usercouponID"].to_i
    shop_id = UserCoupon.where(id: usercoupon_id).pluck(:shop_id)
    current_cart.use_coupon(usercoupon_id)
    current_cart.totalprice_use_coupon(shop_id)
  end
end
