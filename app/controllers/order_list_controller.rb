class OrderListController < ApplicationController
  layout 'store'

  def index
    @orders = current_user.shop.orders
  end

  def show
    @order = current_user.shop.orders.find(params[:id])
    @products = Product.joins(:sub_orders).where(sub_orders: {order: @order})
  end
end