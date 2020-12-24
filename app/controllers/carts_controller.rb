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

  def show
    if not current_user
      redirect_to user_session_path
    end
  end

  def checkout
    @order = Order.new
  end

  def destroy
    session[:cartgo] = nil
    redirect_to root_path, notice: "購物車已清空"
  end
end
