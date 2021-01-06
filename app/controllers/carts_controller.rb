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
      render json:{status: 'ok', 
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
  
  def get_coupon
    coupon = Coupon.find(params[:id])
    status = current_user.user_coupon.status
    own = user_own_coupon?(params[:id])
    # usercoupon = UserCoupon.where(user_id: current_user, coupon_id: params[:id]) ? "true" : "false"
    render json: { discount_rule: coupon[:discount_rule], 
                  discount_start: coupon_TimeWithZone_convert(coupon[:discount_start]),
                  discount_end: coupon_TimeWithZone_convert(coupon[:discount_end]),
                  min_consumption: coupon[:min_consumption],
                  discount_amount: coupon[:discount_amount],
                  amount: coupon[:amount],
                  counter_catch: coupon[:counter_catch],
                  occupy: own,
                  status: status
                  }
  end
end
