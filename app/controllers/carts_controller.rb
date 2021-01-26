class CartsController < ApplicationController
  # before_action :authenticate_user! ,only:[:add_item]
  skip_before_action :verify_authenticity_token, only: :return

  def add_item
    if current_user
      product = Product.find(params[:id])
      quantity = JSON.parse(params.keys.filter{|i| i[/.amount/]}.first)["amount"].to_i
      current_cart.add_item(product.id, quantity)
      current_cart.shop_totalprice(product.shop_id)
      current_cart.cal_cart_total
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
      current_cart.add_item(product.id, quantity)
      current_cart.shop_totalprice(product.shop_id)
      current_cart.cal_cart_total
      shoptotal = current_cart.subtotals.filter {|total, shopid| shopid == product.shop_id}[0][0]
      session[:cartgo] = current_cart.serialize
      render json:{ status: 'ok',
                    count: current_cart.items.count,
                    total_price: current_cart.total_price,
                    change: quantity,
                    shoptotal: shoptotal,
                    shopID: product.shop_id
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

  def empty
    session[:cartgo] = nil
    redirect_to root_path, notice: '購物車已清除'
  end

  def destroy
    current_cart.destroy(params[:id].to_i)
    current_cart.cal_cart_total
    session[:cartgo] = current_cart.serialize
    redirect_to carts_path
  end

  def get_coupon_info
    coupon = Coupon.find(params[:id])
    user_coupons = current_user.user_coupons.where(coupon_id: params[:id])
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
end
