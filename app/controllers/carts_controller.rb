class CartsController < ApplicationController

  # before_action :authenticate_user! ,only:[:add_item]
  def add_item
    if current_user
      product = Product.find(params[:id])
      quantity = JSON.parse(params.keys.first)["amount"].to_i
      current_cart.add_item(product.id, quantity)
      session[:cartgo] = current_cart.serialize
      redirect_to root_path, notice: '已加入購物車'
    else
      redirect_to user_session_path
    end
  end

  def update_item
    if current_user
      product = Product.find(params[:id])
      quantity = JSON.parse(params.keys.first)["amount"].to_i
      current_cart.add_item(product.id, quantity)
      session[:cartgo] = current_cart.serialize
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
    # p '-----------------------'
    # p params
    # p '-----------------------'
    # result_ary = session[:cartgo]["items"].filter { |item| item["item_id"] != params[:item].to_i }
    # session[:cartgo] = { 'items' => result_ary }
    # render json: { p: params }
    # redirect_to carts_path, notice: "已刪除訂單"
    result_ary = session[:cartgo]["items"].filter { |item| item["item_id"] != params[:id].to_i }
    session[:cartgo] = { 'items' => result_ary }
    # render json: { p: params }
    redirect_to carts_path, notice: "已刪除訂單" 
  end
end
