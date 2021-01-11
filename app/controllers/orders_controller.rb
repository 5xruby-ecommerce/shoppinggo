class OrdersController < ApplicationController

  def index
    @order = current_user.orders.all
  end
end