class CartsController < ApplicationController
  def add_item
    product = Product.find(params[:id])
    quantity = JSON.parse(params.keys.first)["amount"].to_i
    current_cart.add_item(product.id, quantity)
    session[:cartgo] = current_cart.serialize

    redirect_to root_path, notice: '已加入購物車'
  end

  def show
  end

  def checkout
    @order = Order.new
  end

  def destroy
    session[:cartgo] = nil
    redirect_to root_path, notice: "購物車已清空"
  end
end
