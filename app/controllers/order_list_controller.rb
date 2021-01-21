class OrderListController < ApplicationController
  def index
    @orders = current_user.shop.orders
    render layout: "store"
  end
end